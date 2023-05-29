//

import 'package:arkhasproject/api/itemClass.dart';
import 'package:arkhasproject/util/usefulfunctions.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

searchTamata(query, pageNo) async {
  var headers = {
    "accept":
        "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    "accept-encoding": "gzip, deflate, br",
    "accept-language": "en",
    "cache-control": "max-age=0",
    "sec-ch-ua":
        '"Not?A_Brand";v="8", "Chromium";v="108", "Google Chrome";v="108"',
    "sec-ch-ua-platform": "Windows",
    "sec-ch-ua-platform-version": "10.0.0",
    "user-agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
  };
  List<item> itemsList = [];
  String url =
      "https://www.tamata.com/catalogsearch/result/index/?q=$query&p=$pageNo&shopbyAjax=1";
  final respone = await http.get(Uri.parse(url), headers: headers);
  dom.Document html = dom.Document.html(respone.body);
  String selector = "div.products.wrapper.grid.products-grid > ol";
  List? items = html
      .querySelector(selector)
      ?.children
      .map((e) => e.innerHtml.trim())
      .toList();
  if (items != null)
    for (final ele in items) {
      dom.Document eleHtml = dom.Document.html(ele);
      var strPrice = eleHtml.querySelector("span.price")?.text;

      if (strPrice == null) {
        strPrice = "price not found";
      }

      double price = stringToPrice(strPrice);

      var itemLink = eleHtml
          .querySelector(
              "div.product.details.product-item-details > strong > a")
          ?.attributes['href'];

      var title = eleHtml
          .querySelector(
              "div.product.details.product-item-details > strong > a")
          ?.text;
      // var rateBase = double.tryParse(
      //     eleHtml.querySelector(".x-star-rating > span")?.text.split(" ")[0] ??
      //         "");
      var rateBase = 0.0;
      // var ratesCount = int.tryParse(eleHtml
      //         .querySelector("div > span > a > span")
      //         ?.innerHtml
      //         .trim()
      //         .replaceAll("(", "")
      //         .replaceAll(")", "") ??
      //     "");

      var img = eleHtml
          .querySelector("div.prod-list-imgbox > a > span > span > img")
          ?.attributes["src"]!
          .trim();

      if (title == null) {
        continue;
      }
      if (itemLink == null) {
        continue;
      }
      // rateBase ??= 0;

      // ratesCount ??= 0;
      img ??= "NOT FOUND";
      itemsList
          .add(item(title, "Tamata", img, rateBase, strPrice, itemLink, price));
    }
  return itemsList;
}
