#!/bin/bash
# ============================================
# OY Claude Extensions 제거 스크립트
# ============================================

set -e

CLAUDE_DIR="$HOME/.claude"

echo ""
echo "🗑️  OY Claude Extensions 제거를 시작합니다..."
echo ""

# ----------------------------------------
# 1. 확인
# ----------------------------------------
read -p "정말 제거하시겠습니까? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "취소되었습니다."
    exit 0
fi

# ----------------------------------------
# 2. 파일 제거
# ----------------------------------------
echo ""
echo "📁 파일을 제거합니다..."

# Commands 제거
if [ -d "$CLAUDE_DIR/commands" ]; then
    rm -rf "$CLAUDE_DIR/commands"
    echo "   ✅ commands/ 제거됨"
fi

# Skills 제거
if [ -d "$CLAUDE_DIR/skills" ]; then
    rm -rf "$CLAUDE_DIR/skills"
    echo "   ✅ skills/ 제거됨"
fi

# Hooks 제거
if [ -d "$CLAUDE_DIR/hooks" ]; then
    rm -rf "$CLAUDE_DIR/hooks"
    echo "   ✅ hooks/ 제거됨"
fi

# Settings 제거
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    rm "$CLAUDE_DIR/settings.json"
    echo "   ✅ settings.json 제거됨"
fi

# ----------------------------------------
# 3. 백업 복원 안내
# ----------------------------------------
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 제거가 완료되었습니다!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 백업 폴더 확인
BACKUP_DIRS=$(ls -d "$CLAUDE_DIR/backup_"* 2>/dev/null || true)
if [ -n "$BACKUP_DIRS" ]; then
    echo "📦 백업된 설정이 있습니다:"
    echo "$BACKUP_DIRS"
    echo ""
    echo "복원하려면 해당 폴더의 내용을 ~/.claude/로 복사하세요."
fi

echo ""
echo "💡 Claude Code를 재시작하면 적용됩니다."
echo ""
