#!/bin/bash

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

#wait until head creates secret key and pass to etc/munge
while [ ! -f /scratch/munge.key ]
do
  sleep 10
done
sudo cp /scratch/munge.key /etc/munge/munge.key

#correct permissions
sudo chown -R munge: /etc/munge/ /var/log/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/

while [ ! -f /scratch/metakey.fin ]
do
  sleep 10
done

#start munge service
sudo systemctl enable munge
sudo systemctl start munge

#install slurm dependencies
sudo yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad -y

#install slurm
while [ ! -f /scratch/rpm.fin ]
do
  sleep 10
done

sudo yum --nogpgcheck localinstall /software/slurm-rpms/* -y

#compute configuration
sudo cp /scratch/slurm.conf /etc/slurm/slurm.conf
sudo mkdir /var/spool/slurmd
sudo chown slurm: /var/spool/slurmd
sudo chmod 755 /var/spool/slurmd
sudo touch /var/log/slurmd.log
sudo chown slurm: /var/log/slurmd.log

#setup clock
sudo yum install ntp -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo systemctl start ntpd

#enable slurm daemon
while [ ! -f /scratch/dbd.fin ]
do
  sleep 5
done
sudo systemctl enable slurmd
sudo systemctl start slurmd
#sudo rm /scratch/dbd.fin
sudo touch /scratch/d.fin


