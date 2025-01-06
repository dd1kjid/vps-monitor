#!/bin/bash

# 检查是否以root用户运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请以root权限运行此脚本！"
    exit 1
fi

# 安装依赖
echo "安装必要依赖..."
apt update -y && apt install -y python3 python3-pip git iputils-ping

# 输入服务端 IP 和端口
echo "请输入服务端IP地址（例如：192.168.1.100）："
read -r SERVER_IP
echo "请输入服务端监听端口（默认5000）："
read -r SERVER_PORT
SERVER_PORT=${SERVER_PORT:-5000}

# 克隆代码仓库
echo "克隆客户端代码..."
git clone https://github.com/<你的用户名>/vps-monitor.git /opt/vps_monitor_agent
cd /opt/vps_monitor_agent/client

# 替换服务端地址
sed -i "s|SERVER_URL = .*|SERVER_URL = \"http://${SERVER_IP}:${SERVER_PORT}/api/data\"|g" agent.py

# 安装Python依赖
echo "安装Python依赖..."
pip3 install psutil requests

# 启动客户端
echo "启动探针..."
nohup python3 agent.py > /opt/vps_monitor_agent/agent.log 2>&1 &

echo "探针安装完成！数据将发送到 http://${SERVER_IP}:${SERVER_PORT}/api/data。"
echo "查看日志：tail -f /opt/vps_monitor_agent/agent.log"
