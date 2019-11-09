// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

/* 画面構築
 */
class MyApp extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : 'Startup Name Generator', // ここのタイトルは画面名？
      theme: ThemeData (                // テーマ
        primaryColor: Colors.indigo,    // ここのカラーをイジって変更
      ),
      home  : RandomWords(),            // 内容
    );
  }
}

/* 継承元
 */
class RandomWords extends StatefulWidget 
{
  @override
  RandomWordsState createState() => RandomWordsState();
}

/* RandomWordsの中身
 */
class RandomWordsState extends State<RandomWords> 
{
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair>  _saved       = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18); 
  var _checkBox1 = false;
  //var _checkBox2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      // 画面タイトル
      appBar: AppBar (
        title   : Text('Startup Name'), // ナビゲーションタイトル
        actions : <Widget>[             // ナビゲーションボタン
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      // 表示領域
      body: _buildSuggestions(),
    );
  }

  // ListViewを作成
  Widget _buildSuggestions() {
    // ListView.builderでリストビューを作成
    return ListView.builder(
      // 間隔調整 他コントロールとの間隔
      padding     : const EdgeInsets.all(1),

      // BuildContextは配列 intのi分の配列作成
      itemBuilder : (BuildContext _context, int i) {
        
        // 奇数列に区切り線を代入　isOddで奇数判定 Dividerで区切り線作成
        if (i.isOdd) {
          return Divider();
        }

        // 区切り線も1行の判定になるので　それを調整するためのindexを作成
        // i = 1,2,3,4,5,6  index = 0,1,1,2,2,3
        final int index = i ~/ 2;
        if (index >= _suggestions.length) {
          // 10個ずつ足りなくなったら配列を生成
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  // ListViewの中身を作成
  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    // ListTile = 固定高さの行のこと　CheckBoxListTile SwitchListTileなどがあるらしい
    return ListTile (
      // 左側にコントロールを追加
      leading: Checkbox (
              value: _checkBox1,
              onChanged: (bool value) {
                setState(() {
                  _checkBox1 = value;
                });
              },
            ),
      
      // 中央にコントロールを追加　（タイトル等）
      title: Text (
        pair.asPascalCase,
        style: _biggerFont,
      ),

      // タイトル下のサブタイトル
      subtitle: Text(pair.asCamelCase),
      
      // 右側にコントロールを追加
      trailing: Icon (
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),

      // タップ処理
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else { 
            _saved.add(pair); 
          } 
        });
      },
    );
  }

  // ナビゲーションボタンタップ処理
  void _pushSaved() {
    Navigator.of(context).push (  // 繊維方法の選択 : pushとかpopとか？

      // 遷移後のページを生成
      MaterialPageRoute<void> (
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map (
            (WordPair pair) {
              return ListTile (
                title: Text (
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
            .divideTiles(
              context: context,
              tiles  : tiles,
            )
            .toList();

          return Scaffold (
            appBar: AppBar (
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

}

