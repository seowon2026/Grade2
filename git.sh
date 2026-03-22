#!/bin/bash

read -p "(2Grade) 커밋 메시지: " msg

# 입력이 비었으면 기본 메시지 사용
if [ -z "$msg" ]; then
    msg="($(date '+%Y-%m-%d %H:%M:%S')) 업데이트 완료"

fi

git add .
git commit -m "$msg"
git push origin main
# git push origin main --force (강제)
# git push origin main --force-with-lease (좀 더 안전한 강제성)