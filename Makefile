default: all

uml:
	buildah build -t $@ Containerfile-$@.in

all: uml

.PHONY: uml

