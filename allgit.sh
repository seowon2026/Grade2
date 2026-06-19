#!/bin/bash
set -euo pipefail

read -p "전체 커밋 메시지: " msg

if [ -z "$msg" ]; then
    msg="($(date '+%Y-%m-%d %H:%M:%S')) 업데이트 완료"
fi

courses=(
    "Web-Programming1"
    "Data-Structure"
    "Logic-Circuit"
    "IoT-Basic-Experiment"
    "Algorithm"
    "Return-Project"
    "SU-Career-Coaching-II"
)

bash gitname.sh english

cleanup() {
    bash gitname.sh korean
}
trap cleanup EXIT

for course in "${courses[@]}"; do
    if [ ! -d "$course" ]; then
        echo "건너뜀: $course 폴더 없음"
        continue
    fi

    if ! git -C "$course" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "건너뜀: $course Git 저장소 아님"
        continue
    fi

    echo "업로드: $course"
    git -C "$course" add .
    if git -C "$course" diff --cached --quiet; then
        echo "$course 변경사항 없음"
    else
        git -C "$course" commit -m "$msg"
    fi
    git -C "$course" push origin main
done

git add .
if git diff --cached --quiet; then
    echo "2Grade 변경사항 없음"
else
    git commit -m "$msg"
fi
git push origin main
