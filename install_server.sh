#!/bin/bash

# 服务端和客户端的默认安装路径
SERVER_DIR="/opt/vps_monitor_server"
CLIENT_DIR="/opt/vps_monitor_client"

# Git 仓库地址（替换为你自己的仓库）
REPO_URL="https://github.com/dd1kjid/vps-monitor.git"

# 默认端口号
DEFAULT_PORT=6000

# 颜色定义
GREEN="\033[32m"
RED="\033[31m"
NC="\033[0m" # 无颜色

# 分割线
divider() {
    echo -e "${GREEN}------------------------------------------${NC}"
}

# 检查是否是 root 权限
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}请以 root 权限运行此脚本！${NC}"
        exit 1
    fi
}

# 安装依赖
install_dependencies() {
    echo -e "${GREEN}安装必要依赖...${NC}"
    apt update -y && apt install -y python3 python3-pip git
}

# 安装服务端
install_server() {
    echo -e "${GREEN}开始安装服务端...${NC}"
    install_dependencies
    rm -rf $SERVER_DIR
    git clone $REPO_URL $SERVER_DIR
    cd $SERVER_DIR/server
    pip3 install flask flask-socketio
    nohup python3 server.py --port $DEFAULT_PORT > $SERVER_DIR/server.log 2>&1 &
    echo -e "${GREEN}服务端安装完成！默认运行在端口 $DEFAULT_PORT。${NC}"
    echo -e "${GREEN}访问 http://<你的IP>:$DEFAULT_PORT 查看探针状态。${NC}"
}

# 卸载服务端
uninstall_server() {
    echo -e "${GREEN}开始卸载服务端...${NC}"
    pkill -f server.py || echo "服务端未运行。"
    rm -rf $SERVER_DIR
    echo -e "${GREEN}服务端卸载完成！${NC}"
}

# 安装客户端
install_client() {
    echo -e "${GREEN}开始安装客户端...${NC}"
    install_dependencies
    rm -rf $CLIENT_DIR
    git clone $REPO_URL $CLIENT_DIR
    cd $CLIENT_DIR/client
    pip3 install psutil requests
    # 配置服务端地址和端口
    read -p "请输入服务端的 IP 地址: " SERVER_IP
    read -p "请输入服务端的端口 (默认 $DEFAULT_PORT): " SERVER_PORT
    SERVER_PORT=${SERVER_PORT:-$DEFAULT_PORT}
    # 写入配置
    cat > config.json <<EOF
{
    "server_ip": "$SERVER_IP",
    "server_port": "$SERVER_PORT"
}
EOF
    nohup python3 agent.py > $CLIENT_DIR/client.log 2>&1 &
    echo -e "${GREEN}客户端安装完成！${NC}"
}

# 卸载客户端
uninstall_client() {
    echo -e "${GREEN}开始卸载客户端...${NC}"
    pkill -f agent.py || echo "客户端未运行。"
    rm -rf $CLIENT_DIR
    echo -e "${GREEN}客户端卸载完成！${NC}"
}

# 主菜单
main_menu() {
    check_root
    divider
    echo -e "${GREEN}VPS 监控探针管理脚本${NC}"
    echo "1) 安装服务端"
    echo "2) 卸载服务端"
    echo "3) 安装客户端"
    echo "4) 卸载客户端"
    echo "0) 退出"
    divider

    read -p "请输入选项 [0-4]: " OPTION
    case $OPTION in
    1)
        install_server
        ;;
    2)
        uninstall_server
        ;;
    3)
        install_client
        ;;
    4)
        uninstall_client
        ;;
    0)
        echo -e "${GREEN}已退出脚本。${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}无效选项，请重新运行脚本并选择正确的操作！${NC}"
        exit 1
        ;;
    esac
}

# 运行主菜单
main_menu
