import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/constants/font_styles.dart';

// custom drop down menu for category in creating new post
class MyDropdownMenu extends StatefulWidget {
  final Function(String) onValueChange;

  const MyDropdownMenu({Key? key, required this.onValueChange})
      : super(key: key);

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
        color: AppColors.grey2,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton<String>(
        hint: Text(
          'Select a category',
          style: CustomFontStyles.hintText,
        ),
        isExpanded: true,
        value: dropdownValue,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.grey5,
        ),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
          widget.onValueChange(dropdownValue!);
        },
        borderRadius: BorderRadius.circular(12),
        items: _buildDropdownItems(),
        style: CustomFontStyles.selectedDropDownItem,
        underline: Container(),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return categories.entries.map<DropdownMenuItem<String>>((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList();
  }
}
