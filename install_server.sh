#!/bin/bash

# 检查是否以root用户运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请以root权限运行此脚本！"
    exit 1
fi

# 安装依赖
echo "安装必要依赖..."
apt update -y && apt install -y python3 python3-pip git

# 输入服务端监听的端口
echo "请输入服务端监听的端口（默认5000）："
read -r SERVER_PORT
SERVER_PORT=${SERVER_PORT:-5000}

# 克隆代码仓库
echo "克隆服务端代码..."
git clone https://github.com/<你的用户名>/vps-monitor.git /opt/vps_monitor_server
cd /opt/vps_monitor_server/server

# 替换端口号
sed -i "s|port=5000|port=${SERVER_PORT}|g" server.py

# 确保日志文件的目录存在
mkdir -p /opt/vps_monitor_server

# 安装Python依赖
echo "安装Python依赖..."
pip3 install flask

# 启动服务端
echo "启动服务端..."
nohup python3 server.py > /opt/vps_monitor_server/server.log 2>&1 &

echo "服务端安装完成！运行在${SERVER_PORT}端口。"
echo "访问 http://<你的IP>:${SERVER_PORT}/api/status 查看所有VPS状态。"
