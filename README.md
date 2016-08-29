# etcd-backup

etcd-backup is a simple, efficient and lightweight command line utility to backup and restore [etcd](https://github.com/coreos/etcd) keys, from a containerised etcd, accessed by docker link.

## Dependencies

etcd-backup dependencies are automatically obtained during the container build process.

## Installation

  Installation composed of 3 steps:

* Install Go
  * GVM is an easy way..
  * `bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)`
  * `gvm install go1.4`
  * `gvm use go1.4`
  * `gvm install go1.6`
  * `gvm use go1.6`
* Download the project `git clone git@github.com:gameontext/etcd-backup.git`
  * Use `build.sh` to build the container gameon/etcdbackup


(If we get the built docker image into a repo, this could all be a lot faster...)

## Dumping

### Usage

    $ docker run -v $(pwd):/backup -link etcd gameon/etcdbackup dump

This will dump the whole `etcd` keyspace. Results will be stored in a yaml file `dump.yaml`
in the directory where you executed the command.

If your etcd container is not called `etcd` then use `-link myetcdcontainername:etcd` instead of `-link etcd`

The default Backup strategy for dumping is to dump all keys and preserve the order : `keys:["/"], recursive:true, sorted:true`
The backup strategy can be overwritten in the etcd-backup configuration file. See _fixtures/backup-configuration.json_ If you alter
this file, you will need to rebuild the container using `build.sh`.

### Dump File structure

Dumped keys are stored in an array of keys, the key path is the absolute path. By design non-empty directories are not saved in the dump file, and empty directories do not contain the `value` key:

```
- key: /myKey
  value: value1
- key: /dir/mydir/myKey
  value: test
- key: /dir/emptyDir
```  

## Restoring

### Usage

    $ docker run -v $(pwd):/backup -link etcd gameon/etcdbackup restore

Restore the keys from the `dump.yaml` file.

Restore supports Strategy, you can restore some part of the dumpfile or the entire dump if you want to. (Note that because the config is inside the docker image, you'll need to rebuild the container via `build.sh` if you want to do this)
```
  {
    "backupStrategy":
    {
      "keys": ["/"],
      "recursive": true
    }
  }
```
Will Recursively restore all the keys inside `/`.
```
  {
    "backupStrategy":
    {
      "keys": ["/myKey"],
      "recursive": true
    }
  }
```
Will only restore the keys under `/myKey`.
