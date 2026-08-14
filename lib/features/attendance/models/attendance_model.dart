class AttendanceModel {
  final String id;
  final String userId;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final double clockInLat;
  final double clockInLng;
  final double? clockOutLat;
  final double? clockOutLng;
  final String? clockInPhoto;
  final String? clockOutPhoto;
  final String? notes;
  final String status; // 'Hadir', 'Terlambat', 'Izin'

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.clockInTime,
    this.clockOutTime,
    required this.clockInLat,
    required this.clockInLng,
    this.clockOutLat,
    this.clockOutLng,
    this.clockInPhoto,
    this.clockOutPhoto,
    this.notes,
    this.status = 'Hadir',
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      clockInTime: DateTime.parse(json['clock_in_time']),
      clockOutTime: json['clock_out_time'] != null ? DateTime.parse(json['clock_out_time']) : null,
      clockInLat: (json['clock_in_lat'] as num).toDouble(),
      clockInLng: (json['clock_in_lng'] as num).toDouble(),
      clockOutLat: json['clock_out_lat'] != null ? (json['clock_out_lat'] as num).toDouble() : null,
      clockOutLng: json['clock_out_lng'] != null ? (json['clock_out_lng'] as num).toDouble() : null,
      clockInPhoto: json['clock_in_photo'],
      clockOutPhoto: json['clock_out_photo'],
      notes: json['notes'],
      status: json['status'] ?? 'Hadir',
    );
  }
}
