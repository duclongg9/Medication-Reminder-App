class UserDto {
  final String id;
  final String userName;

  const UserDto({
    required this.id,
    required this.userName,
});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: (json['id'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
    );
  }

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      id: (map['id'] ?? '').toString(),
      userName: (map['userName'] ?? map['username'] ?? map['user_name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName
  };
}
