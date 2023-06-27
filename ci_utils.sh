#!/bin/bash

function __print_usage_and_exit
{
  echo "Usage: make_available [-ip REMOTE_IP | -host REMOTE_HOST] -ports [comma seperated list of ports to tunnel] "
  exit 1
}

function __run
{
  echo "Executing: >$@<"
  eval "$@"
}

function __exit_if_pid_not_exists
{
  pid=$1
  kill -0 $pid
  if [ "$?" != 0 ]; then
        echo "*****"
        echo "Error."
        cat $lg_file
        exit 1
  fi
}

function tunnel_ssh
{

  #l_addr=$(ifconfig docker0 | grep inet | head -1 | awk '{ print $2 }')

  l_host_str=$1
  l_host=$2

  l_port_str=$3
  l_port=$4

  r_host_str=$5
  r_host=$6

  r_port_str=$7
  r_port=$8

  lg_file_str=$9
  lg_file=${10}

  chmod 400 $BASTION_KEY

  #if [ ! -z $BASTION_USER ]; then
    __run "ssh -i $BASTION_KEY $BASTION_USER@$BASTION_HOST -L $l_host:$l_port:$r_host:$r_port -o StrictHostKeyChecking=no -v -v -v -N &> $lg_file &"
  #else
  #   __run "ssh -i $BASTION_KEY $BASTION_HOST -L $l_host:$l_port:$r_host:$r_port -o StrictHostKeyChecking=no -v -v -v -N &> $lg_file &"
  #fi
  pid=$!
  sleep 3
  __exit_if_pid_not_exists $pid  

}


function make_available
{
  if [[ -z $BASTION_USER || -z $BASTION_HOST || -z $BASTION_KEY ]]; then
  	echo "Error: You need to provide  \$BASTION_HOST , \$BASTION_KEY and \$BASTION_USER env variables to continue"
	__print_usage_and_exit
  fi

  if [ ! -f $BASTION_KEY ]; then
  	echo "File $BASTION_KEY not found"
	__print_usage_and_exit
  fi  
  
  host_name_str=$1
  r_host=$2

  ports_list=$3
  ports=$4

  local_ip_str=$5
  local_ip=$6

  if [ "$local_ip_str" == "" ]; then
  	local_ip="127.0.0.1"
  fi

  if [ "$host_name_str" != "-ip" ]; then
  	__run "echo "$local_ip    $r_host" >> /etc/hosts"
  fi

  for port in ${ports//,/ };
  do
  	tunnel_ssh -lhost $local_ip -lport $port -rhost $r_host -rport $port -log $r_host.$port.ssh.log
  done
}


