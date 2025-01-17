FROM ubuntu:focal

ENV LANG C
ENV DEBIAN_FRONTEND noninteractive

RUN apt update; \
    apt install -y \
        build-essential \
        pkg-config \
        libssl-dev \
        sudo \
        curl; \
    curl -s https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
            -o google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb 2>/dev/null \
    || echo; \
    apt -fy install; \
    dpkg -i google-chrome-stable_current_amd64.deb; \
    apt-get clean all;

# Install Rust and cargo
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y -q --profile minimal;

ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install mdbook \
    && cargo install mdbook-pdf \
    && cargo install cargo-cache; \
    cargo cache -a

WORKDIR /data
