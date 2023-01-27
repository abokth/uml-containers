# Misc. containers

## UML in a container

    buildah build -t uml -f Containerfile-uml.in

    podman run --privileged -it uml [-- [-- command [arg ...]]]

