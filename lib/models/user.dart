class User {
  final int userId;
  final String name;
  final String email;
  final String image;


  const User({
    required this.userId,
    required this.name,
    required this.email,
    required this.image
  });

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
        userId: json['userId'],
        name: json['name'],
        email: json['email'],
        image: json['image']
    );
  }
}