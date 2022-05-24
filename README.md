# Ansible

## Installation
1. Installing Ansible on Ubuntu
    ```
     sudo apt update
     sudo apt install software-properties-common
     sudo add-apt-repository --yes --update ppa:ansible/ansible
     sudo apt install ansible
     
     ansible --version
     ```
## What is Ansible?
- Ansible is configuration management tool.
- Ansible is simple open-source-IT engine, which automates application deployment.
- Uses yaml scripting language which works on key-value pair.
- 
### Ansible Playbook
- Ansible playbook are list of tasks that automatically execute against hosts. roups of hosts form your Ansible inventory.
  Each module within an Ansible playbook performs a specific tasks.
  
### Ansible Inventory
- Ansible works against multiple managed hosts in your infrastructure at same time, using a list or group of lists is known as inventory.
     ```
      Example:
         
        [webservers]
        foo.example.com
        bar.example.com
        [all]
        10.20.45.222
        11.22.33.444
        12.66.55.445
        
 ### Ansible Roles
 - Roles provide a framework for fully independent or interdependent collections of files, tasks, templates, variables, and modules.
 
 ### commands
  ```
  ansible-playbook -i inventory playbookname.yaml
  ```
 
