#!/usr/bin/env bash

set -u

detect_gateway() {
  local system gateway
  system="$(uname -s 2>/dev/null || printf 'unknown')"
  gateway=""

  case "$system" in
    Darwin)
      gateway="$(route -n get default 2>/dev/null | awk '/gateway:/{print $2; exit}')"
      ;;
    Linux)
      if command -v ip >/dev/null 2>&1; then
        gateway="$(ip -4 route show default 2>/dev/null | awk '/default/ {print $3; exit}')"
      fi
      if [[ -z "$gateway" ]] && command -v route >/dev/null 2>&1; then
        gateway="$(route -n 2>/dev/null | awk '$1 == "0.0.0.0" {print $2; exit}')"
      fi
      if [[ -z "$gateway" ]] && command -v netstat >/dev/null 2>&1; then
        gateway="$(netstat -rn -f inet 2>/dev/null | awk '$1 == "0.0.0.0" || $1 == "default" {print $2; exit}')"
      fi
      ;;
    FreeBSD|OpenBSD|NetBSD)
      gateway="$(route -n get default 2>/dev/null | awk '/gateway:/{print $2; exit}')"
      ;;
  esac

  printf '%s' "$gateway"
}

open_url() {
  local url system
  url="$1"
  system="$(uname -s 2>/dev/null || printf 'unknown')"

  if [[ "$system" == "Darwin" ]] && command -v open >/dev/null 2>&1; then
    open "$url"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url" >/dev/null 2>&1
  elif command -v gio >/dev/null 2>&1; then
    gio open "$url" >/dev/null 2>&1
  elif command -v wslview >/dev/null 2>&1; then
    wslview "$url" >/dev/null 2>&1
  elif command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -NoProfile -Command "Start-Process '$url'" >/dev/null 2>&1
  else
    return 1
  fi
}

target="${1:-}"
if [[ -z "$target" ]]; then
  target="$(detect_gateway)"
fi

if [[ -z "$target" ]]; then
  printf '%s\n' '[تعذر العثور على عنوان الراوتر تلقائيًا]' >&2
  printf '%s\n' 'تأكد من اتصال الجهاز بشبكة الراوتر، ثم جرّب عنوانًا يدويًا:' >&2
  printf '%s\n' '  ./router-login.sh 192.168.1.1' >&2
  printf '%s\n' '  ./router-login.sh https://192.168.1.1' >&2
  exit 1
fi

case "$target" in
  http://*|https://*) url="$target" ;;
  *) url="http://$target" ;;
esac

printf 'تم العثور على صفحة الراوتر: %s\n' "$url"
if ! open_url "$url"; then
  printf '%s\n' '[تم اكتشاف العنوان لكن تعذر فتح المتصفح]' >&2
  printf 'افتح هذا العنوان يدويًا: %s\n' "$url" >&2
  exit 1
fi
