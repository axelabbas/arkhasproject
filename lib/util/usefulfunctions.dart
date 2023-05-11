double stringToPrice(String price) {
  double intPrice = 0;
  price = price.replaceAll("\$", "");
  price = price.replaceAll("US ", "");
  price = price.replaceAll(",", "");
  if (price.contains("to")) {
    var prices = price.split(" to ");
    print(prices);

    var price1 = double.parse(prices[0]);
    var price2 = double.parse(prices[1]);
    intPrice = averagePrice(price1, price2);
  }
  if (price.contains("-")) {
    var prices = price.split("-");
    print(prices);
    var price1 = double.parse(prices[0]);
    var price2 = double.parse(prices[1]);
    intPrice = averagePrice(price1, price2);
  }

  return intPrice;
}

double averagePrice(double a, double b) {
  return (a + b) / 2;
}
