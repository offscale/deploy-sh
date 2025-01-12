FROM alpine:latest

COPY . /scripts
WORKDIR /scripts

ARG SERVE_ACTIX_DIESEL_AUTH_SCAFFOLD=1
ARG SERVE_ACTIX_DIESEL_AUTH_SCAFFOLD_VERSION='*'

RUN <<-EOF

if [ "${SERVE_ACTIX_DIESEL_AUTH_SCAFFOLD:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/app/third_party/serve-actix-diesel-auth-scaffold/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

EOF


ARG JUPYTERHUB=1
ARG JUPYTERHUB_VERSION='*'

RUN <<-EOF

if [ "${JUPYTERHUB:-0}" -eq 1 ]; then
  SCRIPT_NAME="${SCRIPT_ROOT_DIR}"'/app/third_party/jupyterhub/setup.sh'
  export SCRIPT_NAME
  # shellcheck disable=SC1090
  . "${SCRIPT_NAME}"
fi

EOF


