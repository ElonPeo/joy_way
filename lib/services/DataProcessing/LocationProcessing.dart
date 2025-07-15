class LocationProcessing {
  static String removeVietnameseTones(String str) {
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'đ'), 'd');
    str = str.replaceAll(RegExp(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]'), 'A');
    str = str.replaceAll(RegExp(r'[ÈÉẸẺẼÊỀẾỆỂỄ]'), 'E');
    str = str.replaceAll(RegExp(r'[ÌÍỊỈĨ]'), 'I');
    str = str.replaceAll(RegExp(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]'), 'O');
    str = str.replaceAll(RegExp(r'[ÙÚỤỦŨƯỪỨỰỬỮ]'), 'U');
    str = str.replaceAll(RegExp(r'[ỲÝỴỶỸ]'), 'Y');
    str = str.replaceAll(RegExp(r'Đ'), 'D');
    return str;
  }

  static String cleanLocationName(String? input) {
    if (input == null) return '';
    final toRemove = ['Thành phố', 'Tỉnh', 'Quận', 'Huyện', 'Phường', 'Xã', 'Thị xã'];
    for (var word in toRemove) {
      input = input!.replaceAll(RegExp(word, caseSensitive: false), '');
    }
    return removeVietnameseTones(input!.trim());
  }

  static List<String> extractCleanedComponents(String fullAddress) {
    List<String> components = fullAddress.split(',').map((e) => e.trim()).toList();
    List<String> cleanedComponents = [];
    for (String comp in components) {
      if (comp.isNotEmpty) {
        String cleaned = cleanLocationName(comp);
        if (cleaned.isNotEmpty) {
          cleanedComponents.add(cleaned);
        }
      }
    }
    return cleanedComponents;
  }






}