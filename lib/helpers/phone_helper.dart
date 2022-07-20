String phoneNumberHelper(String phoneNumber) {
  if (phoneNumber.length == 12) {
    return phoneNumber;
  } else if (phoneNumber.length == 10) {
    return phoneNumber.replaceRange(0, 1, '254');
  } else {
    return '254$phoneNumber';
  }
}
