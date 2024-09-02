## ecs-infra.yaml コンソールから転記が必要なパラメータ
- ALBSubnetIdList
- VpcId

## デプロイ手順
 - 変更セットを作成

  ```
  ./deploy_ecs-infra.sh ./input/kiralia-monitoring-develop.properties
  ```

 - 配置

  ```
  ./deploy_ecs-infra.sh ./input/kiralia-monitoring-develop.properties deploy
  ```

## ECRイメージプッシュ方法
  - 前提
    - Giuhubリポジトリ上のコードをGithub Actionsでビルド、ECRへプッシュを行う。
    - Github Actions(dev用)：https://github.com/WA-KH/kiralia_monitoring_api/actions/runs/8226690692
  1. 以下リンクの「手順1.IDプロバイダを作成」を参考にGitHub Actions で OIDC を使用して AWS 認証を行えるようにする
      - https://zenn.dev/kou_pg_0131/articles/gh-actions-oidc-aws
      
  2. ecs-infra.yamlをデプロイ
  3. 作成リソースのリポジトリ名、IAMロールARNをGithub ActionsのSecretに登録する

      - リポジトリ名：ECR_REPOSITORY_NAME
      - IAMロールARN：IAM_ROLE
  4. Github Actionsを実行
  5. イメージがビルドされECRにプッシュされる