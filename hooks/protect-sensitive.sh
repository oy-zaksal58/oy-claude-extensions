#!/bin/bash
# ============================================
# Hook: 민감한 파일 수정 차단
# Event: PreToolUse (Write, Edit)
# ============================================

set -e

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 파일 경로 추출
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# 차단할 파일 패턴
BLOCKED_PATTERNS=(
    ".env"
    ".env.local"
    ".env.development"
    ".env.production"
    "secrets"
    "credentials"
    "private_key"
    ".pem"
    ".key"
    "password"
    "application-prod.yml"
    "application-prd.yml"
)

# 패턴 매칭
for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == *"$pattern"* ]]; then
        echo "" >&2
        echo "🚫 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
        echo "   보안 정책: 민감한 파일 수정 차단" >&2
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
        echo "" >&2
        echo "   📁 파일: $FILE_PATH" >&2
        echo "   🔍 매칭: $pattern" >&2
        echo "" >&2
        echo "   💡 해결 방법:" >&2
        echo "      - 민감한 정보는 직접 편집하세요" >&2
        echo "      - 환경변수를 활용하세요" >&2
        echo "" >&2
        exit 2  # exit 2 = 차단
    fi
done

exit 0
