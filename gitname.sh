#!/bin/bash
set -euo pipefail

# 평소에는 한글 폴더명으로 사용하고, GitHub 업로드/서브모듈 작업 때는
# 영문 폴더명으로 전환한다.
#
# 사용법:
#   bash gitname.sh             # 현재 상태의 반대 방향으로 토글
#   bash gitname.sh korean      # 한글 폴더명으로 강제 전환
#   bash gitname.sh english     # 영문 폴더명으로 강제 전환
#   bash gitname.sh status      # 현재 폴더명 상태 확인

declare -a korean_names=(
    "데이터구조"
    "웹프로그래밍1"
    "IoT기초실험"
    "논리회로"
    "알고리즘"
    "리턴 프로젝트 (비교과)"
    "ＳＵ진로코칭Ⅱ"
)

declare -a english_names=(
    "Data-Structure"
    "Web-Programming1"
    "IoT-Basic-Experiment"
    "Logic-Circuit"
    "Algorithm"
    "Return-Project"
    "SU-Career-Coaching-II"
)

mode="${1:-toggle}"

update_worktree() {
    local english="$1"
    local path="$2"
    local module_config=".git/modules/$english/config"

    if [ -f "$module_config" ]; then
        git config --file "$module_config" core.worktree "../../../$path"
    fi
}

rename_one() {
    local korean="$1"
    local english="$2"
    local target="$3"

    case "$target" in
        english)
            if [ -d "$korean" ] && [ -d "$english" ]; then
                echo "충돌: '$korean'와 '$english'가 모두 있습니다."
                return 1
            elif [ -d "$korean" ]; then
                mv "$korean" "$english"
                echo "$korean -> $english"
            elif [ -d "$english" ]; then
                echo "$english 유지"
            else
                echo "$korean / $english 둘 다 없음"
                return 0
            fi
            update_worktree "$english" "$english"
            ;;
        korean)
            if [ -d "$korean" ] && [ -d "$english" ]; then
                echo "충돌: '$korean'와 '$english'가 모두 있습니다."
                return 1
            elif [ -d "$english" ]; then
                mv "$english" "$korean"
                echo "$english -> $korean"
            elif [ -d "$korean" ]; then
                echo "$korean 유지"
            else
                echo "$korean / $english 둘 다 없음"
                return 0
            fi
            update_worktree "$english" "$korean"
            ;;
        status)
            if [ -d "$korean" ] && [ -d "$english" ]; then
                echo "both: $korean / $english"
            elif [ -d "$korean" ]; then
                echo "korean: $korean"
            elif [ -d "$english" ]; then
                echo "english: $english"
            else
                echo "missing: $korean / $english"
            fi
            ;;
    esac
}

if [ "$mode" = "toggle" ]; then
    mode="english"
    for korean in "${korean_names[@]}"; do
        if [ -d "$korean" ]; then
            mode="english"
            break
        fi
    done

    has_korean=false
    has_english=false
    for i in "${!korean_names[@]}"; do
        [ -d "${korean_names[$i]}" ] && has_korean=true
        [ -d "${english_names[$i]}" ] && has_english=true
    done

    if [ "$has_korean" = false ] && [ "$has_english" = true ]; then
        mode="korean"
    fi
fi

case "$mode" in
    korean|english|status) ;;
    *)
        echo "사용법: bash gitname.sh [korean|english|status]"
        exit 1
        ;;
esac

for i in "${!korean_names[@]}"; do
    rename_one "${korean_names[$i]}" "${english_names[$i]}" "$mode"
done
