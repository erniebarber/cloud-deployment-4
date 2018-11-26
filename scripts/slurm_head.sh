#!/bin/bash

#create global users
export MUNGEUSER=991
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
sudo export SLURMUSER=992
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

#install munge
sudo yum install epel-release -y
sudo yum install munge munge-libs munge-devel -y

#munge secret key setup
sudo yum install rng-tools -y
sudo rngd -r /dev/urandom

#create munge secret key
sudo /usr/sbin/create-munge-key -r
sudo dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

#pass munge secret key to compute nodes
sudo cp /etc/munge/munge.key /scratch

#correct permissions
sudo chown -R munge: /etc/munge/ /var/log/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/

#start munge service
sudo systemctl enable munge
sudo systemctl start munge

#install slurm dependencies
sudo yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad -y

#install slurm in the shared folder
sudo cd /software
sudo wget http://www.schedmd.com/download/latest/slurm-18.08.3.tar.bz2
sudo yum install rpm-build
sudo rpmbuild -ta slurm-18.08.3.tar.bz2
sudo cd /root/rpmbuild/RPMS/x86_64

sudo mkdir /software/slurm-rpms
sudo cp slurm-18.08.3-1.el7.centos.x86_64.rpm slurm-devel-18.08.3-1.el7.centos.x86_64.rpm slurm-munge-18.08.3-1.el7.centos.x86_64.rpm slurm-perlapi-18.08.3-1.el7.centos.x86_64.rpm slurm-plugins-18.08.3-1.el7.centos.x86_64.rpm slurm-sjobexit-18.08.3-1.el7.centos.x86_64.rpm slurm-sjstat-18.08.3-1.el7.centos.x86_64.rpm slurm-torque-18.08.3-1.el7.centos.x86_64.rpm /software/slurm-rpms

sudo touch /scratch/rpm.fin

sudo yum --nogpgcheck localinstall slurm-18.08.3-1.el7.centos.x86_64.rpm slurm-devel-18.08.3-1.el7.centos.x86_64.rpm slurm-munge-18.08.3-1.el7.centos.x86_64.rpm slurm-perlapi-18.08.3-1.el7.centos.x86_64.rpm slurm-plugins-18.08.3-1.el7.centos.x86_64.rpm slurm-sjobexit-18.08.3-1.el7.centos.x86_64.rpm slurm-sjstat-18.08.3-1.el7.centos.x86_64.rpm slurm-torque-18.08.3-1.el7.centos.x86_64.rpm

#head configuration
sudo mkdir /var/spool/slurmctld
sudo chown slurm: /var/spool/slurmctld
sudo chmod 755 /var/spool/slurmctld
sudo touch /var/log/slurmctld.log
sudo chown slurm: /var/log/slurmctld.log
sudo touch /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
sudo chown slurm: /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log

#setup clock
sudo yum install ntp -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo systemctl start ntpd

#enable slurm daemon
while [ ! -f /scratch/d.fin ]
do
  sleep 5
done
sudo rm /scratch/d.fin
sudo rm /scratch/munge.key
sudo systemctl enable slurmctld
sudo systemctl start slurmctld





