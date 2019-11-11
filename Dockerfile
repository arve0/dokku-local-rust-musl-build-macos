FROM gliderlabs/alpine:3.4
ENTRYPOINT ["target/release/dokku-local-rust-musl-build-macos"]