int stringToPrice(String price) {
  int intPrice = 0;
  price = price.replaceAll("\$", "");
  if (price.contains("to")) {
    var prices = price.split(" to ");
    var price1 = int.parse(prices[0]);
    var price2 = int.parse(prices[1]);
    intPrice = averagePrice(price1, price2);
  }
  if (price.contains("-")) {
    var prices = price.split("-");
    var price1 = int.parse(prices[0]);
    var price2 = int.parse(prices[1]);
    intPrice = averagePrice(price1, price2);
  }

  return intPrice;
}

int averagePrice(int a, int b) {
  return (a + b) ~/ 2;
}
