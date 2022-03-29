mount -t tmpfs -o size=$((MEMTOTALKB/2))k,nr_inodes=1048576,inode64 tmpfs /tmp || :
mount -t tmpfs -o exec,size=$((MEMTOTALKB/2))k,nr_inodes=1048576,inode64 tmpfs /dev/shm || :
mount -o remount,exec,size=$((MEMTOTALKB/2))k,nr_inodes=1048576 /dev/shm || :

