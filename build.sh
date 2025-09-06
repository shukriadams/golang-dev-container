# fail on all errors
set -e

DOCKERPUSH=0
SMOKETEST=0
BUILD=0
COMPOSE="docker-compose"

while [ -n "$1" ]; do 
    case "$1" in
    --push|-p) DOCKERPUSH=1 ;;
    --test|-t) SMOKETEST=1 ;;
    --build|-b) BUILD=1 ;;
    --github-compose) COMPOSE="docker compose" ;;
    esac 
    shift
done

if [ $BUILD -eq 1 ]; then
    $COMPOSE down
    sudo rm -rf  ./../tmp

    # force remove existing image to all layers rebuild, this is for local environments only. on github 
    # build environment is reset by default
    docker rmi shukriadams/golang-dev-container:latest -f
    docker build -t shukriadams/golang-dev-container .
    echo "build complete"
else
    echo "build skipped, use --build to enable"
fi

if [ $SMOKETEST -eq 1 ]; then
    OUT=$(docker run shukriadams:golang-dev-container go version)
    echo $OUT | grep "go version"
    echo "test complete"
else
    echo "test skipped, use --test to enable"
fi

if [ $DOCKERPUSH -eq 1 ]; then
    TAG=$(git describe --tags --abbrev=0) 
    docker tag shukriadams/golang-dev-container:latest shukriadams/golang-dev-container:$TAG 
    docker push shukriadams/golang-dev-container:$TAG
    docker push shukriadams/golang-dev-container:latest
    echo "Push complete"
else
    echo "push to docker skipped, use --push to enable"
fi

echo "Done!"