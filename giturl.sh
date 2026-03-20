#!/bin/bash
# Git 저장소 URL 설정 스크립트

# 사용자에게 저장소 URL 입력받기
read -p "원격 저장소 URL을 입력하세요: " repo_url

# 로컬 저장소 초기화
git init

# 원격 저장소(origin) 설정
git remote add origin "$repo_url"

# 브랜치 이름을 main으로 변경 (필요 시)
git branch -M main

echo "저장소가 성공적으로 설정되었습니다."
echo "원격 저장소: $repo_url"