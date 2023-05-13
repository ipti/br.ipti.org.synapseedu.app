import 'dart:math';

import 'dart:ui';

import '../model.dart';

int? questionIndex;
int? cobjectIndex;

bool isCorrect = false;
bool accepted = false;

//<=======RECEIVER VALUES=======>
int valueFirstReceiver = 0;
int valueSecondReceiver = 0;
int valueThirdReceiver = 0;

//<==========showSender=========>
bool showFirstSender = true;
bool showSecondSender = true;
bool showThirdSender = true;

//<========linkreceiver=========>
String urlFirstBox = '';
String urlSecondBox = '';
String urlThirdBox = '';

//<========colorReceiver========>
late Color colorFirstReceiverAccepted;
late Color colorSecondReceiverAccepted;
late Color colorThirdReceiverAccepted;

Random random = new Random();
var randomNumber = [0, 0, 0];

void updateReceiver(String url, int index, Question question) {
  switch (index) {
    case 1:
      urlFirstBox = url;
      break;
    case 2:
      urlSecondBox = url;
      break;
    case 3:
      urlThirdBox = url;
      break;
  }
}

void tradeValue(int receiverIndex, int data, Function setState) {
  switch (receiverIndex) {
    case 1:
      if (valueFirstReceiver != 0) {
        updateSender(valueFirstReceiver, setState);
        valueFirstReceiver = data;
      } else if (valueSecondReceiver == data) {
        valueSecondReceiver = 0;
        valueFirstReceiver = data;
        updateSender(2, setState);
      } else if (valueThirdReceiver == data) {
        valueThirdReceiver = 0;
        valueFirstReceiver = data;
        updateSender(3, setState);
      } else {
        valueFirstReceiver = data;
      }
      break;
    case 2:
      if (valueSecondReceiver != 0) {
        updateSender(valueSecondReceiver, setState);
        valueSecondReceiver = data;
      } else if (valueFirstReceiver == data) {
        valueFirstReceiver = 0;
        valueSecondReceiver = data;
        updateSender(1, setState);
      } else if (valueThirdReceiver == data) {
        valueThirdReceiver = 0;
        valueSecondReceiver = data;
        updateSender(3, setState);
      } else {
        valueSecondReceiver = data;
      }
      break;
    case 3:
      if (valueThirdReceiver != 0) {
        updateSender(valueThirdReceiver, setState);
        valueThirdReceiver = data;
      } else if (valueFirstReceiver == data) {
        valueFirstReceiver = 0;
        valueThirdReceiver = data;
        updateSender(1, setState);
      } else if (valueSecondReceiver == data) {
        valueSecondReceiver = 0;
        valueThirdReceiver = data;
        updateSender(2, setState);
      } else {
        valueThirdReceiver = data;
      }
      break;
  }
}

void verifyIsCorrect() {
  if (valueFirstReceiver == 1 &&
      valueSecondReceiver == 2 &&
      valueThirdReceiver == 3) {
    isCorrect = true;
  }
}

void updateSender(int index, Function setState) {
  setState(() {
    switch (index) {
      case 1:
        showFirstSender = !showFirstSender;
        break;
      case 2:
        showSecondSender = !showSecondSender;
        break;
      case 3:
        showThirdSender = !showThirdSender;
        break;
    }
  });
}

void clearReceiver(int index) {
  if (valueFirstReceiver == index) {
    valueFirstReceiver = 0;
    urlFirstBox = '';
  } else if (valueSecondReceiver == index) {
    valueSecondReceiver = 0;
    urlSecondBox = '';
  } else {
    valueThirdReceiver = 0;
    urlThirdBox = '';
  }
}
