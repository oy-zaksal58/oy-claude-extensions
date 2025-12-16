---
description: 배포 전 검증 체크리스트
argument-hint: [environment: dev|stg|prd]
allowed-tools: Bash(git *), Bash(npm *), Read
---

# 배포 전 검증: $ARGUMENTS 환경

## 1. Git 상태 확인

- **현재 브랜치**: !`git branch --show-current`
- **커밋되지 않은 변경**: !`git status --short`
- **최신 커밋**: !`git log -1 --oneline`
- **원격과 동기화**: !`git status -sb | head -1`

## 2. 검증 체크리스트

### 필수 확인 항목

- [ ] 올바른 브랜치인가? (prd는 main/master에서만)
- [ ] 모든 변경사항이 커밋되었는가?
- [ ] 원격 저장소와 동기화되었는가?
- [ ] PR이 승인되었는가?

### 환경별 추가 확인

- **dev**: 자유롭게 배포 가능
- **stg**: QA 승인 필요, 테스트 통과 확인
- **prd**: 배포 윈도우 확인, 롤백 계획 수립

## 3. 판정

위 검증 결과를 바탕으로:

1. **GO / NO-GO** 판정
2. NO-GO인 경우 해결 방법 제시
3. 배포 전 추가로 확인할 사항

## 주의사항

⚠️ **prd 배포 시**:

- 반드시 배포 윈도우 시간 확인
- 롤백 계획 준비
- 모니터링 대시보드 열어두기
