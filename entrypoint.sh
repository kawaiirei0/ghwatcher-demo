#!/bin/sh
set -e

# 定义项目目录和仓库地址
REPO_URL="https://github.com/rei0721/ghhook-server.git"
PROJECT_DIR="/app/source" # 源码放在子目录，保持 /app 整洁
BINARY_PATH="/app/gh"
BINARY_SERVER_PATH="/app/server"

echo ">>> 检查网络连接..."
# 简单检查，确保能连上 GitHub，如果环境特殊可能需要配置代理
git config --global http.sslVerify false

echo ">>> 正在处理源码..."
if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo ">>> 目录为空，正在克隆仓库..."
    # 强制创建目录
    mkdir -p "$PROJECT_DIR"
    git clone "$REPO_URL" "$PROJECT_DIR"
else
    echo ">>> 仓库已存在，正在拉取最新代码..."
    cd "$PROJECT_DIR"
    git fetch origin
    git reset --hard origin/main || git reset --hard origin/master
fi

# 进入项目目录
cd "$PROJECT_DIR"

echo ">>> 安装依赖..."
# 设置 Go 代理，防止国内网络拉取失败
export GOPROXY=https://goproxy.cn,direct
go mod tidy

echo ">>> 开始构建..."
# 将二进制文件输出到 /app/gh
go build -o "$BINARY_PATH" .

echo ">>> 赋予执行权限..."
chmod +x "$BINARY_PATH"

echo ">>> 启动应用程序..."
echo ">>> 监听端口范围: 9900-9999"
# 执行二进制文件
# exec "$BINARY_PATH"


echo ">>> 启动应用程序..."

# --- 关键修改开始 ---

# 启动第一个服务 (假设程序接受 -port 参数，监听 9901)
# & 符号让它在后台运行
# 2>&1 | sed ... 的作用是给日志每一行加个前缀，方便你区分
"$BINARY_PATH" -port 9901 2>&1 | sed 's/^/[服务-9901] /' &

# 启动第二个服务 (监听 9999)
"$BINARY_SERVER_PATH" -port 9999 2>&1 | sed 's/^/[服务-9999] /' &

# 【非常重要】
# 如果脚本直接结束，容器就会退出。
# wait 命令会挂起脚本，等待所有后台任务结束。
# 这样 Docker 容器才会一直运行，且能持续接收到上面两个服务的日志。
echo ">>> 所有服务已在后台启动，开始监听日志..."
wait

# --- 关键修改结束 ---