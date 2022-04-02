Hub Resources
====

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

## 各コンポーネントを実施

`./vnet` へ移動して `./vnet/README.md` を参照

## リージョン間ルータ

[スポーク間の接続が必要な場合は、Azure Firewall またはその他のネットワーク仮想アプライアンスをデプロイすること](https://docs.microsoft.com/ja-jp/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli#spoke-connectivity)

`./firewall` もしkは `./virtual-machines` でルーティングできるリソースを作成する
