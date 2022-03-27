Test 環境用 (HomeLab)
===

## ストレージアカウントの置換

```sh
find ./ -name 'main.tf' -exec sed -i 's/tfstateXXXXX/tfstateYYYYY/g' {} \;
```

## パラメータ設定

各ディレクトリ・コンポーネントの README 参照して実施

依存関係は、基本的にはディレクトリ上部へ依存 (最上位がリソースグループ)

