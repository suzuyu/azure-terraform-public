Azure Bastion
====

Azure Bastion を構築する

常に構築した状態にすると、費用が ¥23.315 / 時間 (2022.04.03時点) で、月だと ¥17346.36 と、1万8千円くらいになるので要注意
https://azure.microsoft.com/ja-jp/pricing/details/azure-bastion/

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
