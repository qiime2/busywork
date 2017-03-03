#!/bin/bash

set -e -x

next_release="$(cat next-release/next-release)"
cd q2-branching-scheme
current_release="$(head -n 1 code.txt | sed s/version=// | cut -f1,2 -d'.')"
next_version=$next_release.0.dev0
git branch develop/$current_release
sed s/version=.*/version=$next_version/g code.txt > tmp.txt
mv tmp.txt code.txt
git add code.txt
git commit -m "REL: $next_version version bump"
git push origin develop/main
git push origin develop/$current_release
