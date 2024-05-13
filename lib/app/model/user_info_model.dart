class UserProfileModel {
  String? userEmail;
  String? userSystemId;
  String? employeeId;
  String? userFullName;
  String? userActiveStatus;
  String? userRoleId;
  String? roleName;
  String? clientId;
  String? channelId;
  String? jti;
  int? exp;
  String? iss;
  String? aud;

  UserProfileModel({
    this.userEmail,
    this.userSystemId,
    this.employeeId,
    this.userFullName,
    this.userActiveStatus,
    this.userRoleId,
    this.roleName,
    this.clientId,
    this.channelId,
    this.jti,
    this.exp,
    this.iss,
    this.aud,
  });

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    userEmail = json['UserName'];
    userSystemId = json['UserSystemId'];
    employeeId = json['EmployeeId'];
    userFullName = json['UserFullName'];
    userActiveStatus = json['UserActiveStatus'];
    userRoleId = json['UserRoleId'];
    roleName = json['RoleName'];
    clientId = json['ClientId'];
    channelId = json['ChannelId'];
    jti = json['jti'];
    exp = json['exp'];
    iss = json['iss'];
    aud = json['aud'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['UserName'] = userEmail;
    data['UserSystemId'] = userSystemId;
    data['EmployeeId'] = employeeId;
    data['UserFullName'] = userFullName;
    data['UserActiveStatus'] = userActiveStatus;
    data['UserRoleId'] = userRoleId;
    data['RoleName'] = roleName;
    data['ClientId'] = clientId;
    data['ChannelId'] = channelId;
    data['jti'] = jti;
    data['exp'] = exp;
    data['iss'] = iss;
    data['aud'] = aud;

    return data;
  }
}
