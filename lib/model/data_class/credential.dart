class CredentialModel{
  String token,refreshToken;
  DateTime expireAt;

  CredentialModel({required this.token, required this.refreshToken, required this.expireAt});

  factory CredentialModel.fromJSON(data){
    return CredentialModel(
        token: data["token"],
        refreshToken: data["refreshToken"],
        expireAt: DateTime.fromMillisecondsSinceEpoch(data["tokenExpireAt"] * 1000,isUtc: false),
    );
  }
}