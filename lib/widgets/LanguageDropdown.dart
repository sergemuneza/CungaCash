// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class LanguageDropdown extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<Locale>(
//       value: context.locale,
//       dropdownColor: Colors.blue[100],
//       style: const TextStyle(color: Colors.black),
//       icon: const Icon(Icons.language, color: Colors.white),
//       underline: Container(),
//       onChanged: (Locale? locale) {
//         if (locale != null) {
//           context.setLocale(locale);
//         }
//       },
//       items: const [
//         DropdownMenuItem(
//           value: Locale('en'),
//           child: Text("English"),
//         ),
//         DropdownMenuItem(
//           value: Locale('rw'),
//           child: Text("Kinyarwanda"),
//         ),
//       ],
//     );
//   }
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageDropdown extends StatefulWidget {
  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  late Locale _selectedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLocale = context.locale;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: _selectedLocale,
      dropdownColor: Colors.blue[100],
      style: const TextStyle(color: Colors.black),
      icon: const Icon(Icons.language, color: Colors.white),
      underline: Container(),
      onChanged: (Locale? locale) {
        if (locale != null) {
          setState(() {
            _selectedLocale = locale;
          });
          context.setLocale(locale);
        }
      },
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text("English"),
        ),
        DropdownMenuItem(
          value: Locale('rw'),
          child: Text("Kinyarwanda"),
        ),
      ],
    );
  }
}
