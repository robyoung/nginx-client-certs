
build-pki:
	./scripts/build.sh

clean-pki:
	rm -f ssl/*

test: build-pki
	docker-compose up -d backend
	docker-compose up -d proxy
	docker-compose run --rm client ./test.sh
	docker-compose down
