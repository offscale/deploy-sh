FROM debian:bookworm-slim

ENV LIBSCRIPT_ROOT_DIR='/scripts'
ENV LIBSCRIPT_BUILD_DIR='/libscript_build'
ENV LIBSCRIPT_DATA_DIR='/libscript_data'


COPY . /scripts
WORKDIR /scripts

###########################
# Toolchain(s) [required] #
###########################
ARG NODEJS_INSTALL_DIR=1
ARG NODEJS_VERSION='lts'

RUN <<-EOF

if [ "${NODEJS_INSTALL_DIR:-1}" -eq 1 ]; then
  if [ ! -z "${NODEJS_DEST+x}" ]; then
    previous_wd="$(pwd)"
    DEST="${NODEJS_DEST}"
    export DEST
    [ -d "${DEST}" ] || mkdir -p "${DEST}"
    cd "${DEST}"
  fi
  if [ ! -z "${NODEJS_VARS+x}" ]; then
    export VARS="${NODEJS_VARS}"
  fi
  if [ ! -z "${NODEJS_COMMANDS_BEFORE+x}" ]; then
    SCRIPT_NAME="${LIBSCRIPT_DATA_DIR}"'/setup_before_nodejs.sh'
    export SCRIPT_NAME
    install -D -m 0755 "${LIBSCRIPT_ROOT_DIR}"'/prelude.sh' "${SCRIPT_NAME}"
    printf '%s' "${NODEJS_COMMANDS_BEFORE}" >> "${SCRIPT_NAME}"
    # shellcheck disable=SC1090
    . "${SCRIPT_NAME}"
  fi
  SCRIPT_NAME="${LIBSCRIPT_ROOT_DIR}"'/'"${NODEJS_COMMAND_FOLDER:-_lib/_toolchain/nodejs}"'/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  if [ -f "${SCRIPT_NAME}" ]; then
    . "${SCRIPT_NAME}";
  else
    >&2 printf 'Not found, SCRIPT_NAME of %s\n' "${SCRIPT_NAME}"
  fi
  if [ ! -z "${NODEJS_DEST+x}" ]; then cd "${previous_wd}"; fi
fi

EOF


