ARG UPSTREAM_VERSION
FROM flashbots/mev-boost:${UPSTREAM_VERSION#v}

ARG NETWORK

ENV NETWORK=${NETWORK}

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]