#!/usr/bin/env bash
# -------------------------------------
#  router-login.sh  |  Auto-open router page
# -------------------------------------

# إذا مرّر المستخدم IP يدويًا
if [ -n "$1" ]; then
  URL="http://$1"
else
  # جلب البوّابة الافتراضية
  GW=$(ip route 2>/dev/null | awk '/default/ {print $3; exit}')
  [ -z "$GW" ] && { echo "تعذّر العثور على البوّابة." >&2; exit 1; }
  URL="http://$GW"
fi

# فتح المتصفّح (xdg-open لمعظم لينكس، open للماك)
xdg-open "$URL" >/dev/null 2>&1 || open "$URL"
