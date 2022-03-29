# This container must be run with
#  podman run --privileged --network=slirp4netns:mtu=1500 -it <containername>

tunctl
/sbin/ip addr del 10.0.2.100/24 dev tap0
/sbin/brctl addbr br0
/sbin/brctl addif br0 tap0
/sbin/brctl addif br0 tap1
/sbin/ip link set dev br0 up
/sbin/ip link set dev tap1 up

CMD+=("vec0:transport=tap,ifname=tap1,depth=128,gro=1")

