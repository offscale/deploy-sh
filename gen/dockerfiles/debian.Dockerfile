FROM debian:bookworm-slim
ARG NODEJS_INSTALL_DIR=1
ARG NODEJS_VERSION='lts'

ARG PYTHON_INSTALL_DIR=1
ARG PYTHON_VERSION='3.10'

ARG RUST_INSTALL_DIR=1
ARG RUST_VERSION='nightly'

ARG POSTGRES_URL=1
ARG POSTGRES_USER='rest_user'
ARG POSTGRES_PASSWORD='rest_pass'
ARG POSTGRES_DB='rest_db'
ARG POSTGRES_PASSWORD_FILE
ARG POSTGRES_VERSION='17'

ARG REDIS_URL=1
ARG VALKEY_VERSION='*'

ARG SERVE_ACTIX_DIESEL_AUTH_SCAFFOLD=1
ARG SERVE_ACTIX_DIESEL_AUTH_SCAFFOLD_DEST='/tmp/serve-actix-diesel-auth-scaffold'
ARG SERVE_ACTIX_DIESEL_AUTH_SCAFFOLD_VERSION='*'

ARG AMQP_URL=0
ARG RABBITMQ_VERSION='*'

ARG JUPYTERHUB=0
ARG JUPYTERHUB_VERSION='*'

ARG WWWROOT_NAME='example.com'
ARG WWWROOT_VENDOR='nginx'
ARG WWWROOT_PATH='./my_symlinked_wwwroot'
ARG WWWROOT_LISTEN='80'
ARG WWWROOT_example_com_INSTALL=0
ARG EXAMPLE_COM_VERSION='0.0.1'



COPY . /scripts
WORKDIR /scripts

RUN export SCRIPT_NAME='/scripts/install_gen.sh' && \
    . "${SCRIPT_NAME}"
