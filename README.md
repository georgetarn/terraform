# SensuGo Cluster provisioning with Ansible and Terraform
Terraform templates for provisioning a sensu-go cluster with terraform and ansible

## Architecture

(https://docs.sensu.io/sensu-go/5.11/guides/deploying/)
![ARCHITECTURE](docs/clustered_architecture.svg)

## Getting started

```
1. Clone the repo
2. cd into the repo
3. cp terraform.tfvars.example terraform.tfvars
```

After doing the template copy above, you can now populate the variables as you wish. Once done run:

```
terraform init
terraform plan
terraform apply
```

### Prerequisites

### Installing

## Deployment

TODO: Add additional notes about how to deploy this on a live system

## Built With

* [Terraform](https://www.terraform.io/) - Infrastructure provisioning
* [Ansible](https://www.ansible.com/) - Configuration Management

## Contributing

TODO: Add some contribution guidelines

## Versioning

TODO: Add release strategy

## Authors

* **David Linares** - *Initial work* - 
* **George Tarnaras** - *Initial work* - 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
