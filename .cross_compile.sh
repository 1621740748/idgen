#!/usr/bin/env bash

set -e

DIST_PREFIX="idgen"
TARGET_DIR="dist"
PLATFORMS="darwin/amd64 darwin/arm64 linux/386 linux/amd64 linux/arm linux/arm64"

BUILD_VERSION=$(cat version)
BUILD_DATE=$(date "+%F %T")
COMMIT_SHA1=$(git rev-parse HEAD)

rm -rf ${TARGET_DIR}
mkdir ${TARGET_DIR}

for pl in ${PLATFORMS}; do
    export GOOS=$(echo ${pl} | cut -d'/' -f1)
    export GOARCH=$(echo ${pl} | cut -d'/' -f2)
    export CGO_ENABLED=0
    export TARGET=${TARGET_DIR}/${DIST_PREFIX}_${GOOS}_${GOARCH}
    if [ "${GOOS}" == "windows" ]; then
        export TARGET=${TARGET_DIR}/${DIST_PREFIX}_${GOOS}_${GOARCH}.exe
    fi

    echo "build => ${TARGET}"
    go build -trimpath -o ${TARGET} \
            -ldflags    "-X 'github.com/mritd/idgen/cmd.Version=${BUILD_VERSION}' \
                        -X 'github.com/mritd/idgen/cmd.BuildDate=${BUILD_DATE}' \
                        -X 'github.com/mritd/idgen/cmd.CommitID=${COMMIT_SHA1}'\
                        -w -s"
done

