#!/bin/bash

# GitHub 仓库地址
REPO_URL="https://github.com/dd1kjid/vps-monitor.git"  # 替换为你的仓库地址

# 默认路径和端口
SERVER_DIR="/opt/vps_monitor_server"
CLIENT_DIR="/opt/vps_monitor_client"
DEFAULT_PORT=6000

# 颜色设置
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
NC="\033[0m" # 无颜色

# 分割线
divider() {
    echo -e "${GREEN}==========================================${NC}"
}

# 检查 root 权限
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}请以 root 权限运行此脚本！${NC}"
        exit 1
    fi
}

# 安装依赖
install_dependencies() {
    echo -e "${GREEN}安装必要依赖中...${NC}"
    apt update -y && apt install -y python3 python3-pip git curl
}

# 安装服务端
install_server() {
    echo -e "${GREEN}开始安装服务端...${NC}"
    install_dependencies
    rm -rf $SERVER_DIR
    git clone $REPO_URL $SERVER_DIR
    cd $SERVER_DIR/server || exit
    pip3 install -r requirements.txt

    read -p "请输入服务端运行端口（默认: $DEFAULT_PORT）: " SERVER_PORT
    SERVER_PORT=${SERVER_PORT:-$DEFAULT_PORT}

    nohup python3 server.py --port $SERVER_PORT > $SERVER_DIR/server.log 2>&1 &
    echo -e "${GREEN}服务端安装完成！运行端口: $SERVER_PORT${NC}"
    echo -e "${GREEN}访问
