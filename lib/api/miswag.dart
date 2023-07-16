import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:arkhasproject/api/itemClass.dart';
import 'package:arkhasproject/util/usefulfunctions.dart';
import 'package:http/http.dart' as http;
// import 'package:beautiful_soup_dart/beautiful_soup.dart';
// import "dart:developer";

searchMiswag(query, pageNo) async {
  var headers = {
    "accept": "*/*",
    "accept-language": "en",
    "cache-control": "no-cache",
    "content-type": "application/x-www-form-urlencoded",
    "pragma": "no-cache",
    "sec-ch-ua":
        "\"Not.A/Brand\";v=\"8\", \"Chromium\";v=\"114\", \"Google Chrome\";v=\"114\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Windows\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "cross-site"
  };
  List<item> itemsList = [];
  String body = '''{
    "requests": [
      {
        "indexName": "items",
        "params":
            "facets=%5B%22l_names.l2.AR%22%2C%22l_names.l3.AR%22%2C%22l_names.l4.AR%22%2C%22variations.color_code%22%2C%22brand.AR%22%2C%22sizes%22%5D&highlightPostTag=__%2Fais-highlight__&highlightPreTag=__ais-highlight__&maxValuesPerFacet=20&page=$pageNo&query=$query&tagFilters="
      },
      {
        "indexName": "items",
        "params":
            "clickAnalytics=true&facets=%5B%22l_names.l2.AR%22%2C%22l_names.l3.AR%22%2C%22l_names.l4.AR%22%2C%22variations.color_code%22%2C%22brand.AR%22%2C%22sizes%22%5D&highlightPostTag=__%2Fais-highlight__&highlightPreTag=__ais-highlight__&hitsPerPage=5&maxValuesPerFacet=20&page=$pageNo&query=$query&tagFilters="
      }
    ]
  }''';
  String url =
      "https://mhvrrwwor7-dsn.algolia.net/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20JavaScript%20(4.18.0)%3B%20Browser%20(lite)%3B%20instantsearch.js%20(4.56.5)%3B%20Vue%20(2.7.14)%3B%20Vue%20InstantSearch%20(3.9.0)%3B%20JS%20Helper%20(3.13.3)&x-algolia-api-key=37c123903276a13cb2fdf126c5c61500&x-algolia-application-id=MHVRRWWOR7";
  // try {
  final respone = await http.post(Uri.parse(url), headers: headers, body: body);

  var js = json.decode(respone.body);
  var listOfProducts = js["results"][0]["hits"];
  if (listOfProducts != null) {
    for (final ele in listOfProducts) {
      var title = ele['title']["EN"]
          .replaceAll("<b>", "")
          .replaceAll("</b>", "")
          .replaceAll("<strong>", "")
          .replaceAll("</strong>", "");
      var itemLink = ele['url'];
      var type = "Miswag";
      var img = ele["image"];
      int rateBase = 0;

      if (ele["rating"] == null) {
        rateBase = 0;
      } else {
        rateBase = ele["rating"];
      }
      var f = NumberFormat("###,###", "en_US");

      var strPrice = "IQD " + f.format(ele["price"]["numeric_value"]);

      double price = stringToPrice(strPrice);

      itemsList.add(item(
          title, type, img, rateBase.toDouble(), strPrice, itemLink, price));
    }
  }
  // } catch (e) {
  //   print(e);
  // }

  // BeautifulSoup bs = BeautifulSoup(respone.body);
  // var script = bs.findAll("script")[32].text.trim();
  return itemsList;
}
