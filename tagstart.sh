#!/bin/bash
echo 'Reading Tags file'
cd tags-extract/
for i in *
do 
  name=$(echo "$i" | awk -F'-tags' '{print $1}')
  value=$(<"$i")
  echo "Executing : ansible-playbook -i $name, test.yml --tags $value"
  sleep 5
#  ansible-playbook -i $name, test.yml --tags [$value]  tee $name'.log'
  script --flush --quiet --return ../logs/$name'.log' --command "ansible-playbook -i $name, --extra-vars 'ansible_ssh_user=root' ../test.yml --tags $value --diff"
  mv $i ../processed/ 
done
