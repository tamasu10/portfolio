## cluster-postgre15.3 コンソールから転記が必要なパラメータ
- SubnetIdList
         

## デプロイ手順

 - 変更セットを作成

   ```
   ./deploy_rds_postgre.sh ./input/cluster-postgre15.3/kiralia-monitoring-develop.properties
   ```

 - 配置

   ```
   ./deploy_rds_postgre.sh ./input/cluster-postgre15.3/kiralia-monitoring-develop.properties deploy
   ```

## エクスポート値

- PostgreSQLDBEndpoint
  - ECSとRDSを接続するため、ECSの環境変数で使用

## その他

- db.t4gで作成したときのエラー、Performance Insightsは使えない
    - Resource handler returned message: "Performance Insights not supported for this configuration. (Service: Rds, Status Code: 400, Request ID: 3c618c45-0c16-4e37-b148-575153564a3b)" (RequestToken: dc814e85-a90b-ea11-2f87-6d710a56b631, HandlerErrorCode: InvalidRequest)
    - https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/USER_PerfInsights.Overview.Engines.html



