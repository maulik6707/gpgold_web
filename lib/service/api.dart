class API {
  static const baseUrl = "https://gdgold.in/gdgold/api/";

  static const login = "${baseUrl}login.php?api_key=123456789";
  static const register = "${baseUrl}register.php?api_key=123456789";
  static const requestOtp = "${baseUrl}request_otp.php?api_key=123456789";
  static const changePassword = "${baseUrl}change_password.php?api_key=123456789";
  static const forgotPassword = "${baseUrl}forgot_password_request.php?api_key=123456789";

  //Category
  static const addCategory = "${baseUrl}category.php?api_key=123456789";
  static const getCategory = "${baseUrl}categories.php?api_key=123456789";

  //Repair
  static const getRepair = "${baseUrl}repairs.php?api_key=123456789";

  //Buffer days
  static const addBufferDays = "${baseUrl}bufferdays.php?api_key=123456789";

  //Client
  static const getClient = "${baseUrl}clients.php?api_key=123456789";
  static const deleteClient = "${baseUrl}clients.php?api_key=123456789";
  static const deactivateClient = "${baseUrl}change-status-clients.php?api_key=123456789";

  //Karigar
  static const getKarigar = "${baseUrl}karigars.php?api_key=123456789";
  static const addKarigar = "${baseUrl}karigars.php?api_key=123456789";
  static const assignKarigar = "${baseUrl}orders.php";

  //Order Fields
  static const getCategoryOrderField = "${baseUrl}order-fields.php/";
  static const addCategoryOrderField = "${baseUrl}order-fields.php?api_key=123456789";
  static const addGeneralOrderField = "${baseUrl}general-fields.php?api_key=123456789";
  static const getGeneralOrderField = "${baseUrl}general-fields.php?api_key=123456789";
  static const deleteGeneralOrderField = "${baseUrl}general-fields.php?api_key=123456789";

  //Dropdown options
  static const addDropdownOption = "${baseUrl}dropdown-options.php?api_key=123456789";
  static const getDropdownOption = "${baseUrl}dropdown-options.php/";

  //Orders
  static const addOrder = "${baseUrl}orders.php?api_key=123456789";

}
