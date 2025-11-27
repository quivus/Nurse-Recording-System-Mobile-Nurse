class PatientRecord {
  final int? patientRecordId; 
  final String nursingDiagnosis;
  final String nursingIntervention;
  final int? nurseId;

  PatientRecord({
    this.patientRecordId,
    required this.nursingDiagnosis,
    required this.nursingIntervention,
    this.nurseId,
  });

  factory PatientRecord.fromJson(Map<String, dynamic> json) {
    return PatientRecord(
      patientRecordId: json['patientRecordId'] as int?,
      nursingDiagnosis: json['nursingDiagnosis'] as String,
      nursingIntervention: json['nursingIntervention'] as String,
      nurseId: json['nurseId'] as int?,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    final Map<String, dynamic> data = {
      'nursingDiagnosis': nursingDiagnosis,
      'nursingIntervention': nursingIntervention,
    };
    if (includeId && patientRecordId != null) {
      data['patientRecordId'] = patientRecordId;
    }
    if (nurseId != null) {
      data['nurseId'] = nurseId; 
    }
    return data;
  }
}
