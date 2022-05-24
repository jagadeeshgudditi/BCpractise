
# Terraform



## what is Terraform?
```
 - Terraform is an infrastructure as code(Iac) tool that allows us to build, change, and version infrastructure safely and efficiently.
 - Terraform is a tool for infrastructure provising.
```

### components:


1. providers- provides cloud providers, saas providers, and other Apis
2. Resources- Each resource block describes one or more infrastucture objects, such as virtual networks, virtual machines and subnet.
3. Varibles- Using variables in terraform configurations makes our deployment more dynamic.
                - A seperate file with name "varibles.tf" needs to be created in the working directory to store all variables for our
                  used in main.tf configuration file.
4. statefile- After the deployment is finished terraform creates a state file to keep track of current state of infrastructure, it
will useful to compare "current state" with "desired state".

## Commands

  1. Terraform init - initialize directory, pull down providers
  ` terraform init`
  2. Terraform validate- Validate code for syntax
    ` terraform validate `
  3. Terraform plan- output the deployment plan
     ` terraform plan `
  4. Terraform apply - apply changes without being prompted to enter "yes"
     `terraform apply --auto-approve `
  5. terraform destroy- Cleanup /destroy deployment 
      `terraform destroy --auto-approve `
  
## contributing
1. After terraform apply with successfully, it will deploy various resources.
2. resources- virtual machine, virtual network, subnet,network interface, network security group.
3. This resources are available in cloud provider(azure).




# Kubernetes

## What is kubernetes?
```
- kubernetes is container orchestration tool
- Developed by google
- Helps to manage containerized applications
```
## Kubernetes cluster
 - A kubernetes cluster is a set of nodes that run containerized applications. Containerizing applications packages an app with its dependences and
   some necessary services. They are more lightweight and flexible than virtual machines. 
### Different Nodes
    
     1. Master node
     2. Worker node
    
    
     
   Masternode - Master node, which controls and manages a set of worker nodes(workloads runtime) and resembles a cluster in kubernetes 
   Worker node- Worker nodes are the part of the kubernetes clusters which actually execute the containers and applications on them. They have two main
                 components, the Kublet service and the kube-proxy service.
