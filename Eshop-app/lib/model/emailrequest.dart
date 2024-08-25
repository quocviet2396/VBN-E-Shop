class EmailRequest {
  String email;

  EmailRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
