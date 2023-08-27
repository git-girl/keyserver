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
- [ ] Setup nginx reverse proxy (and learn understand reverse proxy setups)
- [ ] Understand wth the token secret is being used for 

### Debugging Notes 

- port 8090 which is mentioned in the `nginx.conf`
  does give the http warning and says unable to connect

- nginx root is at `dist/public`

- exposing docker port and not being in vpn 

### `token_secret`

The token secret is passed into a sealed state of some service

that then gets store in the rocket::State and gets called mostly in `vks_web` and passed on down \
however it seems as if it gets overwritten but thats probably the statefull tokens however how are \
they differentiated? \
-> statefull tokens are store in `&rocket::State<database::StatefulTokens>` \ 
using manage this here gets also thrown into the `&rocket::State<tokens::Service>`

`let stateless_token_service = configure_stateless_token_service(figment)?;` \
`fn configure_stateless_token_service(config: &Figment) -> Result<tokens::Service> {`

the rocket state gets put into the variables `tokens_stateless` and `token_service` only in the `web` module.

however the web module passes it down

it is a `sealed_state` girl... thats a `mod`...  \
reading that makes it pretty clear that the sealed state is something that's used to 

`SealedState` is a struct that has a `signing_key` and an `opening_key` \

