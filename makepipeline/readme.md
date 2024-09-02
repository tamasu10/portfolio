# はじめに
* リポジトリの用途
  * AAPのAWSインフラ環境を新規作成する際に使用する、terraformコードのテンプレートを格納したリポジトリである。（パイプライン作成用リポジトリとその他のAWSリソースを作成するリポジトリに分けている）
* テンプレートの作成意図
  * 新しくAWSインフラ環境を作成する際に、0からterraformのコードを記述するのは時間がかかるので、本テンプレートを利用して時間短縮するため
* テンプレートを使用してできること
    * CI/CDパイプライン（codepipeline）をローカル環境からterraformコマンドを実行して作成した後、パイプライン内のcodebuild環境でその他のAWSリソースを作成できる
* パイプラインからAWSリソースを作成するメリット
  * リポジトリにコードをプッシュするだけで自動的にterraformコマンドを実行し、AWSリソースの作成を行える
  * 強い権限を持ったAWSのアクセスキーを開発担当者に払い出さなくても、gitの権限があればAWSのリソースを作成できるようになる
  * AWSリソースの作成前に、管理者の承認を設定できる
  * AWSリソースの作成状況がリポジトリ内のコードの差分で可視化できる
* ヒント
  * 初期構築時にパイプラインを使用して開発すると、コンソールからエラーを確認しなければならない。また、管理者の承認のフローも挟むため時間がかかってしまう。なのでパイプラインの作成、使用はterraformのコードが固まった後に行うのがよい。
					
# テンプレートの設計方針
 * 変数管理(variables)、機能構成ファイル、モジュールの三つで構成
   * variables
     * variables.tfには機能構成ファイルを横断して使用する変数のみ格納（システム名、アカウント名等）
   * 機能構成ファイル
      * 機能ごとに機能構成ファイルを作る
      * 例:ec2に関するリソースを作る場合はec2.tfを作成
      * 機能構成ファイルでは必要な情報を直接記入、もしくは、variables.tfより取得し、AWSリソースの作成に必要なモジュールを呼び出す
    * モジュール
      * AWSリソース作成に必要な処理がまとめられている
      * 可能なかぎりTerraform Registryに存在する公式モジュール（https://registry.terraform.io/namespaces/terraform-aws-modules）を使用する
      * Terraform Registryにあるが、必要な変数が設定されていないモジュール、terraoform Registryにないモジュールについては個別に実装している
# 開発前提条件
  * 各種バージョン
 
  | Name|Version|
| :------------------: | :----------------------------: |
|Terraform	|1.1.4|
|hashicorp/aws	|3.44.0|

  * テンプレート利用時の事前準備
    * Terraformインストール(Windows)
       1. Terraformサイトより対象バージョン(本PJでは1.1.4)のTerraformをダウンロード
       2. ダウンロードしたZipファイルを解凍
       3. 解凍した terraform.exe を任意のフォルダに配置してPATHを通す。あるいはPATHの通った場所に配置。(例：D:\Users\UserName\AppData\Local\Microsoft\WindowsApp)
       4.  コマンドプロンプトなどでTerraformのバージョンが表示されるのを確認
  
				$ terraform version
				Terraform v1.1.4
				on windows_amd64

  * Gitのインストール
     1. gitがインストールされていることを確認するため、コマンドプロンプトで"git"を実行し、コマンドが通ることを確認
     2.  コマンドが通らない場合はジョブカンから申請を行う
  * リポジトリダウンロード
    1. 共通dev環境AWSコンソールにおいて、自身のIAMユーザーの認証情報タブ内「AWS CodeCommit の HTTPS Git 認証情報」からcsvファイルをダウンロード。
    2. 任意のディレクトリでコマンドプロンプトで以下のコマンドを実行（コマンド実行後に1でダウンロードしたcsvファイル内のIDとPWの入力が求められる）
       * 共通dev環境のcodepipeline、codecommit、codebuildの作成に用いたリポジトリ
  
			 $ git clone https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/codecommit-aap-template-account-dev-makepipeline

       * 上記で作成したcodecommitのリポジトリ
 
             $ git clone https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/codecommit-aap-template-account-dev-codepipeline


    1. カレントディレクトリにリポジトリがダウンロードされていることを確認

  * プロファイルの設定
    * terraform apply実行時にリソースが作成される環境を指定するために用いる
    * AWS profile作成手順
      1. コマンドプロンプト上で aws と入力し、コマンドが通ることを確認
      2. コマンドが通らない場合、ジョブカンからインストール申請を実施
      3. ダウンロードしたリポジトリにあるprovider.tf内のprofileに任意の値を設定
      4. リソース作成先のAWSアカウント内にIAMユーザを作成し、クレデンシャル情報が含まれたcsvファイルをダウンロード
      5. コマンドプロンプト上で以下のコマンドを実行

			 % aws configure --profile 2で設定した値
			   アクセスキー、シークレットキーの入力が求められるので3でダウンロードしたcsv内の情報を入力


# テンプレート使用方法
  * AWSリソースの作成方法（パイプライン以外）
    1. リポジトリ：codecommit-aap-template-account-dev-codepipeline内のテンプレートをコピーし、編集
    2. variables.tfの”profile”をリリース先のアカウントのものに変更
    3. variables.tfのリソース名に関係する変数（system、account等）を変更
    4. backend.tfの変数:bucketに、事前にコンソールから作成したtfstete格納用バケット名を入力
    5. 既存リソースを変更
    6. 新規リソースを追加
 
  * 新規プロジェクトで使用するパイプライン作成方法
    1. リポジトリ：codecommit-{system}-{account}-{env}-makepipeline をcodecommit内に作成
    2. ローカルにリポジトリをクローンする
    3. リポジトリ：codecommit-aap-template-account-dev-makepipeline内のファイルをコピーし、1で作成したリポジトリに格納後、編集
    4. variables.tf内の変数:profileをリリース先のアカウントのものに変更
    5. variables.tfのリソース名に関係する変数（system、account等）を変更
    6. sns.tf内のメールアドレスを管理者のものに変更
    7. backend.tfの変数:bucketに、事前にコンソールから作成したtfstete格納用バケット名を入力、
    8. ローカル環境からリモートリポジトリにコミットを行う（直接パイプライン作成作業に影響しないが、最新のコードをバックアップするために実施）
    9.  ローカル環境からterraform init、plan、applyを実施し、パイプラインを作成
  * パイプラインの使用方法
    1. パイプライン作成時に作成されたリポジトリ：codecommit-{system}-{account}-{env}-codepipelineをローカルにクローンする
    2. ローカルリポジトリ内に、「AWSリソースの作成方法」で作成したファイルを格納
    3. ローカル環境からリモートリポジトリにコミットを行う
    4. コミットをトリガーにパイプラインが起動するため、コンソールを確認してエラー対応を行う
    5. terraform planが通れば管理者にメールが届くため、承認してもらう
    6. 承認後は自動でterraform applyが実行される
# 構成図
  * 作成中(pptxのリンク作成）
# 今後の改善点
  * ec2
    * 現在、キーペアはterraform実行前に作成する必要があるため、terraformで完結できるようにする
  * routetable
    * cidrを直接入力しているため、関連付けているサブネットから取得できるように変更 →対応中
# 命名規則
  * 基本的には以下の命名規則を使用
    * [サービス名]-[システム名]-[アカウント名]-[環境名]-[リソースの用途][番号]
  * 例：iamロール
    * "role-aap-template-account-dev-codepipeline01"
  * 詳細は命名規則資料参照（リンク作成）
# 運用時の参考資料
  * 運用設計.pptx(リンク作成)