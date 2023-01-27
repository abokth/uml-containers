# Misc. containers

## UML in a container

    buildah build -t uml -f Containerfile-uml.in

    podman run --privileged -it uml [-- [-- command [arg ...]]]

## Socket activated web server, in a container

    cat >/var/www/html/index.html <<'EOF'
    Hello World!
    EOF

### Image, socket listener and container

Build the image and start the socket listener:

    buildah build -t unixhttpd -f Containerfile-unixhttpd.in

    systemd-socket-activate --listen http.sock \         ## This creates a socket activated environment
    podman run \                                         ## This is the command which is run when the socket is activated
      --privileged --init -it unixhttpd

### Test access

    curl --silent --unix-socket http.sock http://_/

