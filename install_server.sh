#!/bin/bash

# 服务端和客户端的安装路径
SERVER_DIR="/opt/vps_monitor_server"
CLIENT_DIR="/opt/vps_monitor_agent"

# 菜单选项
echo "请选择操作："
echo "1) 安装服务端"
echo "2) 卸载服务端"
echo "3) 安装客户端"
echo "4) 卸载客户端"
echo "0) 退出"
read -p "请输入选项 [0-4]: " OPTION

case $OPTION in
1)
    # 安装服务端
    echo "开始安装服务端..."
    apt update -y && apt install -y python3 python3-pip git
    git clone https://github.com/<你的用户名>/vps-monitor.git $SERVER_DIR
    cd $SERVER_DIR/server
    pip3 install flask
    mkdir -p $SERVER_DIR
    nohup python3 server.py > $SERVER_DIR/server.log 2>&1 &
    echo "服务端安装完成！运行在默认端口 5000。"
    ;;
2)
    # 卸载服务端
    echo "开始卸载服务端..."
    pkill -f server.py
    rm -rf $SERVER_DIR
    echo "服务端卸载完成！"
    ;;
3)
    # 安装客户端
    echo "开始安装客户端..."
    apt update -y && apt install -y python3 python3-pip git
    git clone https://github.com/<你的用户名>/vps-monitor.git $CLIENT_DIR
    cd $CLIENT_DIR/client
    pip3 install requests
    nohup python3 agent.py > $CLIENT_DIR/agent.log 2>&1 &
    echo "客户端安装完成！"
    ;;
4)
    # 卸载客户端
    echo "开始卸载客户端..."
    pkill -f agent.py
    rm -rf $CLIENT_DIR
    echo "客户端卸载完成！"
    ;;
0)
    # 退出
    echo "已退出脚本。"
    exit 0
    ;;
*)
    # 输入无效
    echo "无效选项，请重新运行脚本并选择正确的操作。"
    exit 1
    ;;
esac
