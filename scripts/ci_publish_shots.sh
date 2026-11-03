#!/usr/bin/env bash
# Publishes screenshots + exception excerpt as a pre-release. Never fails the build.
# usage: ci_publish_shots.sh <run_number> <sha>
set +e
TAG="shots-$1"; SHA="$2"
{ grep -n 'ICONFONT\|EXCEPTION before' shots_log.txt | head -20
  awk '/EXCEPTION CAUGHT/{f=1} f' shots_log.txt | head -170; } > shots_log_tail.txt 2>/dev/null
{ echo "run=$1 sha=$SHA"; ls -la build/shots 2>&1; } > publish_diag.txt
gh release create "$TAG" --prerelease --target "$SHA" --title "Screenshots #$1" \
  --notes "Rendered by flutter test (real Tajawal font, 390x844). Layout evidence only - NOT a device." >> publish_diag.txt 2>&1 \
  || echo "release create failed" >> publish_diag.txt
for f in build/shots/*.png shots_log_tail.txt; do
  [ -f "$f" ] && { gh release upload "$TAG" "$f" --clobber >> publish_diag.txt 2>&1 || echo "upload failed: $f" >> publish_diag.txt; }
done
gh release upload "$TAG" publish_diag.txt --clobber >/dev/null 2>&1
exit 0
