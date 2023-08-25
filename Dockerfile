# i tried alpine but ran into issues with liblangc.so: 
# https://github.com/rust-lang/rust-bindgen/issues/2360
# but thought then that its not worth the hustle because 
# i install so much that i don't save so much space
# through alpine in the first place (as a percentage)
FROM ubuntu

# Install deps and things for rusttoolchain install
RUN apt update
RUN apt install -y git gnutls-bin nettle-dev gcc llvm-dev libclang-dev build-essential pkg-config gettext 

# install rust toolchain
WORKDIR /home
RUN git clone "https://gitlab.com/keys.openpgp.org/hagrid"

WORKDIR /home/hagrid
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Cargo install here is weird idk how to properly source it as sourcing cargo env just adds binaries to path i did that 
RUN cp Rocket.toml.dist Rocket.toml
# make sure there is a /home/hagrid/templates
RUN mkdir templates

RUN cargo build --release
# Execute with docker run hagrid-pgp-key-server:latest ./target/release/hagrid
