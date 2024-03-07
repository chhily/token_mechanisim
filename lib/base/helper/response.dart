class BaseResponse {
  int? status;
  String? message;
  String? version;
  BaseResponse({this.status, this.message, this.version});
  BaseResponse.fromJson(dynamic json){
    status = json['status'];
    message = json['message'];
    version = json['version'];
  }
}