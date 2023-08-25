# self hosted keyserver

**server**: [https://gitlab.com/keys.openpgp.org/hagrid](hagrid)

## Setup

I want to have a Docker Image that i can easily deploy

build: \
`docker build -t hagrid-pgp-key-server .`

run: \
`docker run --dns=1.1.1.1 -p 8080:8080 hagrid-pgp-key-server:latest`

## TODOs

- [x] Setup a prod ready env so i can run `cargo build --relase`
  - adapt `Rocket.toml` and put it in the docker image generation

### Debugging Notes 

- port 8090 which is mentioned in the `nginx.conf`
  does give the http warning and says unable to connect

- nginx root is at `dist/public`

- exposing docker port and not being in vpn 
