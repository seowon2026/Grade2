#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

courses=(
    "Data-Structure"
    "Web-Programming1"
    "IoT-Basic-Experiment"
    "Logic-Circuit"
    "Algorithm"
    "Return-Project"
    "SU-Career-Coaching-II"
)

usage() {
    echo "사용법: bash allgit.sh [--dry-run]"
}

dry_run=false
case "${1:-}" in
    "")
        ;;
    --dry-run)
        dry_run=true
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        usage
        exit 1
        ;;
esac

read -p "전체 커밋 메시지: " msg

if [ -z "$msg" ]; then
    msg="($(date '+%Y-%m-%d %H:%M:%S')) 업데이트 완료"
fi

parent_origin="$(git remote get-url origin)"
if [ "$parent_origin" != "https://github.com/seowon2026/Grade2.git" ]; then
    echo "중단: 2Grade origin이 예상과 다릅니다."
    echo "현재 origin: $parent_origin"
    exit 1
fi

cleanup() {
    set +e
    bash gitname.sh korean >/dev/null
}
trap cleanup EXIT

bash gitname.sh english

for course in "${courses[@]}"; do
    if [ ! -d "$course" ]; then
        echo "건너뜀: $course 폴더 없음"
        continue
    fi

    if [ ! -f "$course/.git" ] && [ ! -d "$course/.git" ]; then
        echo "건너뜀: $course Git 저장소 아님"
        continue
    fi

    if ! git -C "$course" remote get-url origin >/dev/null 2>&1; then
        echo "중단: $course origin 없음"
        exit 1
    fi

    git -C "$course" branch -M main

    echo "업로드: $course"
    if [ "$dry_run" = true ]; then
        git -C "$course" status --short --branch
        continue
    fi

    git -C "$course" add .
    if git -C "$course" diff --cached --quiet; then
        echo "$course 변경사항 없음"
    else
        git -C "$course" commit -m "$msg"
    fi
    git -C "$course" push -u origin main
done

git submodule sync --recursive

if [ "$dry_run" = true ]; then
    git status --short --branch
    exit 0
fi

git add .gitmodules gitname.sh allgit.sh setup_subject_repos.sh "${courses[@]}"

if git diff --cached --quiet; then
    echo "2Grade 변경사항 없음"
else
    git commit -m "$msg"
fi
git push -u origin main
