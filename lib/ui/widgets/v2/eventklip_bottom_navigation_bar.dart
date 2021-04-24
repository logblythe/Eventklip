import 'package:flutter/material.dart';

const BoxklipBottomNavigationBarLabelStyle =
    TextStyle(color: Colors.black, fontSize: 12);

class BoxklipBottomNavigationBar extends StatefulWidget {
  const BoxklipBottomNavigationBar({Key key}) : super(key: key);

  @override
  _BoxklipBottomNavigationBarState createState() =>
      _BoxklipBottomNavigationBarState();
}

class _BoxklipBottomNavigationBarState
    extends State<BoxklipBottomNavigationBar> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: SizedBox(
        height: 60,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BoxKliBottomNavigationBarItem(
                Icons.home,
                'Home',
                _activeIndex == 0,
                () {
                  updateSelection(0);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13.0, left: 8),
                child: Text(
                  'Scan',
                  style: BoxklipBottomNavigationBarLabelStyle,
                ),
              ),
              BoxKliBottomNavigationBarItem(
                Icons.history,
                'History',
                _activeIndex == 1,
                () {
                  updateSelection(1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSelection(int selection) {
    setState(() {
      _activeIndex = selection;
    });
  }
}

class BoxKliBottomNavigationBarItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final bool isActive;
  final Function onSelect;

  const BoxKliBottomNavigationBarItem(
      this.iconData, this.label, this.isActive, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 24,
      onTap: onSelect,
      child: Column(
        children: [
          Icon(
            iconData,
            color: isActive ? Theme.of(context).primaryColor : Colors.grey,
          ),
          Text(label, style: BoxklipBottomNavigationBarLabelStyle),
        ],
      ),
    );
  }
}
