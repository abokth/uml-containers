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

## kAFS in a container

The UML container contains a kAFS enabled kernel. This adds the required userland.

    buildah build -t kafs -f Containerfile-kafs.in

    podman run --privileged -it kafs -- --afs-cell=example.org [-- command [arg ...]]

Note: Currently unresolved issue with rxprc keys from aklog-kafs prevents authenticated access.

## OpenAFS in a container

    buildah build -t openafs -f Containerfile-openafs.in

    podman run --privileged -it openafs -- --afs-cell=example.org [-- command [arg ...]]


## Socket activated web server with authenticated AFS client, in a container

Create a keytab path/to/krb5.keytab and put the principal name in path/to/krb5.keyname.

    cat >path/to/default.vhostconf <<'EOF'
    VirtualDocumentRoot /afs/example.org/www
    EOF

### Image, socket listener and container

Build the image and start the socket listener:

#### kAFS

    buildah build -t kafshttpd -f Containerfile-kafshttpd.in

    cat >path/to/thiscell.conf <<'EOF'
    [default]
    thiscell = example.org
    EOF

    systemd-socket-activate --listen http.sock \         ## This creates a socket activated environment
    podman run \                                         ## This is the command which is run when the socket is activated
      --mount=type=bind,source=path/to/thiscell.conf,destination=/etc/kafs/client.d/thiscell.conf,ro=true \
      --mount=type=bind,source=path/to/default.vhostconf,destination=/etc/httpd/conf.d/default.vhostconf,ro=true \
      --mount=type=bind,source=path/to/krb5.keytab,destination=/app/etc/afs/krb5.keytab,ro=true \
      --mount=type=bind,source=path/to/krb5.keyname,destination=/app/etc/afs/krb5.keyname,ro=true \
      --privileged --init -it kafshttpd

#### OpenAFS

    buildah build -t openafshttpd -f Containerfile-openafshttpd.in

    echo example.org >path/to/ThisCell
    echo '>example.org' >path/to/CellServDB

    systemd-socket-activate --listen http.sock \         ## This creates a socket activated environment
    podman run \                                         ## This is the command which is run when the socket is activated
      --mount=type=bind,source=path/to/ThisCell,destination=/app/etc/openafs/ThisCell,ro=true \
      --mount=type=bind,source=path/to/CellServDB,destination=/app/etc/openafs/CellServDB,ro=true \
      --mount=type=bind,source=path/to/default.vhostconf,destination=/etc/httpd/conf.d/default.vhostconf,ro=true \
      --mount=type=bind,source=path/to/krb5.keytab,destination=/app/etc/afs/krb5.keytab,ro=true \
      --mount=type=bind,source=path/to/krb5.keyname,destination=/app/etc/afs/krb5.keyname,ro=true \
      --privileged --init -it openafshttpd

### Test access

    curl --silent --unix-socket http.sock http://_/

