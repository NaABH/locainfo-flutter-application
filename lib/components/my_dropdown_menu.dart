import 'package:flutter/material.dart';

const List<String> list = <String>[
  'News & Announcement',
  'Events & Activities',
  'Promotions',
  'Housing Marketplace',
  'Safety'
];

class MyDropdownMenu extends StatefulWidget {
  const MyDropdownMenu({Key? key}) : super(key: key);

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10.0)),
      child: DropdownButton<String>(
        hint: Text(
          'Select a category',
          style: TextStyle(color: Colors.grey.shade500),
        ),
        isExpanded: true,
        value: dropdownValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
        borderRadius: BorderRadius.circular(12),
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        style: TextStyle(
          color: Colors.grey.shade700, // Change the color of the selected item
          fontSize: 16.0, // Change the size of the selected item
          fontWeight:
              FontWeight.w500, // Change the font weight of the selected item
        ),
        underline: Container(),
      ),
    );
  }
}
