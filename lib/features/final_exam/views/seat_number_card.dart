import 'package:flutter/material.dart';

class SeatNumberCard extends StatelessWidget {
  const SeatNumberCard(this.seatNumber, {super.key});

  final String seatNumber;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceTint,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Column(
          children: [
            Text(
              seatNumber,
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chair_alt,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 2),
                Text(
                  "Seat number",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
