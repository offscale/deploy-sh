#!/bin/sh

# shellcheck disable=SC2236
if [ ! -z "${SCRIPT_NAME+x}" ]; then
  this_file="${SCRIPT_NAME}"
elif [ ! -z "${BASH_VERSION+x}" ]; then
  # shellcheck disable=SC3028 disable=SC3054
  this_file="${BASH_SOURCE[0]}"
  # shellcheck disable=SC3040
  set -o pipefail
elif [ ! -z "${ZSH_VERSION+x}" ]; then
  # shellcheck disable=SC2296
  this_file="${(%):-%x}"
  # shellcheck disable=SC3040
  set -o pipefail
else
  this_file="${0}"
fi
set -feu

STACK="${STACK:-:}"
case "${STACK}" in
  *':'"${this_file}"':'*)
  printf '[STOP]   processing "%s"\n' "${this_file}"
  return ;;
  *)
  printf '[CONTINUE] processing "%s"\n' "${this_file}" ;;
esac
STACK="${STACK}${this_file}"':'
export STACK

DIR=$(CDPATH='' cd -- "$(dirname -- "${this_file}")" && pwd)

LIBSCRIPT_ROOT_DIR="${LIBSCRIPT_ROOT_DIR:-$(d="${DIR}"; while [ ! -f "${d}"'/ROOT' ]; do d="$(dirname -- "${d}")"; done; printf '%s' "${d}")}"

#DIR="$( dirname -- "$( readlink -nf -- "${0}" )")"

for lib in '_lib/_common/os_info.sh' '_lib/_common/priv.sh'; do
  SCRIPT_NAME="${LIBSCRIPT_ROOT_DIR}"'/'"${lib}"
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
done

cmd_avail() {
  command -v -- "${1}" >/dev/null 2>&1
}

detect_pkg_mgr() {
  if cmd_avail apt-get; then
    PKG_MGR='apt-get' # Debian, Ubuntu, and other derivatives
  elif cmd_avail apk; then
    PKG_MGR='apk' # Alpine Linux and derivatives
  elif cmd_avail dnf; then
    PKG_MGR='dnf'  # Red Hat and derivatives (preferred over `yum`)
  elif cmd_avail yum; then
    PKG_MGR='yum'  # Red Hat and derivatives
  elif cmd_avail pacman; then
    PKG_MGR='pacman'  # MSYS2
  elif cmd_avail zypper; then
    PKG_MGR='zypper' # OpenSUSE
  elif cmd_avail emerge; then
    PKG_MGR='emerge'  # Gentoo
  elif cmd_avail pkg; then
    PKG_MGR='pkg'  # FreeBSD
  elif cmd_avail port; then
    PKG_MGR='port'  # MacPorts
  elif cmd_avail brew; then
    PKG_MGR='brew'  # macOS and (rarely) Linux
  elif cmd_avail swupd; then
    PKG_MGR='swupd'  # Clear Linux
  elif cmd_avail xbps-install; then
    PKG_MGR='xbps'  # Void Linux
  elif cmd_avail eopkg; then
    PKG_MGR='eopkg'  # Solus
  else
    >&2 printf 'Error: No supported package manager found'
    exit 1
  fi
  export PKG_MGR
}

is_installed() {
  pkg="${1}"
  case "${PKG_MGR}" in
    'apk')                apk info -e "${pkg}" >/dev/null 2>&1 ;;
    'apt-get')            dpkg-query --show "${pkg}" >/dev/null 2>&1 ;;
    'brew')               brew list --formula "${pkg}" >/dev/null 2>&1 ;;
    'dnf'|'yum'|'zypper') rpm -q "${pkg}" >/dev/null 2>&1 ;;
    'emerge')             eix -I "${pkg}" >/dev/null 2>&1 ;;
    'eopkg')              eopkg list-installed | grep -q '^'"${pkg}"'[[:space:]]' ;;
    'pacman')             pacman -Q "${pkg}" >/dev/null 2>&1 ;;
    'pkg')                pkg info "${pkg}" >/dev/null 2>&1 ;;
    'port')               port installed "${pkg}" | grep -q 'active' ;;
    'swupd')              swupd bundle-list | grep -qx "${pkg}" ;;
    'xbps')               xbps-query -Rs '^'"${pkg}"'$' | grep -q '\[installed\]' ;;
    *)
      >&2 printf 'Error: is_installed function not implemented for %s\n' "${PKG_MGR}"
      exit 1 ;;
  esac
}

# shellcheck disable=SC2086
depends() {
  pkgs_to_install=''
  for pkg in "$@"; do
    # >&2 printf 'Checking if package is installed (%s): %s\n' "${PKG_MGR}" "${pkg}"
    if ! is_installed "${pkg}"; then
      pkgs_to_install="${pkgs_to_install:+"${pkgs_to_install}" }${pkg}"
    fi
  done
  if [ -n "${pkgs_to_install}" ]; then
    # >&2 printf 'Installing packages (%s): %s\n' "${PKG_MGR}" "${pkgs_to_install}"
    case "${PKG_MGR}" in
      'apt-get')
        export DEBIAN_FRONTEND='noninteractive'
                "${PRIV}" apt-get install -y    ${pkgs_to_install} ;;
      'apk')    "${PRIV}" apk add --no-cache    ${pkgs_to_install} ;;
      'brew')             brew install          ${pkgs_to_install} ;;
      'dnf')    "${PRIV}" dnf install -y        ${pkgs_to_install} ;;
      'emerge') "${PRIV}" emerge --quiet        ${pkgs_to_install} ;;
      'eopkg')  "${PRIV}" eopkg install -y      ${pkgs_to_install} ;;
      'pacman') "${PRIV}" pacman -S --noconfirm ${pkgs_to_install} ;;
      'pkg')    "${PRIV}" pkg install -y        ${pkgs_to_install} ;;
      'port')   "${PRIV}" port install          ${pkgs_to_install} ;;
      'swupd')  "${PRIV}" swupd bundle-add      ${pkgs_to_install} ;;
      'xbps')   "${PRIV}" xbps-install -Sy      ${pkgs_to_install} ;;
      'yum')    "${PRIV}" yum install -y        ${pkgs_to_install} ;;
      'zypper') "${PRIV}" zypper install -y     ${pkgs_to_install} ;;
      *)
        >&2 printf 'Error: depends function not implemented for %s\n' "${PKG_MGR}"
        exit 1
        ;;
    esac
  fi
}

if [ ! -z "${PKG_MGR+x}" ]; then
  detect_pkg_mgr
fi
