import 'package:flutter/material.dart';

class TechDetails extends StatefulWidget {
  @override
  _TechDetailsState createState() => _TechDetailsState();
}

class _TechDetailsState extends State<TechDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'not yet implemented',
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Text('\$200'), Text('2.5hrs')],
            ),
          ],
        ),
      ),
    );
  }
}
