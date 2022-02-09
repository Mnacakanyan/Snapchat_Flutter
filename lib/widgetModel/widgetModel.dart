import 'package:flutter/material.dart';

class FirstLast extends StatefulWidget {
  FirstLast({  
  required this.autofocus, 
  required this.textCapitalization, 
  required this.readOnly,
  required this.obscureText,
  required this.onChanged,
  this.errorText,
  this.text, 
  this.margin, 
  this.controller,
  this.keyboardType,
  this.helperText,
  this.suffix,
  this.prefix,
  this.labelText,
  this.validator,

  })
      : super();
  final String? text;
  final String? errorText;
  final bool autofocus;
  final TextCapitalization? textCapitalization;
  final EdgeInsets? margin;
  final Function (String?) onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String? helperText;
  final Widget? suffix;
  final Widget? prefix;
  final bool? obscureText;
  final String? labelText;

  @override
  _FirstLastState createState() => _FirstLastState();
}

class _FirstLastState extends State<FirstLast> {
  @override
  Widget build(BuildContext context) {
    var autofocous = widget.autofocus;
    var text = widget.text;
    var margin = widget.margin;
    var textCapitalization = widget.textCapitalization;
    var errorText = widget.errorText;
    var onChanged = widget.onChanged;
    var controller = widget.controller;
    var readOnly = widget.readOnly;
    var helperText = widget.helperText;
    var suffix = widget.suffix;
    var obscureText = widget.obscureText;
    var labelText = widget.labelText;
    var prefix = widget.prefix;
    var validator = widget.validator;
    var keyboardType = widget.keyboardType;
    return Container(
        margin: margin,
        width: MediaQuery.of(context).size.width - 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(text.toString(), style: TextStyle(color: Colors.grey[400]),),
            TextFormField(
              keyboardType: keyboardType,
              controller: controller,
              onChanged: onChanged ,
              textCapitalization: textCapitalization!,
              autofocus: autofocous,
              validator: validator,
              readOnly: readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: obscureText!,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                errorText: errorText,
                labelText: labelText,
                helperText: helperText,
                suffix: suffix,
                prefix: prefix,
              ),
            ),
          ],
        ),
      );
    
  }
}
