#!/bin/bash
set -e
# 脚本路径，替换成自己的compose路径
DOCKER_COMPOSE_DIR="/home/ubuntu/packages/palworld/"

# ==========【重启 Palworld docker】=========

function restart_docker() {
    echo ">>准备执行重启PalWorld服务<<"
    echo "#>:[1/4].寻找 PalWorld 的 docker-compose.yml 文件"
    cd $DOCKER_COMPOSE_DIR || exit 0
    echo "#>:[2/4].获取服务器信息"
    server_info=$(docker-compose run --rm rcon Info)
    regex_1="refused$"
    if [[ $server_info =~ $regex_1 ]]; then
        echo "#>:[2/4].容器未运行，请先启动容器"
        exit 0
    else
        echo "#>:[2/4].$server_info"
    fi
    echo "#>:[3/4].检查是否有玩家在线"
    players_info=$(docker-compose run --rm rcon ShowPlayers | tr -d '[:space:]' | tr -d '\r' | tr -d '\n')
    echo "#>:[3/4].输出玩家列表:"
    echo "#>:[3/4].$players_info"
    regex_2="^name,playeruid,steamid$"
    if [[ $players_info =~ $regex_2 ]]; then
        echo "#>:[4/4]没有检测到在线玩家，正在重启docker容器。"
        docker-compose restart
    else
        echo "#>:[4/4]检测到在线玩家，不执行重启。"
    fi
    exit 0
}

restart_docker > /home/ubuntu/packages/palworld/restart.log 2>&1
