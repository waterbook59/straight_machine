import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:soundpool/soundpool.dart';

class HomeScreen extends StatefulWidget {
  //Laravelで言う所のview
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Laravelで言う所のcontroller
  //buildメソッドが入っている方に書いていく

  List<String> _texts = [
    "おめでとう",
    "合格です",
    "よくできました",
    "残念でした",
    "不合格です",
    "頑張りましょう",
  ];

  List<int> _soundIds = [0, 0, 0, 0, 0, 0];
  Soundpool _soundpool; //このクラスの外からはアクセスできない(private)、プロパティのみクラス内に設定

  @override
  void initState() {
    //widget生成直後に１回だけ通るメソッド,initStateの中でasync,awaitを行いたいがinitStateで非同期はエラー出る
    _initSounds(); //メモリにsoundIdを持ってくるメソッドとして定義
    print("initState終わり＝buildメソッド回った");

    super.initState();
  }

  Future<void> _initSounds() async {
    try {
      _soundpool = Soundpool(); //soundpoolを初期化

      _soundIds[0] = await loadSound("assets/sounds/sound1.mp3");
      _soundIds[1] = await loadSound("assets/sounds/sound2.mp3");
      _soundIds[2] = await loadSound("assets/sounds/sound3.mp3");
      _soundIds[3] = await loadSound("assets/sounds/sound4.mp3");
      _soundIds[4] = await loadSound("assets/sounds/sound5.mp3");
      _soundIds[5] = await loadSound("assets/sounds/sound6.mp3");

      print("initSounds終わり＝効果音ロードできた");
      setState(() {
        //効果音がロードできた状態でもう一度buildメソッドを呼び出す
      });
    } on IOException catch (error) {
      //IOExceptionはinput/output exceptionの
      print("エラーの内容は: $error");
    }

//    _soundIds[0] = await rootBundle  //soundIdをメモリに格納
//        .load("assets/sounds/sound1.mp3")//rootBundle.loadメソッドがメモリにデータをもってきた
//        .then((value) => _soundpool.load(value));//loadで持ってきたデータ(value)に対して上で初期化したsoundpoolを実行
  }

  Future<int> loadSound(String soundPath) {
    //rootBundle.loadはデータをメモリへ取り込んでいる、soudpool.loadはメモリ上のデータを再構築している（デコード）
    return rootBundle.load(soundPath).then((value) => _soundpool.load(value));
  }

  @override
  void dispose() {
    _soundpool.release(); //dispose実行するのはrelease
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ツッコミマシーン"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //１行目
                children: <Widget>[
                  Expanded(
                      flex: 1, child: _soundButton(_texts[0], _soundIds[0])),
                  //ボタン メソッドを格納させたい変数名を作りoption+enterからcreate methodを選択すると下に自動で出てくる
                  Expanded(
                      flex: 1, child: _soundButton(_texts[1], _soundIds[1])),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //２行目
                children: <Widget>[
                  Expanded(
                      flex: 1, child: _soundButton(_texts[2], _soundIds[2])),
                  Expanded(
                      flex: 1, child: _soundButton(_texts[3], _soundIds[3])),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //３行目
                children: <Widget>[
                  Expanded(
                      flex: 1, child: _soundButton(_texts[4], _soundIds[4])),
                  Expanded(
                      flex: 1, child: _soundButton(_texts[5], _soundIds[5])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //メソッド名の前に型指定 RaisedButtonでも良いがRaisedButtonがWidgetを繼承されたものなのでWidgetで良い
  Widget _soundButton(String displayText, int soundId) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: RaisedButton(
          color: Colors.cyan,
          onPressed: () => _playSound(soundId), //戻り値なし
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Text(
            displayText,
            style: TextStyle(color: Colors.black87),
          ),
        ));
  }

  void _playSound(int soundId) async {
    await _soundpool.play(soundId); //playメソッドは音を鳴らした後コントロールする場合async,awaitをつける
  }
}
