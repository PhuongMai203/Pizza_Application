class MyUserEntity{
  String userId;
  String email;
  String name;
  late String password;
  bool hasActiveCart;
  final String avatarUrl;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    required this.avatarUrl,
  });
  // ✅ Thêm phương thức copyWith()
  MyUserEntity copyWith({
    String? userId,
    String? email,
    String? name,
    bool? hasActiveCart,
    String? avatarUrl,
  }) {
    return MyUserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      hasActiveCart: hasActiveCart ?? this.hasActiveCart,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
  Map<String, Object?> toDocument(){
    return{
      'userId': userId,
      'email': email,
      'name': name,
      'hasActiveCart': hasActiveCart,
      'avatarUrl': avatarUrl,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic>doc){
    return MyUserEntity(
      userId: doc['userId'], 
      email: doc['email'], 
      name: doc['name'], 
      hasActiveCart: doc['hasActiveCart'],
      avatarUrl: doc['avatarUrl'],
      );
  }
}