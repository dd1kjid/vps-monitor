#!/bin/bash

# 检查是否以root用户运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请以root权限运行此脚本！"
    exit 1
fi

# 安装依赖
echo "安装必要依赖..."
apt update -y && apt install -y python3 python3-pip git

# 克隆代码仓库
echo "克隆服务端代码..."
git clone https://github.com/<你的用户名>/vps-monitor.git /opt/vps_monitor_server
cd /opt/vps_monitor_server/server

# 安装Python依赖
echo "安装Python依赖..."
pip3 install flask

# 启动服务端
echo "启动服务端..."
nohup python3 server.py > /opt/vps_monitor_server/server.log 2>&1 &

echo "服务端安装完成！运行在5000端口。"
echo "访问 http://<你的IP>:5000/api/status 查看所有VPS状态。"
