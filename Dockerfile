FROM centurylink/ca-certs

MAINTAINER Ozzy <ozzy@ca.ibm.com> 

ADD etcd-backup /
ADD fixtures/etcd-configuration.json /etcd-configuration.json
ADD fixtures/backup-configuration.json /backup-configuration.json

ENTRYPOINT [ "/etcd-backup" , "-config" , "/backup-configuration.json" , "-etcd-config" , "/etcd-configuration.json" ]
