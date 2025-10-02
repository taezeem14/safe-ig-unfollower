#!/usr/bin/env bash
# safe-ig-unfollower-dryrun.sh
# ------------------------------------------------------------------
# Safe IG Unfollower (DRY-RUN by default)
# - Dry-run prints what it WOULD do instead of actually unfollowing.
# - To run real requests, set EXECUTE=1 (NOT recommended).
# - Designed for learning / demo / remixing purposes.
#
# USAGE:
# 1) Place a cookie file named .cookie.<your_username> if you want actual fetches.
# 2) Put a following list at core/<account>.following_list.txt to run unfollow loop in dry-run.
# 3) Run: bash safe-ig-unfollower-dryrun.sh
#
# TO PUBLISH ON GITHUB (recommended):
# - Fork existing upstream if available OR create a new repo and upload this file.
# - Add a README.md explaining "educational/demo" and crediting original inspiration.
# - Include an explicit LICENSE (MIT recommended) and a clear "DO NOT USE AGAINST REAL ACCOUNTS"
#
# DISCLAIMER: This script is for educational/demo purposes only. Automating interactions against
# third-party services can violate Terms of Service and lead to account suspension. Use at your own risk.
# ------------------------------------------------------------------

set -euo pipefail
IFS=$'\n\t'

# -------- CONFIG --------
EXECUTE=${EXECUTE:-0}          # 0 = dry-run (default), 1 = actually send unfollow requests
SLEEP_BETWEEN=${SLEEP_BETWEEN:-3}   # seconds between unfollows
LOGFILE="${LOGFILE:-unfollower.log}"
# ------------------------

# --- helpers ---
log() { printf '%s\n' "$*" | tee -a "$LOGFILE"; }
err() { printf 'ERROR: %s\n' "$*" >&2; }

