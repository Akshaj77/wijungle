import 'dart:convert';

class SuccessResponse {
  final String status;
  final String key;
  SuccessResponse({
    required this.status,
    required this.key,
  });

  SuccessResponse copyWith({
    String? status,
    String? key,
  }) {
    return SuccessResponse(
      status: status ?? this.status,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'key': key,
    };
  }

  factory SuccessResponse.fromMap(Map<String, dynamic> map) {
    return SuccessResponse(
      status: map['status'] as String,
      key: map['key'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SuccessResponse.fromJson(String source) => SuccessResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SuccessResponse(status: $status, key: $key)';

  @override
  bool operator ==(covariant SuccessResponse other) {
    if (identical(this, other)) return true;
  
    return 
      other.status == status &&
      other.key == key;
  }

  @override
  int get hashCode => status.hashCode ^ key.hashCode;
}