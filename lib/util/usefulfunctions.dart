double stringToPrice(String? price) {
  if (price == null) {
    print("Is null");
    price = "0";
  }
  double intPrice = 0;
  price = price.replaceAll("\$", "");
  price = price.replaceAll("US ", "");
  price = price.replaceAll("USD ", "");
  price = price.replaceAll("USD ", "");
  price = price.replaceAll("USD&nbsp;", "");
  price = price.replaceAll(",", "");
  price = price.replaceAll("٬", "");
  price = price.replaceAll("ريال", "");
  price = price.replaceAll("IQD ", "");
  if (price.contains("to")) {
    var prices = price.split(" to ");
    var price1 = double.parse(prices[0]);
    var price2 = double.parse(prices[1]);
    intPrice = averagePrice(price1, price2);
  } else if (price.contains("-")) {
    var prices = price.split("-");
    var price1 = double.parse(prices[0]);
    var price2 = double.parse(prices[1]);
    intPrice = averagePrice(price1, price2);
  } else {
    print(price);

    intPrice = double.parse(price);
  }

  return intPrice;
}

double averagePrice(double a, double b) {
  return (a + b) / 2;
}
