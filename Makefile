
d-build:
	docker build -t stefanwalther/sense-go .

gen-readme:
	docker run --rm -v ${PWD}:/opt/verb stefanwalther/verb

run:
	docker run --rm -v ${PWD}:/opt/verb stefanwalther/sense-go build

cci-local:
	circleci build
