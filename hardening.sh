#!/bin/bash
mkdir -p logs
mkdir -p processed
mkdir -p tags-extract
echo && echo "Reading Tags files from tags-extract/" && echo
if find tags-extract/  -mindepth 1 -maxdepth 1 | read; then
  cd tags-extract/
  for i in *
  do
    name=$(echo "$i" | awk -F'-tags' '{print $1}')
    value=$(<"$i")
    if  [ -s "$i" ]; then
      echo "Executing : ansible-playbook -i $name, hardening.yml --tags $value" && echo
      sleep 5
      script --flush --quiet --return ../logs/$name'.log' --command "ansible-playbook -i $name, --extra-vars 'ansible_ssh_user=root' ../hardening.yml --tags $value --diff"
    else 
      echo "Executing :  ansible-playbook -i $name, ../hardening.yml --diff" && echo
      sleep 5
      script --flush --quiet --return ../logs/$name'.log' --command "ansible-playbook -i $name, --extra-vars 'ansible_ssh_user=root' ../hardening.yml --diff"
    fi
    mv $i ../processed/
  done 
fi
echo "No more tag files, executing full playbook on inventory file." && echo
sleep 5
 cd tags-extract/
if  [ -s ../inv.ini ]; then
 for line in $(cat ../inv.ini)
  do 
    if [[ ! -z "$1" ]]; then
      name=$line
      echo "$name"
      echo "Executing : ansible-playbook -i $name, hardening.yml --diff --skip-tags $1" && echo
      sleep 5 &
      script --flush --quiet --return ../logs/$name'.log' --command "ansible-playbook -i $name, --extra-vars 'ansible_ssh_user=root' ../hardening.yml --diff --skip-tags $1"
    else
      name=$line
      echo "$name"
      echo "Executing : ansible-playbook -i $name, hardening.yml --diff" && echo
      sleep 5 &
      script --flush --quiet --return ../logs/$name'.log' --command "ansible-playbook -i $name, --extra-vars 'ansible_ssh_user=root' ../hardening.yml --diff"
    fi
done 
fi
