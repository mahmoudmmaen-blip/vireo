import 'package:vireo/data/models/unit_preference.dart';

/// Converts display units ↔ canonical metric storage (kg, cm).
abstract final class UnitConverter {
  static const cmPerInch = 2.54;
  static const kgPerLb = 0.45359237;

  static double lbToKg(double lb) => lb * kgPerLb;

  static double kgToLb(double kg) => kg / kgPerLb;

  static double inchToCm(double inch) => inch * cmPerInch;

  static double cmToInch(double cm) => cm / cmPerInch;

  static double displayWeight(double kg, UnitPreference unit) =>
      unit == UnitPreference.imperial ? kgToLb(kg) : kg;

  static double displayHeight(double cm, UnitPreference unit) =>
      unit == UnitPreference.imperial ? cmToInch(cm) : cm;

  static String weightLabel(UnitPreference unit) =>
      unit == UnitPreference.imperial ? 'lb' : 'kg';

  static String heightLabel(UnitPreference unit) =>
      unit == UnitPreference.imperial ? 'in' : 'cm';

  static double inputWeightToKg(double value, UnitPreference unit) =>
      unit == UnitPreference.imperial ? lbToKg(value) : value;

  static double inputHeightToCm(double value, UnitPreference unit) =>
      unit == UnitPreference.imperial ? inchToCm(value) : value;
}
