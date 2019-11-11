# Local rust build for your dokku server
Build your Rust project locally and push the binaries to your dokku-server.


## Why?
- You have a cheap virtual server,
- want faster deploy times
- and don't want to bog down the production CPU.


## Goal
- Easy deployment of web applications to dokku
- No git repo bloat / no history of built binary

### Vision
```sh
# install system dependencies, init repo configs
cargo dokku init your.dokku.host
git commit -m "added dokku build config"
# builds and pushes current version
cargo dokku deploy # bump major/minor/patch version? tag commit?
```

## How?
Follow this steps to deploy an actix-web application manually.

### setup
```sh
rustup target add x86_64-unknown-linux-musl
brew install FiloSottile/musl-cross/musl-cross
mkdir -p .cargo
echo '[target.x86_64-unknown-linux-musl]' >> .cargo/config
echo 'linker = "x86_64-linux-musl-gcc"' >> .cargo/config
```

### building
```sh
env CC_x86_64_unknown_linux_musl=x86_64-linux-musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
docker build -t dokku/dokku-local-rust-musl-build-macos:v0.1.0 .
```

### deployment
```
docker save dokku/dokku-local-rust-musl-build-macos:v0.1.0 | bzip2 | ssh dokku "bunzip2 | docker load"
ssh my.dokku.host "dokku tags:create test-app previous; dokku tags:deploy test-app v0.1.0"
```

## TODO
- setup script, make sure environment is OK
- use Cargo.toml to generate
    - dockerfile
    - build script
    - git hooks?
    - deploy script


## Resources
- https://www.andrew-thorburn.com/cross-compiling-a-simple-rust-web-app/
- https://timryan.org/2018/07/27/cross-compiling-linux-binaries-from-macos.html
- https://github.com/dokku/dokku/blob/master/docs/deployment/methods/images.md#deploying-an-image-from-ci