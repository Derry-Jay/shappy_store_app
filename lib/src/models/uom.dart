class MeasurementUnit {
  final int id;
  final String unit, createdDate, updatedDate;
  MeasurementUnit(this.id, this.unit, this.createdDate, this.updatedDate);

  factory MeasurementUnit.fromMap(Map<String, dynamic> json) => (json == null
      ? null
      : MeasurementUnit(json['UOM_ID'], json['units'], json['created_at'],
          json['updated_at'] != null ? json['updated_at'] : ""));

  bool operator ==(other) => (other is MeasurementUnit && other.id == id);

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
