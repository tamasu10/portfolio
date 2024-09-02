## コンソールから転記が必要なパラメータ
- DomainHostZoneId
- SubnetIdList
- AcmArn

## apigateway.yaml

- 変更セット

```
./deploy_apigateway.sh input/kiralia-monitoring-develop.properties
```

- 配置
```
./deploy_apigateway.sh input/kiralia-monitoring-develop.properties deploy
```

## カスタムドメイン申請
 - ACMからドメイン実施（DNS検証）
 - Route53でDNSレコード作成を押下するとDNSが作成される

## トークン発行方法

 - 参考

 https://qiita.com/horit/items/1c3c52115a69cd6c6d4d

 - 手順
1. コンソールからユーザ作成
   - コンソールへアクセス
   - Cognitoを開く
   - ユーザープールを開く
   - ユーザを作成
   - サインインに使用されるエイリアス属性にEメールをチェック
   - ユーザ名を入力
   - Eメールアドレスを入力
   - Eメールを検証済みとしてマークにチェック
   - 仮パスワードの生成にチェック
   - ユーザを作成をクリック

2. パスワードが記載のメール受信
   - 1で設定したメールアドレスからパスワードを確認

3. PW変更

   1. 初回ログイン時はパスワードの変更が必要。以下コマンドを実行するとsessionの値が出力されるため、コピーして以下の"session"部分に貼り付け

    ```
    aws cognito-idp admin-initiate-auth --user-pool-id ap-northeast-1_Xg8gSZPAv --client-id 5e6f4qouaa39j9m5b8gajdf3mi --auth-flow  ADMIN_USER_PASSWORD_AUTH --auth-parameters "USERNAME=XXXXX,PASSWORD=XXXXX"
    ```

    -  --user-pool-idはユーザープールIDを指定。
    -  --client-idはアプリクライアントIDを指定。
    -  --auth-parametersはcognitoで作成したユーザーの名前とパスワードを指定。

    2.  以下コマンドを実行するとAPIG認証に用いるトークン（IDtoken）が出力される
    ```
    aws cognito-idp admin-respond-to-auth-challenge --user-pool-id ap-northeast-1_Xg8gSZPAv --client-id 5e6f4qouaa39j9m5b8gajdf3mi --challenge-name NEW_PASSWORD_REQUIRED --challenge-responses NEW_PASSWORD='XXXXX',USERNAME=XXXXX --session "session"
    ```

    - --NEW_PASSWORDは新しいパスワードを入力


4. APIGatewayへリクエスト
    - 上記で取得したトークンを以下に貼り付けてコマンド実行

    ```
    curl -H 'Authorization: {トークン}' https://apis.kiralia-monitoring-dev.com/actuator
    ```

    - 成功結果
    ```
    {"_links":{"self":{"href":"http://apis.kiralia-monitoring-dev.com/actuator","templated":false},"health":{"href":"http://apis.kiralia-monitoring-dev.com/actuator/health","templated":false},"health-path":{"href":"http://apis.kiralia-monitoring-dev.com/actuator/health/{*path}","templated":true}}}%  
    ```

    - 失敗結果
    ```
    {"message":"Unauthorized"}
    ```

    - 2回目以降のログインは以下のコマンドを使用

    ```
    aws cognito-idp admin-initiate-auth --user-pool-id ap-northeast-1_Xg8gSZPAv --client-id 5e6f4qouaa39j9m5b8gajdf3mi --auth-flow  ADMIN_USER_PASSWORD_AUTH --auth-parameters "USERNAME=XXXXX,PASSWORD=XXXXX"
    ```
