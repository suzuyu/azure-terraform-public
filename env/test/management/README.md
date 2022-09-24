組織管理
===

## 管理グループ作成

下記で管理グループを作成する (手動)

- [カスタムドメイン参加](https://learn.microsoft.com/ja-jp/azure/active-directory/fundamentals/add-custom-domain)
- [管理グループ初期セットアップ](https://learn.microsoft.com/ja-jp/azure/governance/management-groups/overview#initial-setup-of-management-groups)

`Tenant Root Group` へ `ユーザー アクセス管理者` `管理グループ共同作成者` ロールを付与する

```sh
SCOPE=/providers/Microsoft.Management/managementGroups/$ARM_TENANT_ID
az role assignment create --assignee "$(az ad sp list --display-name "terraform" --query '[0].appId' --output tsv)" --scope $SCOPE --role 18d7d88d-d35e-4fb5-a5c3-7773c20a72d9
az role assignment create --assignee "$(az ad sp list --display-name "terraform" --query '[0].appId' --output tsv)" --scope $SCOPE --role 5d58bcaf-24a5-4b20-bdb6-eed9f69fbe4c
```

## Azure Policy 
下記設定を実施している (terraform)

設定する管理グループは `poicy.tf` の `management_group_id` へ設定する

| 内容 | 設定 | 設定 module パス |
|:-:|:-:|:-:|
| ロケーション | 日本リージョンのみ許可 (`policy.tf` の `listOfAllowedLocations` でパラメータ設定) | ~/modules/azure-policy/allow_locations/ |
| Public IP 制限 | VM NIC 用の Public IP 付与を禁止 | ~/modules/azure-policy/deny_nic_public_ip/ |
