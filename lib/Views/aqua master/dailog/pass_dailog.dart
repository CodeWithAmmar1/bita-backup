import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testappbita/utils/theme/theme.dart';

class PasscodeDialog extends StatefulWidget {
  final Function(String) onPasscodeEntered;

  const PasscodeDialog({super.key, required this.onPasscodeEntered});

  @override
  PasscodeDialogState createState() => PasscodeDialogState();
}

class PasscodeDialogState extends State<PasscodeDialog> {
  final TextEditingController _controller = TextEditingController();

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: _controller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'password'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onPasscodeEntered(_controller.text.trim());
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Submit'.tr,
                style: TextStyle(color: ThemeColor().actual),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
