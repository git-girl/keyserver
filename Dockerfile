# i tried alpine but ran into issues with liblangc.so: 
# https://github.com/rust-lang/rust-bindgen/issues/2360
# but thought then that its not worth the hustle because 
# i install so much that i don't save so much space
# through alpine in the first place (as a percentage)
FROM ubuntu

# Install deps and things for rusttoolchain install
RUN apt update
RUN apt install -y git gnutls-bin nettle-dev gcc llvm-dev libclang-dev build-essential pkg-config gettext 
RUN apt install -y vim htop net-tools

# install rust toolchain
WORKDIR /home
RUN git clone "https://gitlab.com/keys.openpgp.org/hagrid"

WORKDIR /home/hagrid
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo build --release

# --- COMPILES FINISHED -- #

RUN mkdir -p public/assets templates email-templates \
            tokens tmp keys public/keys   && \
    cp -r dist/assets          public/    && \
    cp -r dist/templates       .          && \
    cp -r dist/email-templates .

# use my server conf
COPY ./Rocket.toml ./Rocket.toml
# use my styling adaptions
COPY public/       ./public
COPY templates/    ./templates/

# Need something to only disable cache on specific commands
# -> the sed replace because with a cache the build fails there
# --build-arg CACHEBUST=$(openssl rand -base64 32)
# Basically a cache bust
# https://stackoverflow.com/questions/35134713/disable-cache-for-specific-run-commands
ARG TOKEN_SECRET

# THE COMMAND FAILS WHEN THERE IS A CACHE -> ARG CACHEBUST
# This command works local and in container but somehow not during build
# Step 12/14 : RUN sed -i -e "s/REPLACED_BY_SED/$(openssl rand -base64 32)/g" ./Rocket.toml
#  ---> Running in 1a00a7d6426b
# sed: -e expression #1, char 29: unknown option to `s'
# The command '/bin/sh -c sed -i -e "s/REPLACED_BY_SED/$(openssl rand -base64 32)/g" ./Rocket.toml' returned a non-zero code: 1
RUN sed -i -e "s/REPLACED_BY_SED/$TOKEN_SECRET/g" ./Rocket.toml

EXPOSE 8080 8080
# RUN cp Rocket.toml.dist Rocket.toml
CMD ./target/release/hagrid
