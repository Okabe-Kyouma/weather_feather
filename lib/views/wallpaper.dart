import 'package:flutter/material.dart';

class Wallpaper extends StatelessWidget {
  const Wallpaper({super.key, required this.img});

  final String img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Hero(
          tag: img,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    color: Color(0xff1C1818),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white60, width: 1),
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                            colors: [Color(0x36ffffff), Color(0x0fffffff)])),
                    child: Column(
                      children: [
                        Text(
                          'Set to Wallpaper',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        Text(
                          'Image will be saved in gallery',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
