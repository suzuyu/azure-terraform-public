## 内容
マルチテナントでの Subscription 間 VNET Peering を Terraform で実施する

![Azure_Different-Tenant-VNetPeering](images/Azure_Different-Tenant-VNetPeering.png)

この module を使用する前に、必要に応じて 1. ~ 4. を実施する

1. User Access Administrator 権限設定
1. Terraform で使用するサービスプリンシパルのマルチテナント化
1. spoke での Terraform サービスプリンシパルのアクセス許可
1. spoke でのサービスプリンシパルへの IAM での権限追加
1. Terraform でのマルチテナント操作での VNet Peering

下記は全体の概要図と実施例での名称例

![Azure_VNet-Peering_20220417.png](images/Azure_VNet-Peering_20220417.png)


### 1. User Access Administrator 権限設定

ロールの割り当ての追加をするには、`Microsoft.Authorization/roleAssignments/write`が必要で、
組み込みロールで言うと `Owner` もしくは `User Access Administrator` (`ユーザー アクセス管理者`) のロールを持っている必要がある
([Azure ドキュメントの Terraform サービス プリンシパルの作成](https://docs.microsoft.com/ja-jp/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal)で例に記載されている`Contributor`/`共同作成者`では無理なので注意)

`User Access Administrator` (`ユーザー アクセス管理者`) のロールを割り当てる

サブスクリプションやリソースグループの`アクセス制御(IAM)`で設定する

![2022-04-17 20.49.39.png](images/2022-04-17%2020.49.39.png)

`ユーザー アクセス管理者`をクリックして`次へ`

![2022-04-17 20.53.03.png](images/2022-04-17%2020.53.03.png)

`+メンバーを選択する`で選択するユーザをクリックして、`選択`してクリック
(ここではユーザにしているが、サービスプリンシパルで実施している場合は、サービスプリンシパルを選択)

![2022-04-17 20.55.19.png](images/2022-04-17%2020.55.19.png)

`レビューと割り当て`を実施して割り当てる

![2022-04-17 20.56.46.png](images/2022-04-17%2020.56.46.png)


### 2. Terraform サービスプリンシパルのマルチテナント化

`サポートされているアカウントの種類:` が`所属する組織のみ`になっている場合は、マルチテナント対応をする必要がある
`所属する組織のみ`をクリックする

![スクリーンショット 2022-04-17 19.37.57.png](images/2022-04-17%2019.37.57.png)


下記を選択して、変更する
`任意の組織ディレクトリ内のアカウント (任意の Azure AD ディレクトリ - マルチテナント)`
![スクリーンショット 2022-04-17 19.44.57.png](images/2022-04-17%2019.44.57.png)

`サポートされているアカウントの種類:` が `複数の組織`となっていることを確認

![スクリーンショット 2022-04-17 19.49.08.png](images/2022-04-17%2019.49.08.png)

`API のアクセス許可` で `Microsoft Graph` の `User.Read` 権限を追加 (最初からマルチテナントでサービスプリンシパル作成しているとデフォルトで設定済)

![スクリーンショット 2022-04-17 20.02.54.png](images/2022-04-17%2020.02.54.png)

![スクリーンショット 2022-04-17 20.05.02.png](images/2022-04-17%2020.05.02.png)

![スクリーンショット 2022-04-17 20.14.51.png](images/2022-04-17%2020.14.51.png)



### 3. spoke への Hub Terraform サービスプリンシパルのアクセス許可

マルチテナント化した Hub 側のサービスプリンシパルのアプリケーション ID (Application(client) ID) を参照する

![スクリーンショット 2022-04-17 19.54.39.png](images/2022-04-17%2019.54.39.png)

spoke の`ディレクトリ(テナント)ID`(`Service Tenant ID`) を取得する

![スクリーンショット 2022-04-17 19.57.52.png](images/2022-04-17%2019.57.52.png)
 

```
https://login.microsoftonline.com/<Service Tenant ID>/oauth2/authorize?client_id=<Application (client) ID>&response_type=code&redirect_uri=https%3A%2F%2Fwww.microsoft.com%2F
```

ブラウザでアクセスして`承認`する

![スクリーンショット 2022-04-17 20.16.08.png](images/2022-04-17%2020.16.08.png)

`サインイン`で`エラー`となるが気にせずこのタブは閉じて良い

![スクリーンショット 2022-04-17 20.18.44.png](images/2022-04-17%2020.18.44.png)

spoke 側の `エンタープライズ アプリケーション`に追加した`アプリケーション ID` でサービスプリンシパルが追加されていることが確認できる

![スクリーンショット 2022-04-17 20.20.08.png](images/2022-04-17%2020.20.08.png)


### 4. spoke でのサービスプリンシパルへの IAM での権限追加

ひとつ前で追加した、Hubのアプリケーションのサービスプリンシパルへ spoke の VNET の`ネットワーク共同作成者`権限を付与する

#### GUI (Azure Portal) で実施する場合

spoke の VNET から`アクセス制御 (IAM)`へ移動して`ロールの割り当ての追加`を実施する

![スクリーンショット 2022-04-16 13.07.27.png](images/2022-04-16%2013.07.27.png)

`ネットワーク共同作成者`を選択する

![スクリーンショット 2022-04-17 21.45.57.png](images/2022-04-17%2021.45.57.png)


`+メンバーを選択する`をクリックして、追加したサービスプリンシパルをクリックして、`選択`をクリックして、
最後に`次へ`をクリック

![スクリーンショット 2022-04-17 21.47.43.png](images/2022-04-17%2021.47.43.png)


`レビューと割り当て`をクリックして割り当てる

![スクリーンショット 2022-04-17 21.48.48.png](images/2022-04-17%2021.48.48.png)



#### CLI (az-cli) で実施する場合

Spoke VNET の`プロパティ`で`リソース ID` を取得する

![スクリーンショット 2022-04-17 21.33.18.png](images/2022-04-17%2021.33.18.png)


下記コマンドを`ユーザー アクセス管理者`ロールを持つユーザでログインした状態で実施

```sh
az role assignment create --role "Network Contributor" --assignee-object-id <サービスプリンシパルのオブジェクトID> --scope <Spoke VNET リソース ID> --assignee-principal-type ServicePrincipal
```

下記実行出力例

![スクリーンショット 2022-04-17 21.59.13.png](images/2022-04-17%2021.59.13.png)

### 5. Terraform での VNet Peering 作成

Terraform で VNet Peering を作成する

1. ~ 4. 実施後に本 module を利用して作成する

サービスプリンシパルの ID/Password は環境変数に設定してから実施する


```sh
export ARM_CLIENT_ID=81XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX9
export ARM_CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

コードで指定も可能だが (./mai.tf にコメントアウト)、パスワード情報のコードかは非推奨
