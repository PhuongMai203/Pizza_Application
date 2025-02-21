import '../entities/entities.dart';

export 'user.dart';

class MyUser{
  String userId;
  String email;
  String name;
  late String password;
  bool hasActiveCart;
  final String avatarUrl;
  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    required this.avatarUrl,
  });
   static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    hasActiveCart: false,
    avatarUrl: '',
    );

    MyUserEntity toEntity(){
      return MyUserEntity(
        userId: userId,
        email: email,
        name: name,
        hasActiveCart: hasActiveCart,
        avatarUrl: avatarUrl,
      );
    }
    static MyUser fromEntity(MyUserEntity entity){
      return MyUser(
        userId: entity.userId, 
        email: entity.email, 
        name: entity.name, 
        hasActiveCart: entity.hasActiveCart,
        avatarUrl: entity.avatarUrl,
        );
    }
  @override
  String toString() {
    return 'MyUser: userId=$userId, email=$email, name=$name, hasActiveCart=$hasActiveCart, avatarUrl=$avatarUrl';
  }
}