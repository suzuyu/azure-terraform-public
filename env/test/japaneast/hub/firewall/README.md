[TEST/試験途中] Hub Azure Firewall
====

Azure Firewall を使用する場合の、Hub間ルーティング用・通信制御用の Azure Firewall 構築

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

## 通信制御

```sh
cd rules/
```
