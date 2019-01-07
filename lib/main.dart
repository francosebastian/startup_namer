/*
  This example creates a Material app.
  Material is a visual design language that is standard on mobile and the web.
  Flutter offers a rich set of Material widgets.
 */
import 'package:flutter/material.dart';

//Import for random english word library
import 'package:english_words/english_words.dart';

/*
  The main() method uses arrow (=>) notation.
  Use arrow notation for one-line functions or methods.
*/
void main() => runApp(MyApp());

/*
  The app extends StatelessWidget which makes the app itself a widget. 
  In Flutter, almost everything is a widget, including alignment, padding, 
  and layout.
 */
class MyApp extends StatelessWidget {
  /*
  A widget’s main job is to provide a build() method that describes how to
  display the widget in terms of other, lower level widgets.
   */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: new ThemeData(
          primaryColor: Colors.green,
        ),
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  /*Note: Prefixing an identifier with an underscore enforces privacy
   in the Dart language. */
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>(); // Add this line.
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    /*The Scaffold widget, from the Material library,
       provides a default app bar, title,
       and a body property that holds the widget tree for the home screen.
       The widget subtree can be quite complex. */
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          // Add 3 lines from here...
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair); // Add this
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        // Add the lines from here...
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        // Add 9 lines from here...
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

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            // Add 6 lines from here...
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          ); // ... to here.
        },
      ),
    );
  }
}
