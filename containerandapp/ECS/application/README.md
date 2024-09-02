## コンソールから転記が必要なパラメータ
- ECSSubnetIdList
- ECSImageName
- VpcId

## デプロイ手順
- 変更セット

```
- ./ecs-cluster.sh input/kiralia-monitoring-develop.properties
```

- 配置

```
- ./ecs-cluster.sh input/kiralia-monitoring-develop.properties deploy
```