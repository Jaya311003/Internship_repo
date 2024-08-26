import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Account {
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<String> member;
  final List<String> mods;
  Account({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.member,
    required this.mods,
  });

  Account copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? member,
    List<String>? mods,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      member: member ?? this.member,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'member': member,
      'mods': mods,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      banner: map['banner'] ?? '',
      avatar: map['avatar'] ?? '',
      member: List<String>.from(map['member']),
      mods: List<String>.from(map['mods']),
    );
  }

  @override
  String toString() {
    return 'Account(id: $id, name: $name, banner: $banner, avatar: $avatar, member: $member, mods: $mods)';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.banner == banner &&
      other.avatar == avatar &&
      listEquals(other.member, member) &&
      listEquals(other.mods, mods);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      banner.hashCode ^
      avatar.hashCode ^
      member.hashCode ^
      mods.hashCode;
  }
}
