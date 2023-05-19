```
apt install -y puppet
puppet apply --modulepath modules/ -e "include role" -t
```
