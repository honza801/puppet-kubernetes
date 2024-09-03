### How to use

```
apt install -y puppet gpg git
puppet apply --modulepath modules/ -e "include role" --test
```

### Roles
* `common`
* `docker::ce`
* `docker::containerd`
* `kubernetes`

### Update repo only
```
puppet apply --modulepath modules/ -e "class {'kubernetes::repository': minor_version => '1.29'}" --test
```
