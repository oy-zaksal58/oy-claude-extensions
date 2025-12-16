# OY Claude Extensions

> 올리브영 개발팀을 위한 Claude Code 확장 모음

팀 전체가 동일한 Claude Code 명령어와 자동화 규칙을 사용할 수 있습니다.

---

## 🚀 빠른 시작

```bash
# 1. 레포지토리 클론
git clone https://github.com/oliveyoung/oy-claude-extensions.git
cd oy-claude-extensions

# 2. 설치
./install.sh

# 3. Claude Code 재시작
# 끝! 이제 /review, /git-status 등 사용 가능
```

---

## 📦 포함된 기능

### Slash Commands

| 명령어          | 설명                            | 사용법                     |
| --------------- | ------------------------------- | -------------------------- |
| `/review`       | 코드 리뷰 수행                  | `/review`                  |
| `/git-status`   | Git 상태 확인 및 다음 작업 제안 | `/git-status`              |
| `/deploy-check` | 배포 전 검증 체크리스트         | `/deploy-check production` |
| `/pr-create`    | PR 생성 도우미                  | `/pr-create`               |

### Skills (자동 호출)

| 스킬          | 트리거 키워드                                    |
| ------------- | ------------------------------------------------ |
| code-reviewer | "코드 리뷰", "PR 검사", "품질 분석", "버그 탐지" |

### Hooks (자동 실행)

| Hook              | 이벤트       | 동작                                 |
| ----------------- | ------------ | ------------------------------------ |
| protect-sensitive | 파일 수정 전 | .env, secrets 등 민감 파일 수정 차단 |
| auto-format       | 파일 수정 후 | Prettier, Black 등 자동 포맷팅       |
| log-commands      | Bash 실행 전 | 실행된 명령어 로깅                   |

---

## 📁 디렉토리 구조

```
oy-claude-extensions/
├── commands/                # Slash Commands
│   ├── review.md           # /review
│   ├── git-status.md       # /git-status
│   ├── deploy-check.md     # /deploy-check
│   └── pr-create.md        # /pr-create
├── skills/                  # Skills
│   └── code-reviewer/
│       └── SKILL.md
├── hooks/                   # Hook 스크립트
│   ├── protect-sensitive.sh
│   ├── auto-format.sh
│   └── log-commands.sh
├── settings.json            # Hook 설정
├── install.sh               # 설치 스크립트
├── uninstall.sh             # 제거 스크립트
└── README.md
```

---

## ⚙️ 설치 상세

### 자동 설치 (권장)

```bash
./install.sh
```

설치 스크립트가 하는 일:

1. 기존 `~/.claude/` 설정 백업
2. commands, skills, hooks 복사
3. settings.json 설정
4. 실행 권한 부여

### 수동 설치

```bash
# 디렉토리 생성
mkdir -p ~/.claude/{commands,skills,hooks}

# 파일 복사
cp -r commands/* ~/.claude/commands/
cp -r skills/* ~/.claude/skills/
cp -r hooks/* ~/.claude/hooks/
cp settings.json ~/.claude/

# 실행 권한 부여
chmod +x ~/.claude/hooks/*.sh
```

### 제거

```bash
./uninstall.sh
```

---

## 🔧 사전 요구사항

### 필수

- Claude Code 설치 및 로그인

### 권장

- **jq**: Hook에서 JSON 파싱에 사용

  ```bash
  # macOS
  brew install jq

  # Ubuntu
  sudo apt install jq
  ```

- **Prettier**: JavaScript/TypeScript 자동 포맷팅
  ```bash
  npm install -g prettier
  ```

---

## 📝 사용 예시

### 코드 리뷰

```
> /review
```

현재 열린 파일 또는 최근 변경사항을 보안, 성능, 품질 관점에서 리뷰합니다.

### Git 상태 확인

```
> /git-status
```

현재 브랜치, 변경사항, 최근 커밋을 분석하고 다음 작업을 제안합니다.

### 배포 전 검증

```
> /deploy-check production
```

배포 환경(dev/stg/prd)에 맞는 체크리스트를 실행합니다.

### 민감 파일 보호 (자동)

```
> ".env 파일에 API_KEY 추가해줘"

🚫 보안 정책: 민감한 파일 수정 차단
   파일: .env
   💡 민감한 정보는 직접 편집하세요
```

---

## 🔄 업데이트

```bash
cd oy-claude-extensions
git pull origin main
./install.sh
```

---

## 🤝 기여하기

새로운 Command, Skill, Hook을 추가하고 싶으신가요?

👉 **[CONTRIBUTING.md](./CONTRIBUTING.md)** 를 참고해주세요!

- Slash Command 추가 방법
- Skill 추가 방법
- Hook 추가 방법
- PR 규칙 및 코드 리뷰 기준

---

## 🐛 트러블슈팅

### Hook이 동작하지 않음

```bash
# 1. 실행 권한 확인
ls -la ~/.claude/hooks/

# 2. 권한 부여
chmod +x ~/.claude/hooks/*.sh

# 3. jq 설치 확인
which jq
```

### 명령어가 안 보임

1. `~/.claude/commands/` 폴더 확인
2. 파일 확장자가 `.md`인지 확인
3. Claude Code 재시작

### Skill이 자동 호출되지 않음

1. SKILL.md의 `description`에 트리거 키워드 확인
2. `allowed-tools` 설정 확인

---

## 📞 지원

- **Slack**: #claude-code-help
- **담당팀**: 회원서비스개발팀

---

## 📜 라이선스

내부 사용 전용
