class BabysittingService {
  final String id;
  final String? babysitterId;
  final String tutorId;
  final DateTime startDate;
  final DateTime endDate;
  final double value;
  final int childrenCount;
  final String address;

  BabysittingService({
    required this.id,
    this.babysitterId,
    required this.tutorId,
    required this.startDate,
    required this.endDate,
    required this.value,
    required this.childrenCount,
    required this.address,
  });

  factory BabysittingService.fromJson(Map<String, dynamic> json) {
    return BabysittingService(
      id: json['id'],
      babysitterId: json['babysitterId'],
      tutorId: json['tutorId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      value: json['value'].toDouble(),
      childrenCount: json['childrenCount'],
      address: json['address'],
    );
  }
}
