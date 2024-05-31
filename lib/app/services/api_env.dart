class ApiUrl {
 // final String baseUrl = "https://octopi.algologix.com.bd/api/";
  final String baseUrl = "http://api.tradezentrum.com/";
  final String signInUrl ="Auth/Login";
  final String updatePasswordUrl = "User/ChangePassword";
  final String getTasks= "Task/GetTasks/${0}/${-1}";
  final String declearTaskStart = "Task/DeclareTaskStart/";
  final String getTaskDetails = "Task/GetTaskDetails/";
  final String addTransportation = "Task/AddTaskTransportation/";
  final String updateTransportation = "Task/UpdateTaskTransportation/";
  final String deleteTransportation = "Task/DeleteTaskTransportation/";
  final String reachLocation = "Task/AddTransportationEndLocation/";
  final String getLocations = "Location/GetLocations";
  final String getVehiclesList = 'Task/GetVehicles';
  final String declearCheckListCompletion = "Task/DeclareChecklistCompletion";
  final String getOtp = "Task/InsertTaskOTPRequestInfo";
  final String verityOtp = "Task/VerifyDeliveryOtp";
  final String returnTask = "Task/DeclareTaskCancelledAsync";
  final String taskAccomplish = 'Task/DeclareTaskCompletion/';
}