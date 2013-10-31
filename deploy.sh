#!/bin/bash

set -euo pipefail

(cd public && rm -r */)

hugo

pushd public

git add -A
git commit -m "Rebuild site for $(date -Iseconds)"
git push origin master

popd
