#!/bin/sh

# shellcheck disable=SC2236
if [ ! -z "${BASH_VERSION+x}" ]; then
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

DIR="$( CDPATH='' cd -- "$( dirname -- "$( readlink -nf -- "${this_file}" )")" && pwd)"
SCRIPT_ROOT_DIR="${SCRIPT_ROOT_DIR:-$DIR}"
export DIR
export SCRIPT_ROOT_DIR

# shellcheck disable=SC1091
. "${DIR}"'/_lib/_common/os_info.sh'
# shellcheck disable=SC1091
. "${DIR}"'/conf.env.sh'

if [ "${POSTGRESQL_INSTALL:-0}" -eq 1 ]; then
  "${DIR}"'/_lib/_storage/postgres/setup.sh'
fi
if [ -n "${DATABASE_URL+s}" ]; then 
  >&2 printf 'DATABASE_URL must be set\n';
  exit 3
fi

if [ "${VALKEY_INSTALL:-0}" -eq 1 ]; then
  "${DIR}"'/_lib/_storage/valkey/setup.sh'
fi
if [ -n "${REDIS_URL+s}" ]; then 
  >&2 printf 'REDIS_URL must be set\n';
  exit 3
fi

if [ "${RUST_INSTALL:-0}" -eq 1 ]; then
  "${DIR}"'/_lib/_toolchain/rust/setup.sh'
fi
if [ "${NODEJS_INSTALL:-0}" -eq 1 ]; then
  "${DIR}"'/_lib/_toolchain/nodejs/setup.sh'
fi
if [ "${PYTHON_INSTALL:-0}" -eq 1 ]; then
  "${DIR}"'/_lib/_toolchain/python/setup.sh'
fi

if [ "${NGINX_INSTALL:-0}" -eq 1 ]; then
  "${DIR}"'/_lib/_server/nginx/setup.sh'
fi

# # uses `WWWROOT`
# if [ "${WWWROOT_INSTALL:-0}" -eq 1 ]; then
# 
# fi

if [ "${JUPYTER_NOTEBOOK_INSTALL:-0}" -eq 1 ]; then
  "${DIR}"'/app/third_party/jupyter/setup.sh'
fi

# uses `PYTHON_VENV` and `REDIS_URL`
if [ "${CELERY_INSTALL:-0}" -eq 1 ]; then
  "${DIR}"'/app/_storage/celery/setup.sh'
fi
