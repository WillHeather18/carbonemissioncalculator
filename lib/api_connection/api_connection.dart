class API {
  static const hostConnect = "http://192.168.0.91/cec_api";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectJourney = "$hostConnect/journey";

  //login user
  static const login = "$hostConnectUser/login.php";
  //signup user
  static const signup = "$hostConnectUser/signup.php";
  //add journey
  static const addJourney = "$hostConnectJourney/add_journey.php";
  //get journies
  static const getJournies = "$hostConnectJourney/get_entries.php";
  //delete journey
  static const deleteJourney = "$hostConnectJourney/delete_entry.php";
  //edit journey
  static const editJourney = "$hostConnectJourney/edit_entry.php";
}
