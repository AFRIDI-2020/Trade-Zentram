class CheckListData {
  List<CheckList>? checkList;

  CheckListData({this.checkList});

  CheckListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      checkList = <CheckList>[];
      json['data'].forEach((v) {
        checkList!.add(CheckList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (checkList != null) {
      data['data'] = checkList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckList {
  String? title;
  List<StatusList>? statusLsit;

  CheckList({this.title, this.statusLsit});

  CheckList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['statusLsit'] != null) {
      statusLsit = <StatusList>[];
      json['statusLsit'].forEach((v) {
        statusLsit!.add(StatusList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    if (statusLsit != null) {
      data['statusLsit'] = statusLsit!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatusList {
  String? title;
  String? id;

  StatusList({this.title, this.id});

  StatusList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['id'] = id;
    return data;
  }
}