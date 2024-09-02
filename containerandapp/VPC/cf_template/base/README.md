# VPC リソース

USAGE@東京リージョン

## vpc-subnet-resources.yaml

- デプロイの流れ
    - 初回デプロイ（スタック作成)
    - VPC-Peering to Everforth-DEVOPS
    - Peering情報をパラメータに追加してスタックを更新

## デプロイ手順
- 変更セット

```
./deploy_vpc-subnet-resources.sh input/kiralia-monitoring-develop.properties
```

- 配置
    ```
    ./deploy_vpc-subnet-resources.sh input/kiralia-monitoring-develop.properties deploy
    ```

## security-group-resources.yaml
- 前提
    - BastionサーバのSGがデプロイ済みであること
    - EverforthーDEVOPSとのVPC-Peeringを確立済みであること

## デプロイ手順
- 変更セット

```
./deploy_security-group-resources.sh input/kiralia-monitoring-develop.properties
```
- 配置

```
./deploy_security-group-resources.sh input/kiralia-monitoring-develop.properties deploy
```


# DNS設定
## プライベート・ホストゾーンのクロスアカウント参照
${サービス名}-${環境名}.private　をプライベート・ホストゾーンで作成し、必要なVPCへアソシエーションする。
＃例：hakobiba-develop.private

- 提供側（DEVOPSアカウントからの接続先）のプライベート・ホストゾーンからアソシエーションのリクエストを作成。

```
aws route53 create-vpc-association-authorization --hosted-zone-id ${ゾーンのID}  --vpc VPCRegion=ap-northeast-1,VPCId=${アソシエーション先のVPCのID}
```


- 受け入れ側でのリクエストの承認（DEVOPSアカウント）

```
aws route53 associate-vpc-with-hosted-zone --hosted-zone-id ${ゾーンのID}  --vpc VPCRegion=ap-northeast-1,VPCId=${アソシエーション先のVPCのID}
```

※相互にゾーンを参照したい場合、お互いのアカウント、VPCで上記の設定を行う。
