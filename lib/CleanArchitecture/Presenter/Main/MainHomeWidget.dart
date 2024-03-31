import 'package:flutter/material.dart';

class MainHomeWidget extends StatelessWidget {
  final List<Widget> widgets;

  const MainHomeWidget({Key? key, required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: GestureDetector(
            onTap: () {
              // _showDatePicker();
            },
            child: const Text(
              // DateFormat('yyyy-MM').format(selectDateViewModel.focusedDay),
              "2024-12월",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                height: 0,
              ),
            )),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
      ),
    );
  }
}
