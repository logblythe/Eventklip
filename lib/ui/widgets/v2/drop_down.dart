import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String selectedOption;
  final List<String> options;
  final Function(int) onSelect;
  final String label;
  final bool isRequired;

  const Dropdown(
      {Key key,
      this.selectedOption,
      @required this.options,
      @required this.onSelect,
      @required this.label,
      this.isRequired = false})
      : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String dropdownValue;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.selectedOption;
    options.addAll(widget.options);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropdownButtonFormField<String>(
          hint: Text(
            widget.label ?? "",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          value: dropdownValue,
          validator: (value) => widget.isRequired
              ? value == null
                  ? "Required"
                  : null
              : null,
          onChanged: (String newValue) {
            setState(() => dropdownValue = newValue);
            widget.onSelect(options.indexOf(newValue));
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14)),
            );
          }).toList(),
        ),
        Positioned(
          right: 0,
          child: widget.isRequired
              ? Text('*',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: Colors.red))
              : Container(),
        ),
      ],
    );
  }
}
