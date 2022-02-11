.PHONY: build-amd64 build-arm64 run-amd64 run-arm64 wrk

build: build-amd64 build-arm64

build-amd64:
	docker buildx build --load --platform linux/amd64 -t flyinprogrammer/uwsgi-flask-demo:amd64 .

build-arm64:
	docker buildx build --load --platform linux/arm64 -t flyinprogrammer/uwsgi-flask-demo:arm64 .

run-amd64:
	docker run --platform linux/amd64 --init --rm -it -p 8080:8080 -p 8081:8081 flyinprogrammer/uwsgi-flask-demo:amd64

run-arm64:
	docker run --platform linux/arm64 --init --rm -it -p 8080:8080 -p 8081:8081 flyinprogrammer/uwsgi-flask-demo:arm64

wrk:
	wrk -t8 -c20 -d2s http://127.0.0.1:8080/

uwsgitop:
	uwsgitop http://127.0.0.1:8081/

push:
	docker buildx build --push --platform linux/amd64 -t flyinprogrammer/uwsgi-flask-demo:amd64 .
	docker buildx build --push --platform linux/arm64 -t flyinprogrammer/uwsgi-flask-demo:arm64 .
