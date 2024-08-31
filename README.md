# 検証
### outputsについて
````yaml
jobs:
  print-vars:
    runs-on: ubuntu-latest
    outputs:
        test: ${{ steps.set-output-step.outputs.result }} #steps.OUTPUTを設定したstepのid名.outputs.変数名
    steps:
      - name: Set Output
        id: set-output-step  # idを指定
        run: |
          echo "result=TEST" >> $GITHUB_OUTPUT
          echo "GITHUB_OUTPUT: $GITHUB_OUTPUT" 

        #出力結果　GITHUB_OUTPUT: /home/runner/work/_temp/_runner_file_commands/set_output_e0772e5a-3e74-458a-915b-93e8ceb1e77a  

        #表示されたファイルパスは、GitHub Actionsが内部で使用する一時ファイルのパスであり、出力変数を設定するためのものでした。このファイルを通じて、resultという名前の出力変数がTESTという値に設定されます。
````
````yaml
  hello:
      - name: Use Output from Previous Job
        run: |
          echo " Output from print-vars job: ${{ needs.print-vars.outputs.test }} "
        #need.output設定元のジョブ名.outputs.変数名
````

### 手動承認について
以下の記事を参考にEnvironmentにPRODを作成し、Required reviewersに承認者を設定する
https://zenn.dev/ore88ore/articles/github-actions-approval-flow  

手動承認したいジョブのenvironmentにgithub上で設定した環境名を記載する
````yaml
  hello:
    needs: print-vars
    runs-on: ubuntu-latest
    environment:  PROD
````

### 条件分岐について



- ansibleコンテナを入れたい
- steps:usesについて

# 参考資料
https://zenn.dev/hsaki/articles/github-actions-component
