# irohaのビルド

irohaのビルド方法を以下に述べます。

## 1. ソースコードをダウンロードする

[git](https://git-scm.com/)と[git lfs](https://git-lfs.github.com/)をインストールしてから以下のコマンドを実行してください。

```
mkdir iroha
cd iroha
git clone https://github.com/capra314cabra/iroha.git .
git lfs install
git lfs pull
git submodule update --init --recursive
```

このレポジトリではgit lfsとgit submoduleを使用していることに注意してください。

## 2. Flutter SDKをインストールする

以下のリンクからインストールしてください。

https://flutter.dev/docs/get-started/install

PATHを通しておくことを忘れないように。

## 3. Firebaseのファイルを取得する

irohaでは、FirebaseのRealtime Databaseを使用しています。
まだRealtime Databaseを用意していない場合は先にそちらの準備をお願いします。
詳しい方法はネットで調べると出てくるでしょう。

以上の事が終わっている前提で話を進めます。

### 3-1. Android向けのFirebaseの設定

Android向けにirohaをビルドする際に必要な操作です。

Firebaseの管理ページから`google-service.json`をダウンロードして、irohaの`/android/app`に配置してください。

これで操作は完了です。

### 3-2. iOS向けのFirebaseの設定

iOS向けにirohaをビルドする際に必要な操作です。

まず、Firebaseの管理ページから`GoogleService-Info.plist`をダウンロードします。
続いて、irohaをXCodeのプロジェクトとして開いたのちに先程のファイルをプロジェクトに追加しましょう。

これで操作は完了です。

### 3-3. Web向けのFirebaseの設定

Web向けにirohaをビルドする際に必要な操作です。

以下の文章に従って下さい。

https://firebase.flutter.dev/docs/installation/web/

但し、上記の文章に以下の`script`タグを追加すること。

```html
<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-database.js"></script>
```

これを行うと以下のような見た目になると思います。

```html
<!-- Firebase -->
<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-database.js"></script>
<script>
    var firebaseConfig = {
        apiKey: "some",
        authDomain: "some.firebaseapp.com",
        databaseURL: "https://some.firebaseio.com",
        projectId: "some",
        storageBucket: "some.appspot.com",
        messagingSenderId: "00000000000",
        appId: "some",
        measurementId: "some"
    };

    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
</script>
```

## 4. ビルドする

後は、ビルドしたい環境に合わせて以下のリンク先を参照してください。

- [Build and release an Android app](https://flutter.dev/docs/deployment/android)
- [Build and release an iOS app](https://flutter.dev/docs/deployment/ios)
- [Build and release a web app](https://flutter.dev/docs/deployment/web)

以上でビルドは完了です。お疲れ様でした。
