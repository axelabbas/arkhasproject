import 'dart:convert';

import 'package:arkhasproject/util/usefulfunctions.dart';
import 'package:http/http.dart' as http;

class aliexpressItem {
  late String title;
  late String type;
  late String img;
  late double rateBase;
  late String strPrice;
  late double price;
  late String link;

  aliexpressItem(this.title, this.type, this.img, this.rateBase, this.strPrice,
      this.link, this.price);
}

searchAliExpress(query, pageNo) async {
  var headers = {
    "accept": "*/*",
    "accept-language": "en",
    "bx-v": "2.2.3",
    "cache-control": "no-cache",
    "content-type": "application/json;charset=UTF-8",
    "pragma": "no-cache",
    "sec-ch-ua":
        "\"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Windows\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    'cookie':
        'ali_apache_id=33.3.34.97.1677279836168.225802.7; xman_f=G0ewAecP2Ek7sd1jI4nBScipv8rPiltRrvT5rT1ZQfpWtGY79VmJTU2rym/0gIRM3IlvwThyoaULrp7llBCUjxzi5dRx+PDsRXFUSS/DLugtUDuQZMbdgQ==; xman_t=IH5MCS9/TLQTg+Ip65DxSCAfl+IAJ/yq8lOsKPhQPyuJxuvq/Qa8m2YRRIHICRTv; e_id=pt100; aeu_cid=35eac5ae66804063996b7cd74085fc95-1679149012510-06503-_Dn2Xzu7; traffic_se_co=%7B%7D; af_ss_a=1; af_ss_b=1; account_v=1; cna=TbScHGKic3sCAS/2gNexOiIa; _gid=GA1.2.926435041.1679149017; _gcl_au=1.1.2053077539.1679149017; _ym_uid=1673055881936426613; _ym_d=1679149018; xlly_s=1; ali_apache_track=; __e_inc=1; aep_history=keywords%5E%0Akeywords%09%0A%0Aproduct_selloffer%5E%0Aproduct_selloffer%091005004406811194%091005004406633497%0932847243564; __utma=3375712.18321086.1679149017.1679151404.1679151404.1; __utmz=3375712.1679151404.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); acs_usuc_t=x_csrf=uw58vcr8y0h3&acs_rt=717aaa6ae0344e6db5fcc1b4b99acbbb; _m_h5_tk=33fdb8ae7027caf9256ce96134d910b6_1679234010359; _m_h5_tk_enc=3d6477716d4c84ea25cf65a121ad5a69; _ym_isad=1; _ym_visorc=b; aep_usuc_f=site=glo&c_tp=USD&region=US&b_locale=en_US; ali_apache_tracktmp=; xman_us_f=x_locale=en_US&x_l=0&x_c_chg=0&x_as_i=%7B%22aeuCID%22%3A%2235eac5ae66804063996b7cd74085fc95-1679149012510-06503-_Dn2Xzu7%22%2C%22af%22%3A%222015%22%2C%22affiliateKey%22%3A%22_Dn2Xzu7%22%2C%22channel%22%3A%22AFFILIATE%22%2C%22cv%22%3A%221%22%2C%22isCookieCache%22%3A%22N%22%2C%22ms%22%3A%221%22%2C%22pid%22%3A%22701588724%22%2C%22tagtime%22%3A1679149012510%7D&acs_rt=4cc0a7c487f849b2b71b16abc5696ee6; intl_locale=en_US; AKA_A2=A; JSESSIONID=894BDF98BD5CFAA83961037D976E0AF4; RT="z=1&dm=aliexpress.com&si=9022714b-8199-42ad-ad4e-b5934274dfa1&ss=lfff14tt&sl=2&tt=1sv&obo=1&rl=1"; intl_common_forever=tCaUKLp4bGy6uHn1e29XateRsracmwrUmvEzABnZP4KLoOsTZGZhaw==; cto_bundle=wRVL819mME1sbnppbXVqQzRIQVAza0M0MldHVmhpJTJGQzZpUlhRN2oycmxROU1veVpjSm1rJTJCWkxEMWxtbERFUUlKZ3o3UGtPTjBSNjh0cTk1NFlkM2lpdnhqN0R2YWZxQXJmcHVtNVkxbnZWMmpFclRyNXk0MVVFUXklMkZpNlN6MEt6QlBmNnN6OTBOeUJqTGRsbWpLSW1NMTkxRmclM0QlM0Q; _gat=1; _ga=GA1.1.18321086.1679149017; _ga_VED1YSGNC7=GS1.1.1679231402.5.1.1679231856.0.0.0; isg=BLe3WVc4n5le8Ry6Nx2xGmuqRqsBfIvePEFMdAlm7waWuNb6EU2lLoWemgDmV2NW; l=fBgky8WrT3TBnsV3BO5Bnurza77TyQAb81PzaNbMiIEGa69hTw9QANCsEvLp7dtjQT52Ketr24w81dFX8YzLRK60MGLNyVbrLeJM8e__E-ZF.; tfstk=cYLdBFvayADnfLkl7wng4v_qD_LdZjMRCW6uyElV6V1mYgURit8DkwvtA_6VpfC..',
    "sec-fetch-site": "same-origin"
  };
  List<aliexpressItem> itemsList = [];
  var body = jsonEncode({
    "pageVersion": "984c9a58b6d16e5d8c31de9b899f058a",
    "target": "root",
    "data": {
      "SearchText": query,
      "catId": "0",
      "initiative_id": "SB_20230318070300",
      "spm": "a2g0o.home.1000002.0",
      "trafficChannel": "af",
      "g": "y",
      "page": pageNo,
      "origin": "y"
    },
    "eventName": "onChange",
    "dependency": []
  });
  String url = 'https://www.aliexpress.com/fn/search-pc/index';
  final respone = await http.post(Uri.parse(url), headers: headers, body: body);
  var apiResp = json.decode(respone.body);
  var items = apiResp["data"]["result"]["mods"]["itemList"]["content"];
  for (Map ele in items!) {
    var productId = ele['productId'];
    var itemLink = "https://www.aliexpress.com/item/$productId.html";
    var strPrice = ele["prices"]['salePrice']['formattedPrice'];
    var title = ele["title"]['displayTitle'];
    double rateBase = 0;

    if (ele.containsKey("evaluation")) {
      rateBase = ele["evaluation"]["starRating"].toDouble();
    }

    // var ratesCount = int.tryParse(eleHtml
    //         .querySelector("div > span > a > span")
    //         ?.innerHtml
    //         .trim()
    //         .replaceAll("(", "")
    //         .replaceAll(")", "") ??
    //     "");

    var img = "https:" + ele['image']['imgUrl'];

    if (title == null) {
      continue;
    }
    // ratesCount ??= 0;

    if (strPrice == null) {
      continue;
    }
    double price = stringToPrice(strPrice);
    
    itemsList.add(aliexpressItem(
        title, "Ali Express", img, rateBase, strPrice, itemLink, price));
  }
  return itemsList;
}
