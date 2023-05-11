import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class ebayItem {
  late String title;
  late String type;
  late String img;
  late double rateBase;
  late String price;

  ebayItem(this.title, this.type,this.img, this.rateBase, this.price);
}

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
  List<ebayItem> itemsList = [];
  String url = "https://www.ebay.com/sch/i.html?_nkw=$query&_pgn=$pageNo";
  final respone = await http.get(Uri.parse(url), headers: headers);
  dom.Document html = dom.Document.html(respone.body);
  String selector = ".srp-results.srp-list.clearfix";
  List? items = html
      .querySelector(selector)
      ?.children
      .map((e) => e.innerHtml.trim())
      .toList();
  for (final ele in items!) {
    dom.Document eleHtml = dom.Document.html(ele);
    var price = eleHtml.querySelector(".s-item__price")?.text;
    
    if (price == null) {
      price = "price not found";
    }

    var title = eleHtml.querySelector(".s-item__title > span")?.text;
    var rateBase = double.tryParse(
        eleHtml.querySelector(".x-star-rating > span")?.text.split(" ")[0] ??
            "");
    // var ratesCount = int.tryParse(eleHtml
    //         .querySelector("div > span > a > span")
    //         ?.innerHtml
    //         .trim()
    //         .replaceAll("(", "")
    //         .replaceAll(")", "") ??
    //     "");

    var img = eleHtml
        .querySelector(".s-item__image-wrapper > img")
        ?.attributes["src"]!
        .trim();

    if (title == null) {
      continue;
    }
    rateBase ??= 0;

    // ratesCount ??= 0;

    img ??= "NOT FOUND";
    itemsList.add(ebayItem(title, "Ebay",img, rateBase, price));
  }
  return itemsList;
}
