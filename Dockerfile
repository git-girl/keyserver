# i tried alpine but ran into issues with liblangc.so: 
# https://github.com/rust-lang/rust-bindgen/issues/2360
# but thought then that its not worth the hustle because 
# i install so much that i don't save so much space
# through alpine in the first place (as a percentage)
FROM ubuntu

# Install deps and things for rusttoolchain install
RUN apt update
RUN apt install -y git gnutls-bin nettle-dev gcc llvm-dev libclang-dev build-essential pkg-config gettext 
# TODO: install vim htop and net-tools i use those a lot when debugging

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

EXPOSE 8080 8080
# RUN cp Rocket.toml.dist Rocket.toml
CMD ./target/release/hagrid
