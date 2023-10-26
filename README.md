### How to use

```
apt install -y puppet gpg git
puppet apply --modulepath modules/ -e "include role" -t
```

### Roles
* `common`
* `docker::ce`
* `docker::containerd`
* `kubernetes`

