
class LengthLimitHanding {

  String FullNameLimit(String fullName) {
    if (fullName.length <= 12) {
      return fullName;
    } else {
      return '${fullName.substring(0, 12)}...';
    }
  }





}