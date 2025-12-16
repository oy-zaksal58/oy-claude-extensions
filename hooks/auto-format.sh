#!/bin/bash
# ============================================
# Hook: 파일 저장 후 자동 포맷팅
# Event: PostToolUse (Write, Edit)
# ============================================

set -e

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 파일 경로 추출
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# 파일이 존재하는지 확인
if [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

# 확장자별 포맷터 실행
case "$FILE_PATH" in
    *.ts|*.tsx|*.js|*.jsx|*.json|*.md|*.css|*.scss)
        if command -v npx &> /dev/null; then
            if npx prettier --write "$FILE_PATH" 2>/dev/null; then
                echo "✨ Prettier 포맷팅 완료: $(basename "$FILE_PATH")"
            fi
        fi
        ;;
    *.py)
        if command -v black &> /dev/null; then
            if black --quiet "$FILE_PATH" 2>/dev/null; then
                echo "✨ Black 포맷팅 완료: $(basename "$FILE_PATH")"
            fi
        elif command -v autopep8 &> /dev/null; then
            if autopep8 --in-place "$FILE_PATH" 2>/dev/null; then
                echo "✨ autopep8 포맷팅 완료: $(basename "$FILE_PATH")"
            fi
        fi
        ;;
    *.java|*.kt)
        # Java/Kotlin은 IDE나 Gradle에서 포맷팅하는 것을 권장
        # 필요시 google-java-format 또는 ktlint 사용
        ;;
    *.go)
        if command -v gofmt &> /dev/null; then
            if gofmt -w "$FILE_PATH" 2>/dev/null; then
                echo "✨ gofmt 포맷팅 완료: $(basename "$FILE_PATH")"
            fi
        fi
        ;;
esac

exit 0
