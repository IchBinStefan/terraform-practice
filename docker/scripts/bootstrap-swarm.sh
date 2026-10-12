#!/usr/bin/env bash

set -euo pipefail

PROXY_NAME="swarm-proxy"
NETWORK_NAME="swarm-net"
MANAGER_NAME="swarm-manager"
WORKERS=("swarm-worker-1" "swarm-worker-2")

clean_up() {
    echo "removing containers and the network..."
    docker rm -f "$PROXY_NAME"
    docker rm -f "$MANAGER_NAME" "${WORKERS[@]}" 2>/dev/null || true
    docker network rm "$NETWORK_NAME" 2>/dev/null || true
}

create_network() {
    echo "creating network $NETWORK_NAME..."
    docker network create "$NETWORK_NAME"
}

# proxy to be able to see the server page on macos
start_socat_node() {
    docker run -d \
      --name $PROXY_NAME \
      --network swarm-net \
      -p 8081:8080 \
      alpine/socat TCP-LISTEN:8080,fork,reuseaddr TCP-CONNECT:swarm-manager:8080
}

start_nodes() {
    echo "starting manager node..."
    docker run -d \
      --name "$MANAGER_NAME" \
      --privileged \
      --network "$NETWORK_NAME" \
      -e DOCKER_TLS_CERTDIR="" \
      -p 2375:2375 \
      -p 8080:8080 \
      docker:latest --tls=false --host=tcp://0.0.0.0:2375

    for WORKER in "${WORKERS[@]}"; do
      echo "starting worker node $WORKER..."
      docker run -d \
        --name "$WORKER" \
        --privileged \
        --network "$NETWORK_NAME" \
        -e DOCKER_TLS_CERTDIR="" \
        docker:latest --tls=false
    done
}

wait_for_manager() {
    echo "waiting for manager daemon to start..."
    until docker exec "$MANAGER_NAME" docker info >/dev/null 2>&1; do
      sleep 1
    done
}

initialize_swarm() {
    echo "initializing swarm mode..."
    docker exec \
      "$MANAGER_NAME" \
      docker swarm init \
      --advertise-addr eth0 >/dev/null
}

get_swarm_token() {
    JOIN_TOKEN=$(docker exec "$MANAGER_NAME" docker swarm join-token -q worker)
}

join_workers() {
    for WORKER in "${WORKERS[@]}"; do
      echo "$WORKER joining the swarm..."
      docker exec "$WORKER" docker swarm join --token "$JOIN_TOKEN" "$MANAGER_NAME:2377" >/dev/null
    done
}

main() {
    clean_up
    create_network
    start_socat_node

    sleep 5

    start_nodes
    wait_for_manager
    initialize_swarm
    get_swarm_token
    join_workers

    sleep 8

    docker exec "$MANAGER_NAME" docker node ls
}

main "$@"
