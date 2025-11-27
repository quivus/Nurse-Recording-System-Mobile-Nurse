class Appointment {
  final int? id; // id is nullable for new appointments
  final String appointmentTime;
  final String appointmentDescription;
  final int nurseId;
  final String createdBy;
  final String? updatedBy;

  Appointment({
    this.id,
    required this.appointmentTime,
    required this.appointmentDescription,
    required this.nurseId,
    required this.createdBy,
    this.updatedBy,
  });

  Map<String, dynamic> toJson({bool forUpdate = false}) {
    final map = {
      "appointmentTime": appointmentTime,
      "appointmentDescription": appointmentDescription,
      "nurseId": nurseId,
      "createdBy": createdBy,
    };
    if (forUpdate && updatedBy != null) {
      map["updatedBy"] = updatedBy!;
    }
    return map;
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json["id"],
      appointmentTime: json["appointmentTime"] ?? '',
      appointmentDescription: json["appointmentDescription"] ?? '',
      nurseId: json["nurseId"] ?? 0,
      createdBy: json["createdBy"] ?? '',
      updatedBy: json["updatedBy"],
    );
  }
}
