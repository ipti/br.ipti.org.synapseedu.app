import 'dart:math';

import 'dart:ui';

int questionIndex;
int listQuestionIndex;

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
Color colorFirstReceiverAccepted;
Color colorSecondReceiverAccepted;
Color colorThirdReceiverAccepted;

Random random = new Random();
var randomNumber = [0, 0, 0];
