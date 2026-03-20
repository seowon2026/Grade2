#!/bin/bash

read -p "커밋 메시지: " msg

git add .
git commit -m "$msg"
git push origin main
# git push origin main --force (강제)
# git push origin main --force-with-lease (좀 더 안전한 강제성)