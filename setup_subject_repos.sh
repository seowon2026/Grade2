#!/bin/bash
set -euo pipefail

# 새 과목 폴더를 GitHub 저장소 + 서브모듈로 등록한다.
# 기본 owner는 기존 저장소와 맞춘 seowon2026이다.
#
# 사용법:
#   bash setup_subject_repos.sh
#   GITHUB_OWNER=hy040504 bash setup_subject_repos.sh

owner="${GITHUB_OWNER:-seowon2026}"

declare -a repos=(
    "Algorithm"
    "Return-Project"
    "SU-Career-Coaching-II"
)

get_credential() {
    printf 'protocol=https\nhost=github.com\n\n' | git credential fill
}

credential="$(get_credential)"
username="$(printf '%s\n' "$credential" | sed -n 's/^username=//p')"
password="$(printf '%s\n' "$credential" | sed -n 's/^password=//p')"

if [ -z "$username" ] || [ -z "$password" ]; then
    echo "GitHub credential을 찾지 못했습니다."
    exit 1
fi

api() {
    curl -sS -u "$username:$password" "$@"
}

auth_login="$(api https://api.github.com/user | sed -n 's/.*"login"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"

if [ "$owner" != "$auth_login" ]; then
    owner_type="$(api "https://api.github.com/users/$owner" | sed -n 's/.*"type"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
    if [ "$owner_type" != "Organization" ]; then
        echo "현재 인증 계정은 '$auth_login'이고, '$owner'는 조직이 아닌 사용자 계정입니다."
        echo "'$owner' 아래 새 저장소를 자동 생성하려면 '$owner' 계정 토큰이 필요합니다."
        echo "현재 계정 아래 만들려면: GITHUB_OWNER=$auth_login bash setup_subject_repos.sh"
        exit 1
    fi
fi

bash gitname.sh english

for repo in "${repos[@]}"; do
    repo_url="https://github.com/$owner/$repo.git"

    status="$(curl -sS -u "$username:$password" -o /dev/null -w '%{http_code}' "https://api.github.com/repos/$owner/$repo")"
    if [ "$status" = "404" ]; then
        echo "GitHub 저장소 생성: $owner/$repo"
        if [ "$owner" = "$auth_login" ]; then
            create_url="https://api.github.com/user/repos"
        else
            create_url="https://api.github.com/orgs/$owner/repos"
        fi
        api -H "Accept: application/vnd.github+json" \
            -X POST "$create_url" \
            -d "{\"name\":\"$repo\",\"private\":false}" >/dev/null
    elif [ "$status" = "200" ]; then
        echo "GitHub 저장소 있음: $owner/$repo"
    else
        echo "GitHub 저장소 확인 실패: $owner/$repo HTTP $status"
        exit 1
    fi

    if [ ! -d "$repo" ]; then
        echo "폴더 없음: $repo"
        continue
    fi

    if [ ! -d "$repo/.git" ] && [ ! -f "$repo/.git" ]; then
        git -C "$repo" init
        git -C "$repo" branch -M main
    fi

    if git -C "$repo" remote get-url origin >/dev/null 2>&1; then
        git -C "$repo" remote set-url origin "$repo_url"
    else
        git -C "$repo" remote add origin "$repo_url"
    fi

    git -C "$repo" add .
    if ! git -C "$repo" diff --cached --quiet; then
        git -C "$repo" commit -m "Initial commit"
    fi
    git -C "$repo" push -u origin main

    if ! git config --file .gitmodules --get "submodule.$repo.path" >/dev/null 2>&1; then
        git config --file .gitmodules "submodule.$repo.path" "$repo"
        git config --file .gitmodules "submodule.$repo.url" "$repo_url"
    fi
done

git submodule absorbgitdirs Algorithm Return-Project SU-Career-Coaching-II 2>/dev/null || true

for repo in "${repos[@]}"; do
    if [ -f ".git/modules/$repo/config" ]; then
        git config --file ".git/modules/$repo/config" core.worktree "../../../$repo"
    fi
done

git add .gitmodules Algorithm Return-Project SU-Career-Coaching-II
echo "새 과목 저장소 설정 완료. 부모 저장소 커밋은 allgit.sh에서 처리합니다."
