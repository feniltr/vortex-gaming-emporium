import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class IntroPageView extends StatefulWidget {
  @override
  _IntroPageViewState createState() => _IntroPageViewState();
}

class _IntroPageViewState extends State<IntroPageView> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                Page(content: 'Page 1 Content'),
                Page(content: 'Page 2 Content'),
                Page(content: 'Page 3 Content'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentPage == 2 ? 'Finish' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String content;

  Page({required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        content,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intro PageView Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: IntroPageView(),
    );
  }
}
