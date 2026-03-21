import 'package:flutter/material.dart';

void navigateTo (context , widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    )
);

void navigateAndFinish (context , widget ) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => widget
    ),
        (route){
      return false;
    }
);

Widget defaultFormField(
    {
      TextInputAction? inputAction,
      required TextEditingController controller,
      required TextInputType type,
      Function(String)? onSubmit,
      Function(String)? onChange,
      required String? Function(String?) validate,
      required String lable,
      required IconData prefix
    }
    ) => TextFormField(
      textInputAction: inputAction,
  controller: controller,
  validator: validate,
  decoration: InputDecoration(
    labelText: lable,
    border: OutlineInputBorder(),
    prefixIcon: Icon(prefix),
  ),
  keyboardType: type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
);

Widget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
})
=> AppBar(
  leading: IconButton(
    onPressed: ()
    {
    Navigator.pop(context);
    },
    icon: Icon(
        Icons.arrow_back
    ),
  ),
  title: Text(
      title!,
  ),
);
