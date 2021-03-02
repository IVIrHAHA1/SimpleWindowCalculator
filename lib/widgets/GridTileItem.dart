import 'package:TheWindowCalculator/Tools/ImageLoader.dart';
import 'package:flutter/material.dart';
import 'package:TheWindowCalculator/objects/Window.dart';

class GridTileItem extends StatelessWidget {
  final Window item;

  /// Function to be called when pressed. If [onSelected] is not null, then
  /// this function is disabled.
  final Function(Window) onPressed;

  /// Function to be called when this item is selected and only when initially selected.
  /// Disables onPressed. Return whether item was successfully selected.
  final Function(Window) onSelected;
  final bool selectable;
  final bool selected;

  GridTileItem({
    @required this.item,
    this.onPressed,
    this.selectable = false,
    this.onSelected,
    this.selected,
  });

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
                    image:
                        Imager.fromFile(item.getImageFile()).masterImage.image,
                    fit: BoxFit.fill,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.blue,
                    onTap: selectable
                        ? () {
                            onSelected(
                              item,
                            );
                          }
                        : () {
                            onPressed(item);
                          },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 0,
              child: Text(
                '${item.name.toLowerCase()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
