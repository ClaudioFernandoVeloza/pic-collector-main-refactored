import 'package:flutter/material.dart';

/// A user's friend with a display name, email, and avatar color.
class Friend {
  final String name;
  final String surname;
  final String username;
  final String email;
  final Color color;
  final String? nickname;
  final DateTime? friendsSince;

  const Friend({
    required this.name,
    this.surname = '',
    this.username = '',
    required this.email,
    required this.color,
    this.nickname,
    this.friendsSince,
  });

  String get displayName {
    if (nickname != null && nickname!.trim().isNotEmpty) {
      return nickname!;
    }

    final fullName = [
      name,
      surname,
    ].where((part) => part.trim().isNotEmpty).join(' ');
    return fullName.isEmpty ? username : fullName;
  }

  Friend copyWith({
    String? name,
    String? surname,
    String? username,
    String? email,
    Color? color,
    String? nickname,
    DateTime? friendsSince,
  }) {
    return Friend(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      username: username ?? this.username,
      email: email ?? this.email,
      color: color ?? this.color,
      nickname: nickname ?? this.nickname,
      friendsSince: friendsSince ?? this.friendsSince,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Friend &&
        ((email == other.email && email.isNotEmpty) ||
            (username.isNotEmpty && username == other.username));
  }

  @override
  int get hashCode => (email.isNotEmpty ? email : username).hashCode;
}
