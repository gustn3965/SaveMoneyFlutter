import 'dart:math';

int RandomInt() {
  Random random = Random(DateTime.now().millisecondsSinceEpoch);
  int randomNumber = random.nextInt(100000);
  return randomNumber;
}
