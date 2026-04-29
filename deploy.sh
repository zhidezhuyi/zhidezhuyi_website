#!/bin/bash
set -e

# ===== 部署配置 =====
REMOTE_USER="root"
REMOTE_HOST="14.103.220.143"
REMOTE_PATH="/data/zhidezhuyi/website"
COMPOSE_FILE="/data/zhidezhuyi/docker-compose.yml"

# 颜色输出
GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${GREEN}[部署]${NC} $1"; }

# ===== 构建检查 =====
log "检查项目文件..."
if [ ! -f "index.html" ]; then
  echo "错误: 未找到 index.html，请在项目根目录运行此脚本"
  exit 1
fi

# ===== 上传代码 =====
log "上传代码到 ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}"
ssh "${REMOTE_USER}@${REMOTE_HOST}" "mkdir -p ${REMOTE_PATH}/css ${REMOTE_PATH}/js"
rsync -avz --delete \
  --exclude='.git' \
  --exclude='node_modules' \
  --exclude='deploy.sh' \
  ./ "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/"
log "代码上传完成"

# ===== 重启 Docker =====
log "通过 docker compose 重启服务..."
ssh "${REMOTE_USER}@${REMOTE_HOST}" "docker compose -f ${COMPOSE_FILE} up -d --build"
log "部署完成!"