# generate device IDs
rand_hex() { openssl rand -hex 32 | cut -c "$1"-"$2"; }
string4=$(rand_hex 1 4)
string8=$(rand_hex 1 8)
string12=$(rand_hex 1 12)
string16=$(rand_hex 1 16)
device="android-$string16"
uuid=$(rand_hex 1 32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"

USER_AGENT='Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)'
headers=(
  "Connection: close"
  "Accept: */*"
  "Content-Type: application/x-www-form-urlencoded; charset=UTF-8"
  "Cookie2: $Version=1"
  "Accept-Language: en-US"
  "User-Agent: $USER_AGENT"
)

# fetch csrf token
fetch_csrf_token() {
  local uuid_local=$uuid
  local resp
  resp=$(curl -s -D - "https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid_local" -A "$USER_AGENT" -o /dev/null || true)
  local token
  token=$(printf '%s\n' "$resp" | grep -o 'csrftoken=[^;]*' | head -n1 | cut -d'=' -f2 || true)
  echo "${token:-}"
}

# fetch following list (requires cookie)
fetch_following_list() {
  local target_account=$1
  if [[ -z "$target_account" ]]; then
    err "fetch_following_list requires account name"
    return 1
  fi

  local cookie_file=".cookie.${user:-}"
  if [[ ! -f "$cookie_file" ]]; then
    err "cookie file not found ($cookie_file). For dry-run, supply core/${target_account}.following_list.txt"
    return 2
  fi

  local html
  html=$(curl -s -L -b "$cookie_file" "https://www.instagram.com/$target_account/" -A "$USER_AGENT")
  local numeric_id
  numeric_id=$(printf '%s\n' "$html" | grep -o 'profilePage_[0-9]*' | head -n1 | cut -d'_' -f2 || true)

  if [[ -z "$numeric_id" ]]; then
    err "Could not extract profile id for $target_account. Are cookies valid?"
    return 3
  fi

  local initial_url="https://i.instagram.com/api/v1/friendships/$numeric_id/following"
  local outtmp="${target_account}.following.temp"
  curl -s -L -b "$cookie_file" -A "$USER_AGENT" "${initial_url}" -H "Accept: application/json" -o "$outtmp"
  cp "$outtmp" "${target_account}.following.00"
  local count=0
  while :; do
    local big_list next_max_id
    big_list=$(grep -o '"big_list": true' "${target_account}.following.temp" || true)
    next_max_id=$(grep -o '"next_max_id": "[^"]*' "${target_account}.following.temp" | head -n1 | cut -d '"' -f4 || true)
    if [[ -n "$big_list" ]] && [[ -n "$next_max_id" ]]; then
      count=$((count+1))
      local next_url="https://i.instagram.com/api/v1/friendships/$numeric_id/following/?rank_token=${numeric_id}_${guid}&max_id=${next_max_id}"
      curl -s -L -b "$cookie_file" -A "$USER_AGENT" "$next_url" -o "${target_account}.following.temp"
      cp "${target_account}.following.temp" "${target_account}.following.${count}"
      sleep 1
    else
      grep -o '"username": "[^"]*' ${target_account}.following.* 2>/dev/null | cut -d '"' -f4 | sort -u > "core/${target_account}.following_list.txt"
      rm -f ${target_account}.following.*
      break
    fi
  done

  log "Saved following list to core/${target_account}.following_list.txt"
  return 0
}

unfollow_user() {
  local cookie_file=".cookie.${user:-}"
  local target="$1"
  local profile_html
  profile_html=$(curl -s -L "https://www.instagram.com/$target/" -A "$USER_AGENT" || true)
  local target_id
  target_id=$(printf '%s\n' "$profile_html" | grep -o 'profilePage_[0-9]*' | head -n1 | cut -d'_' -f2 || true)

  if [[ -z "$target_id" ]]; then
    log "Could not resolve numeric id for $target — skipping."
    return 0
  fi

  local payload='{"_uuid":"'"$guid"'","_uid":"'"${username_id:-unknown}"'","user_id":"'"$target_id"'","_csrftoken":"'"$csrftoken"'" }'

  if [[ "$EXECUTE" -eq 1 ]]; then
    log "Sending unfollow request for $target (id: $target_id)"
    local resp
    resp=$(curl -s -b "$cookie_file" -d "ig_sig_key_version=4&signed_body=placeholder.$payload" -A "$USER_AGENT" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" "https://i.instagram.com/api/v1/friendships/destroy/$target_id/" -w "%{http_code}" -o /dev/stderr || true)
    log "HTTP: $resp"
  else
    printf "\n[DRY-RUN] Would unfollow: %s (id: %s)\n" "$target" "$target_id"
    printf "[DRY-RUN] curl -b %s -d '%s' -A '%s' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' 'https://i.instagram.com/api/v1/friendships/destroy/%s/'\n\n" ".cookie.$user" "$(printf '%s' "$payload")" "$USER_AGENT" "$target_id"
  fi

  return 0
}

confirm_proceed() {
  printf "\n"
  read -rp "This is a potentially account-impacting operation. Type YES to proceed: " yn
  if [[ "$yn" != "YES" ]]; then
    log "Aborted by user."
    exit 0
  fi
}

main_menu() {
  printf "\n1) Get Following List (requires cookie)\n2) Run Unfollower (dry-run default)\n3) Exit\n\n"
  read -rp "Choose: " opt
  case "$opt" in
    1)
      read -rp "Account to fetch (username): " user_account
      mkdir -p core
      fetch_following_list "$user_account" || { err "fetch_following_list failed"; exit 1; }
      ;;
    2)
      read -rp "Account to operate on (username): " user_account
      if [[ ! -f "core/${user_account}.following_list.txt" ]]; then
        err "Following list not found. Run option 1 first or place a file at core/${user_account}.following_list.txt"
        exit 1
      fi
      csrftoken=$(fetch_csrf_token)
      if [[ -z "$csrftoken" ]]; then
        err "Could not fetch csrftoken (network or header change). You may still proceed in dry-run but real execution may fail."
      fi
      if [[ -f ".cookie.${user:-}" ]]; then
        username_html=$(curl -s -L -b ".cookie.${user:-}" "https://www.instagram.com/$user/" -A "$USER_AGENT" || true)
        username_id=$(printf '%s\n' "$username_html" | grep -o 'profilePage_[0-9]*' | head -n1 | cut -d'_' -f2 || true)
      fi

      log "Loaded $(wc -l < "core/${user_account}.following_list.txt") users to unfollow (dry-run=${EXECUTE:-0})"
      if [[ "$EXECUTE" -ne 1 ]]; then
        log "DRY-RUN mode: no destructive requests will be sent. To enable real mode, set EXECUTE=1 in environment."
      else
        confirm_proceed
      fi

      while read -r target_user; do
        [[ -z "$target_user" || "${target_user:0:1}" == "#" ]] && continue
        unfollow_user "$target_user"
        sleep "$SLEEP_BETWEEN"
      done < "core/${user_account}.following_list.txt"
      ;;
    3) exit 0 ;;
    *) err "Invalid option"; main_menu ;;
  esac
}

banner() {
  cat <<'EOF'
  ____  _   _ _   _ _   _ _   _
 |  _ \| | | | \ | | | | | \ | |
 | |_) | | | |  \| | | | |  \| |
 |  __/| |_| | . ` | | | | . ` |
 |_|    \___/|_|\__|____/|_|\__|
 Safe IG Unfollower (dry-run)
 EOF
}

banner
mkdir -p core
main_menu
