import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(context: context, title: 'Sign Out', content: 'Are you sure you want to sign out?', optionsBuilder: () => {
    'Cancel': false,
    'Log Out': true,
  },).then((value)=>value??false);
}