import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class ExpenseFlowStatus extends StatefulWidget {
  final String iconImage;
  final String title;
  final int amount;
  final Color color;

  const ExpenseFlowStatus(
      {super.key,
      this.iconImage = "",
      this.title = "",
      this.amount = 0,
      this.color = AppPallete.successColor});

  @override
  State<ExpenseFlowStatus> createState() => _ExpenseFlowStatusState();
}

class _ExpenseFlowStatusState extends State<ExpenseFlowStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: widget.color),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Image(
              image: AssetImage(widget.iconImage),
              height: 40,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      color: AppPallete.primaryTextColor, fontSize: 15),
                ),
                Text(
                  "RS: ${widget.amount.toString()}",
                  style: const TextStyle(
                      color: AppPallete.primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
