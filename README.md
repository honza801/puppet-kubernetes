```
apt install -y puppet gpg
puppet apply --modulepath modules/ -e "include role" -t
```
