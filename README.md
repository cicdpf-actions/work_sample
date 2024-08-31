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

# 作業メモ

<details>
<summary>AIメモ</summary>

````yaml
 
`if: ${{ needs.deploy.result == 'failure' }}` と `if: ${{ failure() }}` の違いについて説明します。

### 1. `if: ${{ needs.deploy.result == 'failure' }}`
- **条件:** `deploy`ジョブの結果が "failure" であるかどうかをチェックします。
- **動作:** これは、`deploy`ジョブ全体の最終的な結果（成功か失敗か）を元に判断します。`deploy`ジョブが失敗した場合のみ、その後のジョブが実行されます。
- **注意点:** 手動承認で拒否された場合、GitHub Actionsは `deploy` ジョブを「失敗」とは見なさないため、この条件では拒否がトリガーされないことがあります。したがって、承認が拒否された場合には、この条件分岐では次のジョブが実行されません。

### 2. `if: ${{ failure() }}`
- **条件:** 前のジョブが「失敗した」かどうかを確認します。
- **動作:** `failure()` は、前のステップまたはジョブが失敗した場合に真になります。手動承認が拒否された場合も「失敗」として扱われるため、この条件で次のジョブが実行されます。
- **柔軟性:** この方法は、手動承認の結果が「拒否」であっても、次のジョブをトリガーするためのより確実な方法です。

**まとめ:** 手動承認で「拒否」された場合でも次のジョブを確実に実行したいのであれば、`if: ${{ failure() }}` を使用する方が確実です。`deploy.result` に頼ると、手動承認の結果が「失敗」として処理されないことがあるため、期待通りに動作しないことがあります。
````
</details>
