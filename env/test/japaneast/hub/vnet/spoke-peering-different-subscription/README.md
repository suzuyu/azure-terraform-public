VNET Peering (異なる Tenant / Subscription 間)
====

## README
`../../../../../../modules/hub/vnet/spoke-peering-different-subscription/README.md`

## パラメータ穴埋め

```sh
cp terraform.tfvars.sample terraform.tfvars
vi terraform.tfvars
cp spoke_peering.tf.sample spoke_peering.tf
vi spoke_peering.tf
```

## 実行手順

```sh
terraform init
terraform plan
terraform apply
```
