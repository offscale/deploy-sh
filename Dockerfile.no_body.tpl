FROM ${image}

COPY . /scripts
WORKDIR /scripts

${BODY}