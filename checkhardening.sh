#!/bin/bash
mkdir -p tags-extract
mkdir -p check-logs
echo && echo "Reading Tags files from tags-extract/*." && echo
if find tags-extract/  -mindepth 1 -maxdepth 1 | read; then
  cd tags-extract/
  for i in *
  do
    name=$(echo "$i" | awk -F'-tags' '{print $1}')
    value=$(<"$i")
    if  [ -s "$i" ]; then
      echo "Executing : ansible-playbook -i $name, hardening.yml --tags $value" && echo
      sleep 5
      script --flush --quiet --return ../check-logs/$name'.log' --command "ansible-playbook -i $name, --extra-vars 'ansible_ssh_user=root' ../hardening.yml --tags $value --diff --check"
    else 
      echo "Executing :  ansible-playbook -i $name, ../hardening.yml --diff" && echo
      sleep 5
      script --flush --quiet --return ../check-logs/$name'.log' --command "ansible-playbook -i $name, --extra-vars 'ansible_ssh_user=root' ../hardening.yml --check --diff"
    fi
#    mv $i ../processed/
  done 
fi
echo "No more tag files, executing full playbook on inventory file." && echo
sleep 5
 cd tags-extract/
if  [ -s ../inv.ini ]; then
 for line in $(cat ../inv.ini)
  do 
    name=$line
    echo "$name"
    echo "Executing : ansible-playbook -i $name, hardening.yml --diff" && echo
    sleep 5 &
    script --flush --quiet --return ../check-logs/$name'.log' --command "ansible-playbook -i $name, --extra-vars 'ansible_ssh_user=root' ../hardening.yml --diff --check"
#      mv $i ../processed/
done 
fi
