TAG="v1"
docker buildx build --platform linux/arm64,linux/amd64 -t surawatprem/chat-fe:$TAG . --push