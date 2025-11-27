class AddFormModel {
  final int? formId; 
  final String issueType;
  final String issueDescription;
  final String status;
  final String patientName;

  AddFormModel({
    this.formId,
    required this.issueType,
    required this.issueDescription,
    required this.status,
    required this.patientName,
  });

  Map<String, dynamic> toJson({bool forUpdate = false}) {
    final map = {
      "issueType": issueType,
      "issueDescription": issueDescription,
      "status": status,
      "patientName": patientName,
    };

    // Include formId if updating
    if (forUpdate && formId != null) {
      map["formId"] = formId as String;
    }

    return map;
  }

  factory AddFormModel.fromJson(Map<String, dynamic> json) {
    return AddFormModel(
      formId: json["formId"] is int ? json["formId"] : int.tryParse(json["formId"].toString()),
      issueType: json["issueType"] ?? "",
      issueDescription: json["issueDescription"] ?? "",
      status: json["status"] ?? "",
      patientName: json["patientName"] ?? "",
    );
  }
}
