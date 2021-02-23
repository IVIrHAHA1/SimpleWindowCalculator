import 'package:SimpleWindowCalculator/Routes/Window_Object_Screen.dart';
import 'package:SimpleWindowCalculator/Tools/ImageLoader.dart';
import 'package:flutter/material.dart';
import 'package:SimpleWindowCalculator/objects/Window.dart';

class GridTileItem extends StatefulWidget {
  final Window item;
  final Function(Window) onPressed;
  final bool selectable;

  GridTileItem({@required this.item, this.onPressed, this.selectable = false});

  @override
  _GridTileItemState createState() => _GridTileItemState();
}

class _GridTileItemState extends State<GridTileItem> {
  bool selected;

  _GridTileItemState() {
    this.selected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? Theme.of(context).primaryColorLight : Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: Imager.fromFile(widget.item.getImageFile())
                        .masterImage
                        .image,
                    fit: BoxFit.fill,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.blue,
                    onTap: widget.selectable
                        ? () {
                            setState(() {
                              selected = !selected;
                            });
                          }
                        : () {
                            widget.onPressed(widget.item);
                          },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 0,
              child: Text('${widget.item.name.toLowerCase()}'),
            ),
          ],
        ),
      ),
    );
  }
}
