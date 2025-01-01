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
    printf '[STOP]     processing "%s"\n' "${this_file}"
    return ;;
  *)
    printf '[CONTINUE] processing "%s"\n' "${this_file}" ;;
esac
STACK="${STACK}${this_file}"':'
export STACK

export BUILD_DIR="${BUILD_DIR:-./build}"

export RUST_INSTALL="${RUST_INSTALL:-1}"
export RUST_VERSION="${RUST_VERSION:-nightly}"

export NODEJS_INSTALL="${NODEJS_INSTALL:-1}"
export NODEJS_VERSION="${NODEJS_VERSION:-lts}"

export PYTHON_INSTALL="${PYTHON_INSTALL:-1}"
export PYTHON_VERSION="${PYTHON_VERSION:-3.10}"

export PYTHON_VENV="${PYTHON_VENV:-/opt/venvs/venv-${PYTHON_VERSION}}"

export POSTGRESQL_INSTALL="${POSTGRESQL_INSTALL:-1}"
export POSTGRESQL_VERSION="${POSTGRESQL_VERSION:-17}"
export POSTGRESQL_DAEMON="${POSTGRESQL_DAEMON:-1}"

export VALKEY_INSTALL="${VALKEY_INSTALL:-1}"
export VALKEY_VERSION="${VALKEY_VERSION:-unstable}"
export VALKEY_DAEMON="${VALKEY_DAEMON:-1}"

export NGINX_INSTALL="${NGINX_INSTALL:-1}"
export NGINX_VERSION="${NGINX_VERSION:-mainline}"
export NGINX_DAEMOM="${NGINX_DAEMOM:-1}"

export CELERY_INSTALL="${CELERY_INSTALL:-1}"
export CELERY_DAEMOM="${CELERY_DAEMOM:-1}"
export CELERY_VENV="${CELERY_VENV:-${PYTHON_VENV}}"

export WWWROOT_INSTALL="${WWWROOT_INSTALL:-1}"

export JUPYTER_NOTEBOOK_INSTALL="${JUPYTER_NOTEBOOK_INSTALL:-1}"
export JUPYTER_NOTEBOOK_DIR="${JUPYTER_NOTEBOOK_DIR:-/opt/notebooks}"
export JUPYTER_NOTEBOOK_IP="${JUPYTER_NOTEBOOK_IP:-127.0.0.1}"
# Don't actually use the plaintext password this represents in production!
default_password='-argon2:$argon2id$v=19$m=10240,t=10,p=8$HeC4C022haY1PxTUcAPk+A$ULz24zkP3jNHvScVul9t/OAOjhdgTNJYfPUvMWSOGcg'
export JUPYTER_NOTEBOOK_PASSWORD="${JUPYTER_NOTEBOOK_PASSWORD:-$default_password}"
export JUPYTER_NOTEBOOK_PORT="${JUPYTER_NOTEBOOK_PORT:-8888}"
export JUPYTER_NOTEBOOK_SERVICE_GROUP="${JUPYTER_NOTEBOOK_SERVICE_GROUP:-jupyter}"
export JUPYTER_NOTEBOOK_SERVICE_USER="${JUPYTER_NOTEBOOK_SERVICE_USER:-jupyter}"
export JUPYTER_NOTEBOOK_USERNAME="${JUPYTER_NOTEBOOK_USERNAME:-jupyter}"
export JUPYTER_NOTEBOOK_VENV="${JUPYTER_NOTEBOOK_VENV:-/opt/venvs/jupyter-${PYTHON_VERSION}}"
