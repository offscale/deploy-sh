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

SCRIPT_ROOT_DIR="${SCRIPT_ROOT_DIR:-$( CDPATH='' cd -- "$( dirname -- "$( readlink -nf -- "${this_file}" )")" && pwd)}"
export SCRIPT_ROOT_DIR

STACK="${STACK:-:}${this_file}"':'
export STACK


#############################
#		Toolchain(s) [required]	#
#############################

if [ "${NODEJS_INSTALL_DIR:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/_lib/_toolchain/nodejs/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

if [ "${PYTHON_INSTALL_DIR:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/_lib/_toolchain/python/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

if [ "${RUST_INSTALL_DIR:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/_lib/_toolchain/rust/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

#############################
#		Database(s) [required]	#
#############################

if [ "${POSTGRES_URL:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/_lib/_storage/postgres/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

if [ "${REDIS_URL:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/_lib/_storage/valkey/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

#############################
#		Server(s) [required]	#
#############################

if [ "${SERVE_ACTIX_DIESEL_AUTH_SCAFFOLD:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/app/third_party/serve-actix-diesel-auth-scaffold/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

if [ "${JUPYTERHUB:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/app/third_party/jupyterhub/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

#############################
#		Database(s) [optional]	#
#############################

if [ "${AMQP_URL:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/_lib/_storage/rabbitmq/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

#############################
#		      WWWROOT(s)      	#
#############################

if [ "${WWWROOT_example_com_INSTALL:-0}" -eq 1 ]; then
  WWWROOT_NAME="${WWWROOT_NAME:-example.com}"
  WWWROOT_VENDOR="${WWWROOT_VENDOR:-nginx}"
  WWWROOT_PATH="${WWWROOT_PATH:-./my_symlinked_wwwroot}"
  WWWROOT_LISTEN="${WWWROOT_LISTEN:-80}"
  WWWROOT_HTTPS_PROVIDER="${WWWROOT_HTTPS_PROVIDER:-letsencrypt}"
  if [ "${WWWROOT_VENDOR:-nginx}" = 'nginx' ]; then
    SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/_server/nginx/setup.sh'
    export SCRIPT_NAME
    # shellcheck disable=SC1090
    . "${SCRIPT_NAME}"
  fi
fi
