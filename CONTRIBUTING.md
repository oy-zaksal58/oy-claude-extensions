# 기여 가이드 (Contributing Guide)

> OY Claude Extensions에 기여해주셔서 감사합니다!

이 문서는 새로운 Command, Skill, Hook을 추가하는 방법을 안내합니다.

---

## 목차

- [시작하기 전에](#시작하기-전에)
- [Slash Command 추가하기](#slash-command-추가하기)
- [Skill 추가하기](#skill-추가하기)
- [Hook 추가하기](#hook-추가하기)
- [PR 규칙](#pr-규칙)
- [코드 리뷰 기준](#코드-리뷰-기준)

---

## 시작하기 전에

### 개발 환경 설정

```bash
# 1. 레포지토리 포크 후 클론
git clone https://github.com/YOUR_USERNAME/oy-claude-extensions.git
cd oy-claude-extensions

# 2. 개발용 설치 (기존 설정 백업됨)
./install.sh

# 3. 변경사항 테스트 후 PR 생성
```

### 디렉토리 구조 이해하기

```
oy-claude-extensions/
├── commands/           # 사용자가 /명령어로 호출
├── skills/             # Claude가 자동으로 호출
├── hooks/              # 특정 이벤트에 자동 실행
└── settings.json       # Hook 설정
```

---

## Slash Command 추가하기

### 1. 파일 생성

`commands/` 폴더에 `.md` 파일을 생성합니다.

```bash
touch commands/my-command.md
```

### 2. 기본 구조

```markdown
---
description: 명령어에 대한 간단한 설명 (필수)
allowed-tools: 사용할 도구들 (선택)
---

# 명령어 제목

Claude에게 전달할 프롬프트 내용을 작성합니다.
```

### 3. Frontmatter 옵션

| 옵션            | 필수 | 설명                          | 예시                      |
| --------------- | ---- | ----------------------------- | ------------------------- |
| `description`   | ✅   | 명령어 설명 (탭 완성 시 표시) | `코드 리뷰 수행`          |
| `allowed-tools` | ❌   | 허용할 도구 목록              | `Read, Grep, Bash(git *)` |
| `argument-hint` | ❌   | 인자 힌트                     | `[파일경로]`              |

### 4. 동적 콘텐츠 사용

```markdown
# 인자 사용

$ARGUMENTS 환경에 대한 검증을 수행합니다.

# Bash 명령 결과 삽입

현재 브랜치: !`git branch --show-current`

# 파일 내용 삽입

@path/to/file.txt
```

### 5. 예시: 테스트 실행 명령어

```markdown
---
description: 테스트 실행 및 결과 분석
allowed-tools: Bash(npm test), Bash(yarn test), Read
argument-hint: [test-pattern]
---

# 테스트 실행

## 대상

$ARGUMENTS

## 요청사항

1. 관련 테스트를 실행해주세요
2. 실패한 테스트가 있다면 원인을 분석해주세요
3. 수정 방안을 제안해주세요
```

---

## Skill 추가하기

### 1. 폴더 구조 생성

```bash
mkdir -p skills/my-skill
touch skills/my-skill/SKILL.md
```

### 2. SKILL.md 작성

```markdown
---
name: my-skill
description: 스킬 설명과 트리거 키워드를 포함 (중요!)
allowed-tools: Read, Grep, Glob
---

# 스킬 이름

Claude가 자동으로 수행할 작업을 정의합니다.

## 수행 내용

- 작업 1
- 작업 2

## 출력 형식

...
```

### 3. 트리거 키워드 설정

`description`에 트리거 키워드를 포함해야 Claude가 자동으로 호출합니다:

```markdown
description: API 문서 생성. API 문서, Swagger, OpenAPI, 엔드포인트 문서화 요청 시 자동 사용.
```

**좋은 예시:**

- `코드 리뷰, PR 검사, 품질 분석 요청 시 자동 사용`
- `테스트 작성, 단위 테스트, TDD 요청 시 자동 사용`

### 4. 예시: API 문서 생성 스킬

```markdown
---
name: api-documenter
description: API 문서 자동 생성. API 문서, Swagger, OpenAPI, REST API 문서화 요청 시 자동 사용.
allowed-tools: Read, Grep, Glob, Write
---

# API 문서 생성기

## 분석 대상

- Controller/Router 파일
- DTO/Request/Response 클래스
- 기존 API 문서

## 출력 형식

### [HTTP Method] /endpoint

- **설명**:
- **요청 파라미터**:
- **응답 형식**:
- **예시**:
```

---

## Hook 추가하기

### 1. 스크립트 생성

```bash
touch hooks/my-hook.sh
chmod +x hooks/my-hook.sh
```

### 2. 기본 구조

```bash
#!/bin/bash
# ============================================
# Hook: 훅 이름
# Event: PreToolUse | PostToolUse
# ============================================

set -e

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 필요한 값 추출 (jq 사용)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# 로직 구현
# ...

# 종료 코드
# 0: 성공 (계속 진행)
# 2: 차단 (도구 실행 중단)
# 그 외: 경고 (계속 진행)
exit 0
```

### 3. settings.json에 등록

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/my-hook.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### 4. Hook 이벤트 종류

| 이벤트         | 발생 시점    | 주요 용도            |
| -------------- | ------------ | -------------------- |
| `PreToolUse`   | 도구 실행 전 | 검증, 차단, 로깅     |
| `PostToolUse`  | 도구 실행 후 | 포맷팅, 알림, 후처리 |
| `Notification` | 알림 발생 시 | 외부 알림 연동       |
| `Stop`         | 작업 중단 시 | 정리 작업            |

### 5. Matcher 패턴

```json
// 특정 도구만
"matcher": "Write"

// 여러 도구 (OR)
"matcher": "Write|Edit"

// 모든 도구
"matcher": ".*"

// Bash의 특정 명령만
"matcher": "Bash"
// 그 후 스크립트에서 command 내용 검사
```

### 6. 입력 JSON 구조

```json
{
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.js",
    "content": "file content..."
  }
}
```

### 7. 예시: 파일 크기 제한 Hook

```bash
#!/bin/bash
# Hook: 대용량 파일 생성 방지
# Event: PreToolUse (Write)

set -e
INPUT=$(cat)

CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty')
CONTENT_LENGTH=${#CONTENT}
MAX_LENGTH=100000  # 약 100KB

if [ "$CONTENT_LENGTH" -gt "$MAX_LENGTH" ]; then
    echo "🚫 파일 크기 제한: ${CONTENT_LENGTH}자 > ${MAX_LENGTH}자" >&2
    echo "   💡 파일을 분할하거나 압축을 고려하세요" >&2
    exit 2
fi

exit 0
```

---

## PR 규칙

### 브랜치 네이밍

```
feature/add-command-테스트실행
feature/add-skill-api문서생성
feature/add-hook-파일크기제한
fix/hook-포맷팅-오류수정
docs/readme-업데이트
```

### 커밋 메시지

```
feat: /test-run 명령어 추가
feat: api-documenter 스킬 추가
feat: 파일 크기 제한 hook 추가
fix: auto-format hook 경로 오류 수정
docs: CONTRIBUTING.md 작성
```

### PR 체크리스트

- [ ] 로컬에서 `./install.sh`로 테스트 완료
- [ ] 새 Command/Skill/Hook이 정상 동작 확인
- [ ] README.md 테이블에 추가 (해당 시)
- [ ] 기존 기능에 영향 없음 확인

### PR 템플릿

```markdown
## 변경 사항

- 추가/수정/삭제된 내용

## 테스트 결과

- 테스트 방법 및 결과 스크린샷

## 체크리스트

- [ ] install.sh 테스트 완료
- [ ] 기능 동작 확인
- [ ] README 업데이트 (필요 시)
```

---

## 코드 리뷰 기준

### Command/Skill

- [ ] `description`이 명확하고 간결한가?
- [ ] `allowed-tools`가 최소 권한 원칙을 따르는가?
- [ ] 프롬프트가 명확한 지시를 포함하는가?
- [ ] 출력 형식이 정의되어 있는가?

### Hook

- [ ] `set -e`로 에러 처리가 되어 있는가?
- [ ] `jq` 의존성을 올바르게 사용하는가?
- [ ] 적절한 exit code를 반환하는가?
- [ ] stderr로 사용자 메시지를 출력하는가?
- [ ] timeout 내에 실행이 완료되는가?

### 공통

- [ ] 기존 코드 스타일과 일관성이 있는가?
- [ ] 불필요한 권한 요청이 없는가?
- [ ] 보안 취약점이 없는가?

---

## 질문 및 지원

- **Slack**: #claude-code-help
- **담당팀**: 회원서비스개발팀

---

감사합니다! 🎉
