#!/bin/bash

set -e
archmini="${BOOTSTRAP-arch-mini-bootstrap_2015-05-26}"

function cleanup {
  echo ""
  echo -e "\033[1;34m=>\033[m Removing ${archmini}"
  rm "${archmini}.*"
}
trap cleanup EXIT

echo -e "\033[1;34m=>\033[m Downloading ${archmini}"
curl -o "${archmini}.tar.xz" -L'#' "https://www.dropbox.com/s/ijgjngu4mw35yby/${archmini}.tar.xz?dl=1"
curl -o "${archmini}.sha512" -L'#' "https://www.dropbox.com/s/ijgjngu4mw35yby/${archmini}.sha512?dl=1"
echo -e "\033[1;34m=>\033[m Verifying ${archmini}"
sha512sum -c "${archmini}.sha512"

echo ""
echo -e "\033[1;34m=>\033[m Building container"
docker build -t "${DOCKER_TAG-"casualjim/arch-mini"}" .
