import 'uom.dart';

class MeasurementUnitBase {
  final bool success, status;
  final List<MeasurementUnit> units;
  MeasurementUnitBase(this.success, this.status, this.units);
  factory MeasurementUnitBase.fromMap(Map<String, dynamic> json) {
    return MeasurementUnitBase(
        json['success'],
        json['status'],
        json['result'] != null
            ? List.from(json['result'])
                .map((element) => MeasurementUnit.fromMap(element))
                .toList()
            : []);
  }
}
