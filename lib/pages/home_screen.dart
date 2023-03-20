import 'package:flutter/material.dart';

import 'web_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonWebView(
      url: 'https://tangerine-tarsier-1c85d6.netlify.app',
      title: '',
    );
  }
}