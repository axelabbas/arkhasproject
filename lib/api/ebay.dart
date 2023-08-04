import 'package:arkhasproject/api/itemClass.dart';
import 'package:arkhasproject/util/usefulfunctions.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

searchEbay(query, pageNo) async {
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
  String url = "https://www.ebay.com/sch/i.html?_nkw=$query&_pgn=$pageNo";
  try {
    final respone = await http.get(Uri.parse(url), headers: headers);
    dom.Document html = dom.Document.html(respone.body);
    String selector = ".srp-results.srp-list.clearfix";
    List? items = html
        .querySelector(selector)
        ?.children
        .map((e) => e.innerHtml.trim())
        .toList();
    if (items != null) {
      for (final ele in items) {
        dom.Document eleHtml = dom.Document.html(ele);
        var strPrice = eleHtml.querySelector(".s-item__price")?.text;

        double price = stringToPrice(strPrice);

        var itemLink =
            eleHtml.querySelector(".s-item__link")?.attributes['href'];

        var title = eleHtml.querySelector(".s-item__title > span")?.text;
        var rateBase = double.tryParse(eleHtml
                .querySelector(".x-star-rating > span")
                ?.text
                .split(" ")[0] ??
            "");

        var img = eleHtml
            .querySelector(".s-item__image-wrapper > img")
            ?.attributes["src"]!
            .trim();

        if (title == null) {
          continue;
        }
        if (itemLink == null) {
          continue;
        }
        rateBase ??= 0;
        itemsList
            .add(item(title, "Ebay", img, rateBase, strPrice, itemLink, price));
      }
    }
  } catch (e) {
    print(e);
    throw (e);
  }
  return itemsList;
}
