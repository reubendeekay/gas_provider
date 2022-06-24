import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';

class OptionListTile extends StatelessWidget {
  const OptionListTile(
      {Key? key,
      required this.title,
      this.isComplete = false,
      this.onChanged,
      required this.icon})
      : super(key: key);

  final String title;
  final bool isComplete;
  final Function? onChanged;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onChanged != null) {
          onChanged!();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        color: Colors.grey[200],
        child: Row(
          children: [
            Icon(
              icon,
              color: isComplete ? kIconColor : Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(color: isComplete ? Colors.black : Colors.grey),
            ),
            const Spacer(),
            Icon(
              Icons.check_circle,
              color: isComplete ? kIconColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
