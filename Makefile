build:
	@cargo build --release

cp:
	@cp -f ./target/release/gone_money .

runserver:
	@postgrest ./gone_money.conf

secret:
	@LC_CTYPE=C head -c 32 /dev/urandom | base64

.PHONY: build cp
