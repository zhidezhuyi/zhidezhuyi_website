# 值得注意科技 — 官网

zhidezhuyi.com 静态官网，展示公司业务、产品、联系方式等。

## 技术栈

- 纯静态 HTML/CSS/JS（无框架）
- Nginx 静态文件服务
- Let's Encrypt SSL 证书
- Docker Compose 部署

## 服务器架构

```
/srv/
├── nginx/                     # 公共 nginx（独立服务）
│   ├── docker-compose.yml     # nginx 容器定义
│   ├── conf.d/default.conf    # 主配置 + knoweat 代理
│   ├── html/                  # 默认 html（空）
│   ├── logs/                  # nginx 日志
│   └── certbot/www/           # ACME 验证目录
├── zhidezhuyi/
│   └── website/               # 本站静态文件（nginx 直接读取）
│       ├── index.html
│       ├── css/
│       ├── js/
│       └── images/
└── knoweat/                   # 知食后端（独立 docker-compose）
    └── ...

容器：nginx (shared 网络) ← proxy → knoweat-server

## 仓库结构

```
website/
├── site/                      # 需要上传到服务器的静态站点目录
│   ├── index.html
│   ├── css/
│   ├── js/
│   └── images/
├── deploy.sh
└── CLAUDE.md
```
```

## 部署

```bash
bash deploy.sh
```

流程：rsync 上传 `site/` 目录内容到 `/srv/zhidezhuyi/website/` → 在 `/srv/nginx/` 执行 `docker compose up -d` 重载。

## 域名

| 域名 | 用途 |
|------|------|
| zhidezhuyi.com | 主站（HTTPS） |
| knoweat.zhidezhuyi.com | 知食 API |

DNS 托管在阿里云，A 记录指向 `14.103.220.143`。
