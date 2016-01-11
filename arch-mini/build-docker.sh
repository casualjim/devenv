#!/bin/bash

set -e
archmini="arch-mini-bootstrap_$(date +%Y-%m-%d)"

function cleanup {
  echo ""
  echo -e "\033[1;34m=>\033[m Removing ${archmini}"
  rm "${archmini}".*
}
trap cleanup EXIT

echo -e "\033[1;34m=>\033[m Downloading ${archmini}"

curl -o "${archmini}.tar.xz" -L'#' "https://www.dropbox.com/s/t5fh51qadsamdiw/arch-mini-bootstrap_2015-12-29.tar.xz?dl=1"
curl -o "${archmini}.sha512" -L'#' "https://www.dropbox.com/s/ecoenpcraf8ojf8/arch-mini-bootstrap_2015-12-29.sha512?dl=1"
echo -e "\033[1;34m=>\033[m Verifying ${archmini}"
sha512sum -c "${archmini}.sha512"

echo ""
echo -e "\033[1;34m=>\033[m Building container"
docker build -t "${DOCKER_TAG-"casualjim/arch-mini"}" .
