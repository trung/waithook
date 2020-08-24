FROM ubuntu:xenial as builder

RUN apt-get update \
    && apt-get install -y pkg-config libssl-dev curl \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ADD . /workspace
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cd /workspace && cargo install --path . --root .

FROM ubuntu:xenial
RUN apt-get update \
    && apt-get install -y libssl-dev netcat
COPY --from=builder /workspace/bin/waithook /usr/local/bin/
COPY --from=builder /workspace/public /public

WORKDIR /
EXPOSE 3012
ENTRYPOINT [ "waithook" ]
