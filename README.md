# cis_security

A collection to implement Center for Internet Security (CIS) controls for RHEL (7-8) and RHEL clones (Rhel, Oracle),Ubuntu 20.04 LTS and Ubuntu 22.04 LTS.

### Introduction

The [Center for Internet Security](https://www.cisecurity.org/) provides a set of
security benchmarks for operating systems designed to decrease the vulnerability vectors of a system.

These benchmarks are published in PDFs for non-commercial use. This role is an implementation of
those controls for various Operating Systems per the list below. The controls themselves are not published here and
you should visit CIS for a copy of the PDF. These automations are provided as a resposne and a tool to
help systems administrators secure machines based off those recommendations. This collection is not
endorsed by the Center for Internet Security in any way.

This collection contains a role that is designed to layer under other Ansible roles that install software packages, users, etc. It should be idempotent and can be run at any time. As usual with Ansible, make sure that later playbooks don't modify
files that are modified in this role.

Benchmark Versions:
| Operating System | 
| -----------------|-------------- |
| RHEL 8           |
| RHEL 9           |
| Oracle Linux 8   |
| Oracle Linux 9   |
| Ubuntu 20.04 LTS |
| Ubuntu 22.04 LTS |

- Some distributions use older CIS benchmarks that were the most recent at the time of creation. Efforts have
been made to update the controls to work with the newer operating systems. Older versions of the benchmarks are listed in parenthesis.
### Requirements

Control machine:
- Ansible 2.9+
- Machine connected to a package repository source (Satellite or yum repo)

Target machine:
- SSH connection with prviiledge escalation on Linux machines.
  - Python interpreter

Collection Requirements:
- ansible.builtin
- community.general

Requries Ansible 3 or ansible-core 2.11 or better due to runtime.yml being set up for Automation Hub.

For most of the collection to work, you will need to have a package repo where you can install packages for
the target machine. Registering with Satellite, a package repository, SCM, or a local package collection is recommended before using this, unless you exclude any tags that install packages.

### Use and Care
The collection is designed to run on the machines in the chart above. It may run on other Red Hat and Ubuntu deriviatives, but it has not been tested on them. Upon initiation, the collection will automatically detect the OS and run the appropriate task list.

As the role runs, you will see an output listing the control number and a brief description of the
task being performed (or skipped):

```
TASK [security-rollup : 1.7.1.3 - Set SELinux policy to targeted] ******************************
ok: [192.168.122.252]
```

The controls are implemented as Ansible tags. By default all tags are run on a given system. To
disable a tag from running, run the playbook with the tag excluded (--skip-tags "x.y.z"):

```
ansible-playbook -i <inventory> <playbook.yml> --skip-tags "x.y.z"
```
Multiple tags can be listed, separated by commas:
```
ansible-playbook -i <inventory> <playbook.yml> --skip-tags "x.y.z,a.b.c"
```
Note: Some automation tasks handle multiple controls. In the role you may see something like this:

```
- name: 6.1.[2,4] - Ensure permissions on /etc/passwd /etc/group
  file:
    path: /etc/{{item}}
    owner: root
    group: root
    mode: 0644
  loop:
    - passwd
    - group
  tags:
    - 6.1.2
    - 6.1.4
```
* In this control, two tags are being processed, '6.1.2' and '6.1.4' if you want this control to not
run, you must exclude both tags:

```
ansible-playbook -i <inventory> <playbook.yml> --skip-tags "6.1.2,6.1.4"
```
In addition to tags, there are a number of variables that can be set which will enable or disable
tasks, or set values. These are explained and given default values in the **roles/cis-security/defaults/main.yml**
file. Do not set these values in that file, but create and include your own variable file to override the
defaults or set them as host variables.

### Change Log
Based on ansible-galaxy collection dsglaser.cis_security

