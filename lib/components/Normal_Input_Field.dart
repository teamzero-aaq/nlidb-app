import '../constants.dart';
import 'package:flutter/material.dart';

class NormalInputField extends StatefulWidget {
  final String lableText;
  final Widget child;
  const NormalInputField({Key key, @required this.child, this.lableText})
      : super(key: key);

  static InputDecoration textFieldDecoration({
    IconData prefixIcon,
    Widget suffixIcon,
    Color iconColor,
    String hintText,
    String labelText,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: iconColor,
      ),
      contentPadding: EdgeInsets.only(left: 30.0, bottom: 20.0, top: 20.0),
      hintText: hintText,
      suffixIcon: suffixIcon,
      fillColor: kform,
      hintStyle: TextStyle(
        color: kPrimaryColor,
        fontWeight: FontWeight.normal,
      ),
      filled: true,
    );
  }

  @override
  _NormalInputFieldState createState() => _NormalInputFieldState();
}

class _NormalInputFieldState extends State<NormalInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.lableText,
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width,
            child: widget.child),
      ],
    );
  }
}
