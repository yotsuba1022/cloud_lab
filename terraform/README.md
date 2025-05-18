# About Terraform

### Commands
#### init
Init command is necessary for all terraform modules:
```bash 
$ terraform init 
```
In init phase, terraform will download the provider, generally speaking, Terraform core is just an abstraction; the specific behavior of resources and their interactions are determined by the provider.

#### plan
Plan command will try to compare all the .tf files and the actual content on the public cloud. It will show up the differences and output the plan for about the changes.
```bash
$ terraform plan
```

#### apply
If the plan meet our expectation, which means all the .tf files are good to go, then we can run the apply command against the public cloud for generating the resources we need. Ensure that you review all the apply information before type `yes`.
```bash
$ terraform apply
```

#### destroy
```bash
$ terraform destroy
```

#### General process
`init` -> `plan` -> `apply` -> `destroy`(optional)
