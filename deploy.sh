#!/bin/bash

set -euo pipefail

hugo

pushd public

git add -A
git commit -m "Rebuild site for $(date -Iseconds)"
git push origin master

popd
