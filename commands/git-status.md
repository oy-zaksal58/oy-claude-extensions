---
description: Git 상태 확인 및 다음 작업 제안
allowed-tools: Bash(git *)
---

# Git 상태 분석

## 현재 상태

- **브랜치**: !`git branch --show-current`
- **원격 동기화**: !`git status -sb | head -1`
- **변경된 파일**: !`git status --short`
- **최근 커밋 3개**: !`git log -3 --oneline`

## 분석 요청

위 정보를 바탕으로:

1. **현재 상태 요약**
   - 작업 중인 브랜치와 목적
   - 변경사항 개요

2. **주의사항 체크**
   - 민감한 파일(.env, secrets 등)이 스테이징되어 있는지
   - 커밋하면 안 되는 파일이 있는지

3. **다음 작업 제안**
   - 커밋이 필요한지
   - PR을 올릴 준비가 되었는지
   - 추가로 해야 할 작업
