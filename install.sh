#!/bin/bash
# ============================================
# OY Claude Extensions 설치 스크립트
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backup_$(date +%Y%m%d_%H%M%S)"

echo ""
echo "🚀 OY Claude Extensions 설치를 시작합니다..."
echo ""

# ----------------------------------------
# 1. 기존 설정 백업
# ----------------------------------------
if [ -d "$CLAUDE_DIR" ]; then
    echo "📦 기존 설정을 백업합니다..."
    mkdir -p "$BACKUP_DIR"

    # 기존 파일들 백업
    [ -d "$CLAUDE_DIR/commands" ] && cp -r "$CLAUDE_DIR/commands" "$BACKUP_DIR/"
    [ -d "$CLAUDE_DIR/skills" ] && cp -r "$CLAUDE_DIR/skills" "$BACKUP_DIR/"
    [ -d "$CLAUDE_DIR/hooks" ] && cp -r "$CLAUDE_DIR/hooks" "$BACKUP_DIR/"
    [ -f "$CLAUDE_DIR/settings.json" ] && cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/"

    echo "   ✅ 백업 완료: $BACKUP_DIR"
fi

# ----------------------------------------
# 2. 디렉토리 생성
# ----------------------------------------
echo ""
echo "📁 디렉토리 구조를 생성합니다..."
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/logs"

# ----------------------------------------
# 3. 파일 복사
# ----------------------------------------
echo ""
echo "📋 파일을 복사합니다..."

# Commands
echo "   → commands/"
cp -r "$SCRIPT_DIR/commands/"* "$CLAUDE_DIR/commands/"

# Skills
echo "   → skills/"
cp -r "$SCRIPT_DIR/skills/"* "$CLAUDE_DIR/skills/"

# Hooks
echo "   → hooks/"
cp -r "$SCRIPT_DIR/hooks/"* "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/"*.sh

# Settings (병합 또는 덮어쓰기)
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo ""
    echo "⚠️  기존 settings.json이 있습니다."
    echo "   기존 파일은 백업되었습니다: $BACKUP_DIR/settings.json"
fi
cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
echo "   → settings.json"

# ----------------------------------------
# 4. jq 설치 확인
# ----------------------------------------
echo ""
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq가 설치되어 있지 않습니다. Hook이 동작하려면 jq가 필요합니다."
    echo "   설치 방법:"
    echo "   - macOS: brew install jq"
    echo "   - Ubuntu: sudo apt install jq"
else
    echo "✅ jq 확인됨: $(which jq)"
fi

# ----------------------------------------
# 5. 설치 완료
# ----------------------------------------
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 설치가 완료되었습니다!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📌 사용 가능한 명령어:"
echo "   /review        - 코드 리뷰"
echo "   /git-status    - Git 상태 확인"
echo "   /deploy-check  - 배포 전 검증"
echo "   /pr-create     - PR 생성 도우미"
echo ""
echo "🔧 활성화된 Hook:"
echo "   - 민감 파일 보호 (PreToolUse)"
echo "   - 자동 포맷팅 (PostToolUse)"
echo "   - 명령어 로깅 (PreToolUse)"
echo ""
echo "💡 Claude Code를 재시작하면 적용됩니다."
echo ""
