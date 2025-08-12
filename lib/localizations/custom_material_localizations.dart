import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RwandanMaterialLocalizations extends DefaultMaterialLocalizations {
  const RwandanMaterialLocalizations();

  @override
  String get aboutListTileTitleRaw => r'Bijyanye na $applicationName';

  @override
  String get alertDialogLabel => 'Inyobora';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get backButtonTooltip => 'Subira inyuma';

  @override
  String get cancelButtonLabel => 'KURAGUZA';

  @override
  String get closeButtonLabel => 'GUFUNGA';

  @override
  String get closeButtonTooltip => 'Funga';

  @override
  String get collapsedIconTapHint => 'Kuraguza';

  @override
  String get continueButtonLabel => 'KOMEZA';

  @override
  String get copyButtonLabel => 'GUKOPORORA';

  @override
  String get cutButtonLabel => 'GUKATA';

  @override
  String get deleteButtonTooltip => 'Gusiba';

  @override
  String get dialModeButtonLabel => 'Guhindura ubwoko bwo gutoranya';

  @override
  String get dialogLabel => 'Ikiganiro';

  @override
  String get drawerLabel => 'Menu yo kuvuga';

  @override
  String get expandedIconTapHint => 'Gufunga';

  @override
  String get hideAccountsLabel => 'Guhisha konti';

  @override
  String get licensesPageTitle => 'Uruhushya';

  @override
  String get modalBarrierDismissLabel => 'Kuraguza';

  @override
  String get nextMonthTooltip => 'Ukwezi gutaha';

  @override
  String get nextPageTooltip => 'Urupapuro rukurikira';

  @override
  String get okButtonLabel => 'YEGO';

  @override
  String get openAppDrawerTooltip => 'Gufungura menu yo kuvuga';

  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow muri $rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw => r'$firstRow–$lastRow muri hafi $rowCount';

  @override
  String get pasteButtonLabel => 'GUSHYIRAHO';

  @override
  String get popupMenuLabel => 'Menu yo hejuru';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'Ukwezi gushize';

  @override
  String get previousPageTooltip => 'Urupapuro rwabanjirije';

  @override
  String get refreshIndicatorSemanticLabel => 'Gushyira mu giti';

  @override
  String get remainingTextFieldCharacterCountOne => '1 inyuguti yasigaye';

  @override
  String get remainingTextFieldCharacterCountOther => r'$remainingCount inyuguti zasigaye';

  @override
  String get remainingTextFieldCharacterCountZero => 'Nta nyuguti yasigaye';

  @override
  String get reorderItemDown => 'Kumanura';

  @override
  String get reorderItemLeft => 'Kwerekeza ibumoso';

  @override
  String get reorderItemRight => 'Kwerekeza iburyo';

  @override
  String get reorderItemToEnd => 'Kwerekeza ku mpera';

  @override
  String get reorderItemToStart => 'Kwerekeza ku ntangiriro';

  @override
  String get reorderItemUp => 'Kuzamura';

  @override
  String get rowsPerPageTitle => 'Imirongo ku rupapuro:';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchFieldLabel => 'Gushakisha';

  @override
  String get selectAllButtonLabel => 'GUHITAMO BYOSE';

  @override
  String get selectedRowCountTitleOne => '1 bintu byahiswemo';

  @override
  String get selectedRowCountTitleOther => r'$selectedRowCount bintu byahiswemo';

  @override
  String get selectedRowCountTitleZero => 'Nta kintu cyahiswemo';

  @override
  String get showAccountsLabel => 'Kwerekana konti';

  @override
  String get showMenuTooltip => 'Kwerekana menu';

  @override
  String get signedInLabel => 'Winjiye';

  @override
  String get tabLabelRaw => r'Itab $tabIndex muri $tabCount';

  @override
  String get timeOfDayFormatRaw => 'h:mm a';

  @override
  String get timePickerHourModeAnnouncement => 'Hitamo amasaha';

  @override
  String get timePickerMinuteModeAnnouncement => 'Hitamo iminota';

  @override
  String get viewLicensesButtonLabel => 'REBA URUHUSHYA';

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _RwandanMaterialLocalizationsDelegate();
}

class _RwandanMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _RwandanMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'rw';

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      const RwandanMaterialLocalizations();

  @override
  bool shouldReload(_RwandanMaterialLocalizationsDelegate old) => false;

  @override
  String toString() => 'RwandanMaterialLocalizations.delegate(rw)';
}