/sbin/ip link set vec0 up
/sbin/ip addr add 10.0.2.101/24 dev vec0
/sbin/ip route add default via 10.0.2.2

# Unknown why it takes 250 seconds to start.
echo >&2 "Waiting for network to activate..."
host one.one.one.one >/dev/null 2>&1

