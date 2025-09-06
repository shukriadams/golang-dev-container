# fail on all errors
set -e

DOCKERPUSH=0
SMOKETEST=0
BUILD=0

while [ -n "$1" ]; do 
    case "$1" in
    --push|-p) DOCKERPUSH=1 ;;
    --test|-t) SMOKETEST=1 ;;
    --build|-b) BUILD=1 ;;
    esac 
    shift
done

if [ $BUILD -eq 1 ]; then
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