class BabySittingServiceData {
  final String id;
  final String? babysitterId;
  final String tutorId;
  final String tutorName;
  final String? babysitterName;
  final List<dynamic> enrollments;
  final DateTime startDate;
  final DateTime endDate;
  final double value;
  final int childrenCount;
  final String address;

  const BabySittingServiceData({
    required this.enrollments,
    required this.id,
    required this.babysitterId,
    required this.tutorId,
    required this.tutorName,
    required this.babysitterName,
    required this.startDate,
    required this.endDate,
    required this.value,
    required this.childrenCount,
    required this.address,
  });

  factory BabySittingServiceData.fromJson(Map<String, dynamic> json) {
    return BabySittingServiceData(
      id: json['id'],
      babysitterId: json['babysitterId'],
      tutorId: json['tutorId'],
      tutorName: json['tutorName'],
      babysitterName: json['babysitterName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      value: json['value'],
      childrenCount: json['childrenCount'],
      address: json['address'],
      enrollments: json['enrollments'],
    );
  }
}
