TAG="v3"
docker buildx build --platform linux/arm64,linux/amd64 -t surawatprem/chat-backend:$TAG . --push