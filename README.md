# Misc. containers

## UML in a container

    buildah build -t uml -f Containerfile-uml.in

    podman run --privileged -it uml [-- [-- command [arg ...]]]

## Socket activated web server, in a container

    cat >/var/www/html/index.html <<'EOF'
    Hello World!
    EOF

### Image, socket listener and container

Build the image and start the socket listener. The examples use
systemd-socket-activate to simulate a systemd socket activated service
environment.

#### httpd in a container

    buildah build -t unixhttpd -f Containerfile-unixhttpd.in

    systemd-socket-activate --listen http.sock \
    podman run \
      --init -it unixhttpd

#### httpd in a UML container

    buildah build -t umlhttpd -f Containerfile-umlhttpd.in

    systemd-socket-activate --listen http.sock \
    podman run \
      --init -it --privileged umlhttpd

### Test access

    curl --silent --unix-socket http.sock http://_/

