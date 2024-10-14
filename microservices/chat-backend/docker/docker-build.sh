#Local build only
TAG="v3"

docker buildx build --platform linux/arm64,linux/amd64 -f docker/Dockerfile -t surawatprem/chat-backend:$TAG . --push