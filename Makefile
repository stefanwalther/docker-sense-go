
d-build:
	docker build -t stefanwalther/sense-go .

gen-readme:
	docker run --rm -v ${PWD}:/opt/verb stefanwalther/verb

run:
	docker run --rm -v ${PWD}:/opt/sense-go stefanwalther/sense-go sense-go build

cci-local:
	echo $DOCKER_USER
	circleci build -e DOCKER_USER="stefanwalther" -e DOCKER_PASS=$(DOCKER_PASS)
