#!/bin/bash
# ============================================
# Hook: Bash 명령어 로깅
# Event: PreToolUse (Bash)
# ============================================

set -e

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 명령어와 설명 추출
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // "No description"')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 로그 파일 경로 (홈 디렉토리에 저장)
LOG_DIR="$HOME/.claude/logs"
LOG_FILE="$LOG_DIR/command-history.log"

# 로그 디렉토리 생성
mkdir -p "$LOG_DIR"

# 로그 기록
{
    echo "[$TIMESTAMP] $DESCRIPTION"
    echo "  > $COMMAND"
    echo ""
} >> "$LOG_FILE"

# 로그 파일 크기 관리 (1MB 초과 시 로테이션)
if [ -f "$LOG_FILE" ]; then
    FILE_SIZE=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -gt 1048576 ]; then
        mv "$LOG_FILE" "$LOG_FILE.$(date '+%Y%m%d%H%M%S').bak"
    fi
fi

exit 0
