Hub Router Virtual Machines
====

Azure Firewall を使用しない場合の、Hub間ルーティング用の Router 役 VM 作成

## 前提
../ および、 ../vnet/ を実施済み

## パラメータ穴埋め

```sh
cp terraform.tfvars.sample terraform.tfvars
vi terraform.tfvars
```

## 実行手順

```sh
terraform init
terraform plan
terraform apply
```
