FROM gliderlabs/alpine:3.4
ENTRYPOINT ["target/x86_64-unknown-linux-musl/release/dokku-local-rust-musl-build-macos"]