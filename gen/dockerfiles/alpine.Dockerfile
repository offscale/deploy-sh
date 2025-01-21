FROM alpine:latest

###########################
# Toolchain(s) [required] #
###########################
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
ARG POSTGRES_VERSION=17


ARG REDIS_URL=1
ARG VALKEY_VERSION='*'

ARG SADAS=1

ARG SADAS_COMMANDS='git_get https://github.com/SamuelMarks/serve-actix-diesel-auth-scaffold "${SADAS_DEST}"'
ARG SADAS_COMMAND_FOLDER='_lib/_server/rust'
ARG SADAS_DEST='/opt/serve-actix-diesel-auth-scaffold'

ARG AMQP_URL=0
ARG RABBITMQ_VERSION='*'

ARG JUPYTERHUB=0

ARG WWWROOT_example_com_NAME='example.com'
ARG WWWROOT_example_com_VENDOR='nginx'
ARG WWWROOT_example_com_PATH='./my_symlinked_wwwroot'
ARG WWWROOT_example_com_LISTEN=80
ARG WWWROOT_example_com_INSTALL=0

ARG example_com='./my_symlinked_wwwroot'
ARG WWWROOT_example_com_COMMAND_FOLDER='_lib/_toolchain/nodejs'
ARG WWWROOT_example_com_COMMANDS='npm i -g @angular/cli && \
npm i && \
ng build --configuration production'



COPY . /scripts
WORKDIR /scripts

RUN export SCRIPT_NAME='/scripts/install_gen.sh' && \
    . "${SCRIPT_NAME}"
