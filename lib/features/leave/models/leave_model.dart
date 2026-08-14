class LeaveModel {
  final String id;
  final String userId;
  final String userName;
  final String type; // 'Cuti Tahunan', 'Izin Sakit', 'Izin Khusus'
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String? attachmentUrl;
  final String status; // 'Pending', 'Approved', 'Rejected'
  final String? adminNotes;

  LeaveModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.attachmentUrl,
    this.status = 'Pending',
    this.adminNotes,
  });

  int get durationDays {
    return endDate.difference(startDate).inDays + 1;
  }

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? 'Karyawan',
      type: json['type'] ?? 'Cuti Tahunan',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      reason: json['reason'] ?? '',
      attachmentUrl: json['attachment_url'],
      status: json['status'] ?? 'Pending',
      adminNotes: json['admin_notes'],
    );
  }
}
