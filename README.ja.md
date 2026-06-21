# addkey

> APIキーを **チャットに一切貼らずに** AIコーディングアシスタントへ安全に渡す。

[English](./README.md) | **日本語**

![addkey デモ](./docs/demo.gif)

`addkey` は入力非表示のダイアログを出し、入力したシークレットをそのまま `.env`
（およびコミット可能な暗号化版 `.env.enc`）に書き込みます。値は標準出力・シェル履歴・
AIアシスタントの会話ログのどこにも残りません。

```console
$ addkey OPENAI_API_KEY
# GUIダイアログが出る → そこにキーを入力 → 値は一切エコーされない
/path/to/project/.env: 'OPENAI_API_KEY' added (.enc synced) (value hidden).
```

## なぜ必要か

AIエージェントとのバイブコーディングでは、つい本物のAPIキーをチャットに貼って
しまいがちです。一度会話に入るとログ・保存・同期される可能性があります。
`addkey` はその誘惑そのものを取り除きます。シークレットはネイティブのダイアログで
入力され、コードが読むファイルにだけ書き込まれます。

[SOPS](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age)
と組み合わせることで「**git上は暗号化・ディスク上は平文**」モデルを実現します。
アプリやエージェントは通常の `.env` をそのまま読み続け、リポジトリにコミットする
正本は暗号化された `.env.enc` になります。

## インストール

`bash` / [`sops`](https://github.com/getsops/sops) /
[`age`](https://github.com/FiloSottile/age) が必要です。

```bash
# macOS
brew install sops age

git clone https://github.com/GYact/addkey.git
cd addkey
./install.sh          # コマンドを ~/.local/bin にシンボリックリンク
addkey init           # age鍵と公開鍵(recipient)を生成(初回のみ)
```

`addkey init` は age 秘密鍵を `~/.config/sops/age/keys.txt` に作成し（無ければ）、
あなたの公開鍵を記録します。**自分の鍵で暗号化し、自分で復号できる** ので、
他人の鍵で暗号化されることはありません。

## コマンド一覧

| コマンド | 動作 |
| --- | --- |
| `addkey NAME` | シークレットを入力 → `./.env` に保存 → `./.env.enc` を同期。 |
| `addkey -k NAME` | ファイルではなく macOS キーチェーンに保存。 |
| `addkey -f FILE NAME` | 対象の dotenv ファイルを指定（既定は `.env`）。 |
| `addkey init` | 初回設定：age鍵と公開鍵の作成/検出。 |
| `sopsify [FILE]` | 既存の平文 `.env` を暗号化モデルへ移行。 |
| `senv-push [FILE]` | 平文編集後に `.env` → `.env.enc` を再暗号化。 |
| `senv-pull [FILE]` | `.env.enc` → `.env` を復号（新マシン/復旧）。 |
| `senv-edit FILE.enc` | 暗号化ファイルを `$EDITOR` で編集し保存時に再暗号化。 |
| `senv-cat FILE.enc` | 復号して標準出力に表示（確認用のみ）。 |

## 公開鍵(recipient)の解決順

公開鍵はハードコードしません。暗号化のたびに次の順で解決します。

1. 環境変数 `$SOPS_AGE_RECIPIENT`
2. `~/.config/senv/recipient` ファイル（`addkey init` が作成）
3. 秘密鍵 `$SOPS_AGE_KEY_FILE` から `age-keygen -y` で導出

## セキュリティ上の注意

- シークレットの **値** は決して表示されません。表示されるのはキー **名** とパスのみ。
- `.env` や平文 dotenv は git 管理から除外。コミットするのは `*.enc` だけです。
- age **秘密鍵**（`~/.config/sops/age/keys.txt`）は絶対にコミット・共有しないこと。
  パスワード同様に厳重にバックアップしてください。
- `senv-cat` は仕様上、復号した値を表示します。出力が記録される場所で実行しないこと。
- `sopsify` はコミット済み平文の追跡を解除しますが、git 履歴は書き換えられません。
  既に push 済みのシークレットは **必ずローテーション** してください。

## ライセンス

[Apache-2.0](./LICENSE)
