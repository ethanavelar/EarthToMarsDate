import 'dart:html';
import 'dart:math';
int day, month, year, marsDay, marsYear;
String marsMonth;
const List daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; // DAYS IN EARTH MONTHS
const List MARS_SOLS_IN_MONTH = [61, 65, 66, 65, 60, 54, 50, 47, 46, 48, 51, 56]; // SOLS (DAYS) IN MARTIAN MONTHS
const List<String> MARS_MONTHS_NAMES = ['Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpius', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces', 'Aries', 'Taurus'];
const int DAYS_IN_YEAR = 365; // AMOUNT OF DAYS IN EARTH YEAR
const int MARS_DAY_IN_YEAR = 669; // AMOUNT OF SOLS (DAYS) IN A MARTIAN YEAR
const double TO_MARS_YEAR_CONSTANT = 8/15; // THE CONSTANT USED IN THE CALCULATION PROVIDED BY ROBERT ZUBRIN

void toMarsDate(double earthDateDec) {
  double marsYearToDec = 1 + (TO_MARS_YEAR_CONSTANT * (earthDateDec - 1961)); // EQUATION FOR DATE PROVIDED BY ROBERT ZUBRIN
  marsYearToDec = num.parse(marsYearToDec.toStringAsFixed(3)); // ROUND TO THREE DECIMAL POINTS
  marsYear = marsYearToDec.toInt(); // SLICE OFF DECIMAL PLACES WITHOUT ROUNDING TO GET YEAR
  double temp = marsYearToDec - marsYear; // ISOLATE DECIMALS FOR CONVERSION
  int totalDays = (temp * 669).toInt(); // GET DAY FIRST IN DOUBLE THEN SLICE OFF DECIMAL
  marsDay = totalDays;
  //int tempMonth = 0;
  int i = 0; // ISOLATE ITERABLE
  while ( totalDays > 0) {
    totalDays -= MARS_SOLS_IN_MONTH[i];
    //tempMonth = MARS_SOLS_IN_MONTH[i];
    i++;
  } // WHILE TOTAL DAYS IS GREATER THAN ZERO SUBTRACT NUMBERS FROM LIST
  //window.alert('$totalDays');
  i -= 1;
  totalDays += MARS_SOLS_IN_MONTH[i];
  //window.alert('$totalDays');
  marsMonth = MARS_MONTHS_NAMES[i];
  querySelector('#daysIntoMonth').innerHtml = "$totalDays";
  querySelector('#displayDay').innerHtml = "$marsDay";
  querySelector('#displayMonth').innerHtml = "$marsMonth";
  querySelector('#displayYear').innerHtml = "$marsYear";
}

void toDec(int year, int month, int day) {
  int totalDays = 0; // DEFAULT IS ZERO

  for (int i = 0; i <= month - 1; i++) {
    totalDays += daysInMonth[i];
  } // ADD DAYS UNTIL THE MONTH PROVIDED
  if (day == 31) { // TAKE A SECOND LOOK AT THIS!!!!!!!!!!!
    //window.alert('EARTH DAY EQUAL 31st!');
  } else if (day < 31) { // WHEN THE DAY IS LESS THAN 31 WE DON'T ADD THE AMOUNT OF DAYS IN THAT MONTH BECAUSE THE MONTH IS NOT COMPLETE
    totalDays -= daysInMonth[month - 1];
    totalDays += day; // INSTEAD WE ADD THE NUMBER OF DAYS WE ARE CURRENTLY AT IN THE MONTH
    //window.alert('EARTH DAY IS LESS THAN 31');
  }
  //window.alert('$totalDays');
  var daysToDec = totalDays / DAYS_IN_YEAR; // TURN THE DAYS IN A YEAR INTO A FRACTION OF THE YEAR TO GET DATE DECIMAL
  var dateToDec = (year + daysToDec); // ADD THAT DECIMAL TO THE YEAR IN ORDER TO GET COMPLETE DATE DECIMAL
  toMarsDate(dateToDec); // PASS THE DATA TO FUNCTION TO HANDLE THE MARS DATE
}

void toList(MouseEvent e) {
  var inputDate = (querySelector('#date') as InputElement).value; // GETS DATE FROM INPUT
  List inList = inputDate.split("-"); // SPLIT THE DATE INTO A LIST [YEAR, MONTH, DAY]
  year = int.parse(inList[0]); // SET YEAR TO YEAR
  month = int.parse(inList[1]);
  day = int.parse(inList[2]);
  toDec(year, month, day); // NOW VARIABLES ARE INITIALIZED SEND TO FUNCTION TO TURN DATE INTO DECIMAL WITH YEAR
}

void main() {
  querySelector('#button').onClick.listen(toList); // BUTTON CLICK SEND TO TOLIST
}
