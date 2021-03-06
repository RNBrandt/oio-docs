#!/bin/bash -e

set -x

mkdir -p result-docs

TAGS=${1:-ubuntu debian centos}
INDEX=doc/install-guide/source/index.rst

cp -f ${INDEX} ${INDEX}.save
trap "mv -f ${INDEX}.save ${INDEX}" EXIT

for tag in $TAGS; do

    title=$(grep -A 5 "^.. only:: ${tag}" ${INDEX} | head -6 | \
        sed -n 4p | sed -e 's/^*//g')

    sed -i -e "s/\.\. title::.*/.. title:: ${title}/" ${INDEX}

    tools/build-rst.sh doc/install-guide \
        --tag ${tag} \
        --target "draft/install-guide-${tag}"
    cp -f ${INDEX}.save ${INDEX}
done
