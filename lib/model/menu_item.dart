import 'package:flutter/material.dart';

class MenuItem {

  String _title;
  IconData _icon;
  Color _color;
  Widget _page;

  MenuItem({
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
  })  : _title = title,
        _icon = icon,
        _color = color,
        _page = page;

  String get title => _title;
  IconData get icon => _icon;
  Color get color => _color;
  Widget get page => _page;

  set title(String value) => _title = value;
  set icon(IconData value) => _icon = value;
  set color(Color value) => _color = value;
  set page(Widget value) => _page = value;
}
