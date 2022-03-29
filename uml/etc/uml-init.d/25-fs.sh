mount -t tmpfs -o rw,seclabel,nosuid,nodev,size=$((MEMTOTALKB/2))k,nr_inodes=1048576,inode64 tmpfs /tmp || :
mount -t proc -o rw,nosuid,nodev,noexec,relatime proc /proc || :
mount -t sysfs -o rw,seclabel,nosuid,nodev,noexec,relatime sysfs /sys || :
mkdir -p /dev/shm || :
mount -t tmpfs -o rw,seclabel,nosuid,nodev,size=$((MEMTOTALKB/2))k,nr_inodes=1048576,inode64 tmpfs /dev/shm || :
mkdir -p /dev/pts || :
mount -t devpts -o rw,seclabel,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 devpts /dev/pts || :
mount -t tmpfs -o rw,seclabel,nosuid,nodev,size=$((MEMTOTALKB/2))k,nr_inodes=819200,mode=755,inode64 tmpfs /run || :
mount -t cgroup2 -o rw,seclabel,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot cgroup2 /sys/fs/cgroup || :
mount -t pstore -o rw,seclabel,nosuid,nodev,noexec,relatime pstore /sys/fs/pstore || :

