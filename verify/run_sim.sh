#!/bin/bash
# Usage: verify/run_sim.sh   (from anywhere). Needs docker + ghcr.io/efabless/openlane2:2.3.10.
cd "$(dirname "$0")/.."
bash verify/prepare.sh
mkdir -p verify/results
MOUNTS="-v $PWD/rtl_orig:/rtl_orig:ro -v $PWD/src:/src:ro -v $PWD/verify:/v"
[ -d src_x0 ] && MOUNTS="$MOUNTS -v $PWD/src_x0:/src_x0:ro"
docker run --rm --cpus=1 $MOUNTS --entrypoint sh ghcr.io/efabless/openlane2:2.3.10 /v/sim_inner.sh
bash verify/compare.sh
