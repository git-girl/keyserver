# self hosted keyserver

**server**: [https://gitlab.com/keys.openpgp.org/hagrid](hagrid)

## Setup

I want to have a Docker Image that i can easily deploy

build: \
`docker build --network=host -t hagrid-pgp-key-server .`

run: \
`docker run hagrid-pgp-key-server:latest ./target/release/hagrid`

## TODOs

- [ ] Setup a prod ready env so i can run `cargo build --relase`
  - adapt `Rocket.toml` and put it in the docker image generation