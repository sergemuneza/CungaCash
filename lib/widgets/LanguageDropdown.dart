// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:flutter/material.dart';

// // class LanguageDropdown extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return DropdownButton<Locale>(
// //       value: context.locale,
// //       dropdownColor: Colors.blue[100],
// //       style: const TextStyle(color: Colors.black),
// //       icon: const Icon(Icons.language, color: Colors.white),
// //       underline: Container(),
// //       onChanged: (Locale? locale) {
// //         if (locale != null) {
// //           context.setLocale(locale);
// //         }
// //       },
// //       items: const [
// //         DropdownMenuItem(
// //           value: Locale('en'),
// //           child: Text("English"),
// //         ),
// //         DropdownMenuItem(
// //           value: Locale('rw'),
// //           child: Text("Kinyarwanda"),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class LanguageDropdown extends StatefulWidget {
//   @override
//   _LanguageDropdownState createState() => _LanguageDropdownState();
// }

// class _LanguageDropdownState extends State<LanguageDropdown> {
//   late Locale _selectedLocale;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _selectedLocale = context.locale;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<Locale>(
//       value: _selectedLocale,
//       dropdownColor: Colors.blue[100],
//       style: const TextStyle(color: Colors.black),
//       icon: const Icon(Icons.language, color: Colors.white),
//       underline: Container(),
//       onChanged: (Locale? locale) {
//         if (locale != null) {
//           setState(() {
//             _selectedLocale = locale;
//           });
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
  final bool isCompact; // Add option for compact mode
  
  const LanguageDropdown({Key? key, this.isCompact = false}) : super(key: key);

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
    if (widget.isCompact) {
      // Compact version for ListTiles
      return Container(
        constraints: const BoxConstraints(maxWidth: 120),
        child: DropdownButton<Locale>(
          value: _selectedLocale,
          dropdownColor: Colors.blue[100],
          style: const TextStyle(color: Colors.black, fontSize: 12),
          icon: const Icon(Icons.language, color: Colors.white, size: 16),
          underline: Container(),
          isDense: true,
          isExpanded: false,
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
              child: Text("EN", style: TextStyle(fontSize: 12)),
            ),
            DropdownMenuItem(
              value: Locale('rw'),
              child: Text("RW", style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
    }

    // Regular version for welcome screen
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<Locale>(
        value: _selectedLocale,
        dropdownColor: Colors.blue[100],
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        icon: const Icon(Icons.language, color: Colors.blue),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("🇺🇸"),
                SizedBox(width: 8),
                Text("English"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: Locale('rw'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("🇷🇼"),
                SizedBox(width: 8),
                Text("Kinyarwanda"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}