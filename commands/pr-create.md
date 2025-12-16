---
description: PR 생성 도우미
allowed-tools: Bash(git *), Bash(gh *)
---

# PR 생성 도우미

## 현재 브랜치 정보

- **브랜치명**: !`git branch --show-current`
- **base 브랜치와 차이**: !`git log origin/main..HEAD --oneline 2>/dev/null || git log origin/master..HEAD --oneline`

## 변경사항 분석

!`git diff origin/main..HEAD --stat 2>/dev/null || git diff origin/master..HEAD --stat`

## PR 작성

위 변경사항을 분석하여 다음 형식의 PR을 작성해주세요:

### PR 제목

```
[타입] 간결한 설명 (50자 이내)

타입: feat, fix, refactor, docs, test, chore
```

### PR 본문

```markdown
## 📋 개요

- 이 PR의 목적

## 🔄 변경사항

- 주요 변경 내용 bullet point

## 🧪 테스트

- [ ] 단위 테스트 통과
- [ ] 통합 테스트 통과
- [ ] 수동 테스트 완료

## 📝 참고사항

- 리뷰어가 알아야 할 내용
- 관련 이슈/문서 링크
```

## 다음 단계

PR 내용이 확정되면:

```bash
gh pr create --title "제목" --body "본문"
```
