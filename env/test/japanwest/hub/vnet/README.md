Hub VNET
====

## パラメータ穴埋め

```sh
cp terraform.tfvars.sample terraform.tfvars
vi terraform.tfvars
```

## 実行手順

```sh
terraform init
terraform plan -target=module.vnet
terraform apply -target=module.vnet
```

別リージョンも実施して、`terraform.tfvars`の`subregion_virtual_network_id`のパラメータを埋める

残りを実施

```sh
terraform plan
terraform apply
```
