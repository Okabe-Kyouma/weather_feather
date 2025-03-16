import 'package:flutter/material.dart';

class SetAsW extends StatelessWidget {
  final VoidCallback onHomeScreen;
  final VoidCallback onLockScreen;

  const SetAsW({
    Key? key,
    required this.onHomeScreen,
    required this.onLockScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Icon(
                Icons.cancel_outlined,
                size: 50,
              ),
            ),
          ),
          Text(
            'Set Wallpaper',
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildButton(text: "Home Screen", onTap: onHomeScreen),
          const SizedBox(height: 10),
          _buildButton(text: "Lock Screen", onTap: onLockScreen),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade800, 
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
