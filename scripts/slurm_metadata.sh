#!/bin/bash

sudo yum install mariadb-server mariadb-devel -y

#create global users
export MUNGEUSER=991
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=992
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

#install munge
sudo yum install epel-release -y
sudo yum install munge munge-libs munge-devel -y

#get secret key from head and pass to etc/munge
while [ ! -f /scratch/munge.key ]
do
  sleep 5
done
sudo cp /scratch/munge.key /etc/munge/munge.key

#correct permissions
sudo chown -R munge: /etc/munge/ /var/log/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/

sleep 120
sudo touch /scratch/metakey.fin

#start munge service
sudo systemctl enable munge
sudo systemctl start munge

#install slurm dependencies
sudo yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad -y

while [ ! -f /scratch/rpm.fin ]
do
  sleep 10
done
sudo yum --nogpgcheck localinstall /software/slurm-rpms/* -y

#metadata configuration
sudo mkdir /var/spool/slurmdbd
sudo chown slurm: /var/spool/slurmdbd
sudo chmod 755 /var/spool/slurmdbd
sudo touch /var/log/slurm/slurmdbd.log
sudo chown slurm: /var/log/slurm/slurmdbd.log
sudo touch /var/run/slurmdbd.pid
sudo chown slurm: /var/run/slurmdbd.pid
sudo cp /scratch/innodb.cnf /etc/my.cnf.d/innodb.cnf
sudo chown slurm: /etc/my.cnf.d/innodb.cnf

#setup mariedb
sudo systemctl start mariadb 
sudo systemctl enable mariadb 
sudo /usr/bin/mysql_secure_installation<<EOF
y
secret
secret
y
y
y
y
EOF

sudo mysql "-psecret" < "/scratch/dbd.sql"

#setup clock
sudo yum install ntp -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo systemctl start ntpd

#enable slurm daemon
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo touch /scratch/dbd.fin


