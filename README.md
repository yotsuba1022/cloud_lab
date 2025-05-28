# Project Nebuletta

> _The seed of a cloud-borne civilization,  
> shaped in code, summoned into existence._

---

**Nebuletta** is an experimental Infrastructure-as-Code (IaC) project aimed at rapidly provisioning self-managed cloud infrastructure using [Terraform](https://www.terraform.io/) on public cloud platforms.

This project is built with **AWS** as the default cloud provider. It includes a set of composable, self-contained modules that can be flexibly assembled based on different deployment scenarios.

To manage orchestration, **[Terramate](https://terramate.io/)** is used instead of introducing additional domain-specific frameworks like Terragrunt. This choice keeps the entire infrastructure stack purely in Terraform's native language, ensuring simplicity and consistency.
  
The project documentation is maintained in a separate repository, [click here to view the documentation](https://github.com/nekowanderer/nebuletta-notes).

---