import 'dart:convert';

import 'package:arkhasproject/Models/itemClass.dart';
import 'package:flutter/material.dart';
import 'package:arkhasproject/Models/util/usefulfunctions.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class scrapedItemsProvider with ChangeNotifier {
  List<String> platforms = [
    "All",
    "Amazon",
    "AliBaba",
    "Tamata",
    "AliExpress",
    "Ebay",
    "Miswag"
  ];
  List<scrapedItem> scrapedItems = [];

  List<scrapedItem> amazonItems = [];
  List<scrapedItem> ebayItems = [];
  List<scrapedItem> tamataItems = [];
  List<scrapedItem> alibabaItems = [];
  List<scrapedItem> aliexpressItems = [];
  List<scrapedItem> miswagItems = [];

  List<scrapedItem> currentItems = [];
  String error = '';
  String currentlyLoading = '';
  String selectedCategory = 'All';
  bool isLoading = true;
  int group = 0;

  getAllResults(query, pageNo) async {
    isLoading = true;

    setLoading("Alibaba");
    await fetchDataFromAlibaba(query, pageNo);

    setLoading("Miswag");
    await fetchDataFromMiswag(query, pageNo);

    setLoading("Tamta");
    await fetchDataFromTamata(query, pageNo);

    setLoading("AliExpress");
    await fetchDataFromAliexpress(query, pageNo);

    setLoading("Amazon");
    await fetchDataFromAmazon(query, pageNo);

    setLoading("Ebay");
    await fetchDataFromEbay(query, pageNo);

    isLoading = false;
    currentItems = scrapedItems;
    print(error);
    notifyListeners();
  }

  setLoading(String site) {
    currentlyLoading = site;
  }

  setGroup(value) {
    group = value;
    notifyListeners();
  }

  sortByRate() {
    if (group == 1) {
      currentItems.sort((a, b) => a.rateBase.compareTo(b.rateBase));
    } else {
      currentItems.sort((b, a) => a.rateBase.compareTo(b.rateBase));
    }
    notifyListeners();
  }

  sortByPrice() {
    if (group == 1) {
      currentItems.sort((a, b) => a.price.compareTo(b.price));
    } else {
      currentItems.sort((b, a) => a.price.compareTo(b.price));
    }
    notifyListeners();
  }

  setCategory(selectedType) {
    print(selectedType);
    if (!(selectedType == 'All')) {
      currentItems = scrapedItems
          .where((element) => element.type == selectedType)
          .toList();
      print(currentItems);
    } else {
      currentItems = scrapedItems;
    }
    selectedCategory = selectedType;
    notifyListeners();
  }

  fetchDataFromMiswag(query, pageNo) async {
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
    List<scrapedItem> itemsList = [];
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
    try {
      final respone =
          await http.post(Uri.parse(url), headers: headers, body: body);

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

          itemsList.add(scrapedItem(title, type, img, rateBase.toDouble(),
              strPrice, itemLink, price));
        }
      }
      miswagItems = itemsList;
      scrapedItems.addAll(miswagItems);
    } catch (e) {
      error = "Miswag Error: ${e.toString()}";
    }

    return itemsList;
  }

  fetchDataFromAliexpress(query, pageNo) async {
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
    List<scrapedItem> itemsList = [];

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
    try {
      String url = 'https://www.aliexpress.com/fn/search-pc/index';
      final respone =
          await http.post(Uri.parse(url), headers: headers, body: body);
      var apiResp = json.decode(respone.body);
      var items = apiResp["data"]["result"]["mods"]["itemList"]["content"];
      if (items != null)
        // ignore: curly_braces_in_flow_control_structures
        for (Map ele in items) {
          var strPrice = "";
          var productId = ele['productId'];
          var itemLink = "https://www.aliexpress.com/item/$productId.html";
          try {
            strPrice = ele["prices"]['salePrice']['formattedPrice'];
          } on NoSuchMethodError {
            print(ele);
          }
          var title = ele["title"]['displayTitle'];
          double rateBase = 0;

          if (ele.containsKey("evaluation")) {
            rateBase = ele["evaluation"]["starRating"].toDouble();
          }

          var img = "https:" + ele['image']['imgUrl'];
          double price = stringToPrice(strPrice);

          itemsList.add(scrapedItem(
              title, "AliExpress", img, rateBase, strPrice, itemLink, price));
        }
      aliexpressItems = itemsList;
      scrapedItems.addAll(aliexpressItems);
    } catch (e) {
      error = "AliExpress Error: ${e.toString()}";
    }
    notifyListeners();
  }

  fetchDataFromAlibaba(query, pageNo) async {
    try {
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
        'cookie':
            't=98b73bb0841acfb72ba5533ab40b1746; ali_apache_id=33.3.27.149.1679148621482.425077.4; cna=TbScHGKic3sCAS/2gNexOiIa; seo_f=trafc_i=seo; ali_apache_track=""; xman_us_f=x_l=0; xlly_s=1; uns_unc_f=trfc_i=safcps^j19u1ne5^f5bqkl37^1grqgtn1e; __e_inc=1; __cdc2FsZS5hbGliYWJhLmNvbQ===1; __cda29yZWFuLmFsaWJhYmEuY29t=1; ali_apache_tracktmp=""; cookie2=a1b472fe55ec4107b24d349ab3eae64d; _tb_token_=ff7367155e38f; acs_usuc_t=acs_rt=bf69fcfd96ac4c7dac8f811939ac0858; xman_t=VD4uyM8zFQoPxNs+o53y78TYadDTgTUJ70SEn+ZQCl0KEYBH7NhM0IsgokAnAi4lfbjEMXvhOwcWjiC6g52CKOB0W/v/l96i; XSRF-TOKEN=24726df3-9267-4aef-99d7-0297609f90ed; _samesite_flag_=true; ug_se_c=free_1679231525840; sc_g_cfg_f=sc_b_locale=en_US&sc_b_site=US&sc_b_currency=USD; xman_f=d7pNoqNSX2AHNez3wgVg8jn9InlCpB+hlZycQQZmHp6548UO6NKSyCQ/+DCpvPf+ArTRdieWg6v3v2/7Iy/ww84xZB/TgE/w3+1Z2vO8Al6d8yQbNARqOw==; tfstk=c2JVBdwcixH2AfKtJTXwTuM7EdffaexDj8SCiVMa1HBj67fP8s28WgcnrgS_4Pfc.; l=fBQ6wwzRNTsgDsRQBO5Churza77tPBOb81PzaNbMiIEGa6TRKF2e8OCsEvTJjdtjQTf27F-r24w81dHDSaadgyxoZasjui-t1YJ6-52Smm1..; isg=BEFBrn3KwYdF6y2x1RTRQgbOUI1bbrVghvMaUqORFcinimBc7L2pMDzIbObMhU2Y',
        "user-agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36",
      };
      List<scrapedItem> itemsList = [];
      String url =
          "https://en.alibaba.com/trade/search?spm=a2700.galleryofferlist.0.0.561f50bbOksSmA&fsb=y&IndexArea=product_en&keywords=$query&tab=all&viewtype=L&&page=${pageNo + 1}";
      final respone = await http.get(Uri.parse(url), headers: headers);
      var js = json.decode(respone.body
          .toString()
          .split("window.__page__data__config = ")[1]
          .split("window.__page__data = window.__page__data__config.props")[0]);
      // print(json.encode(js));
      var listOfProducts = js["props"]["offerResultData"]["offers"];
      if (listOfProducts != null) {
        for (final ele in listOfProducts) {
          var title = ele["title"]
              .replaceAll("<b>", "")
              .replaceAll("</b>", "")
              .replaceAll("<strong>", "")
              .replaceAll("</strong>", "");
          print(title);
          var itemLink = ele["productUrl"].replaceAll("//www.", "www.");
          var type = "AliBaba";
          var img = "https:" + ele["mainImage"];
          print(img);
          double rateBase = 0;

          if (ele["reviewsScore"] == null) {
            rateBase = 0;
          } else {
            rateBase = double.tryParse(ele["reviewsScore"])!;
          }
          var strPrice = ele["price"];
          double price = stringToPrice(strPrice);

          itemLink = "https://$itemLink";
          itemsList.add(scrapedItem(
              title, type, img, rateBase, strPrice, itemLink, price));
        }
      }
      print(itemsList);
      alibabaItems = itemsList;
      scrapedItems.addAll(alibabaItems);
    } catch (e) {
      error = "AliBaba Error: ${e.toString()}";
    }
    notifyListeners();
  }

  fetchDataFromTamata(query, pageNo) async {
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
    List<scrapedItem> itemsList = [];
    String url =
        "https://www.tamata.com/catalogsearch/result/index/?q=$query&p=$pageNo&shopbyAjax=1";
    try {
      final respone = await http.get(Uri.parse(url), headers: headers);
      dom.Document html = dom.Document.html(respone.body);
      String selector = "div.products.wrapper.grid.products-grid > ol";
      List? items = html
          .querySelector(selector)
          ?.children
          .map((e) => e.innerHtml.trim())
          .toList();
      if (items != null) {
        for (final ele in items) {
          dom.Document eleHtml = dom.Document.html(ele);
          var strPrice = eleHtml.querySelector("span.price")?.text;

          double price = stringToPrice(strPrice);

          var itemLink = eleHtml
              .querySelector(
                  "div.product.details.product-item-details > strong > a")
              ?.attributes['href'];

          var title = eleHtml
              .querySelector(
                  "div.product.details.product-item-details > strong > a")
              ?.text;

          var rateBase = 0.0;

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

          itemsList.add(scrapedItem(
              title, "Tamata", img, rateBase, strPrice, itemLink, price));
        }
      }
      tamataItems = itemsList;
      scrapedItems.addAll(tamataItems);
    } catch (e) {
      error = "Tamata Error: ${e.toString()}";
    }
    notifyListeners();
  }

  fetchDataFromEbay(query, pageNo) async {
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
    List<scrapedItem> itemsList = [];
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
          itemsList.add(scrapedItem(
              title, "Ebay", img, rateBase, strPrice, itemLink, price));
        }
      }
      ebayItems = itemsList;
      scrapedItems.addAll(ebayItems);
    } catch (e) {
      error = "Ebay Error: ${e.toString()}";
    }
    notifyListeners();
  }

  fetchDataFromAmazon(query, pageNo) async {
    try {
      var headers = {
        "accept":
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "accept-encoding": "gzip, deflate, br",
        "accept-language": "en",
        "cache-control": "max-age=0",
        'Cookie':
            'csm-sid=517-1787060-5260737; x-amz-captcha-1=1691282274046246; x-amz-captcha-2=INYRluJjLLvDgWB444O8cQ==; session-id=258-9750928-6716466; session-id-time=2082787201l; ubid-acbuk=257-6253439-7622819; session-token="bSDAoffYN9cbmhkg+q0LCSHx8leUtTsIRfX6WTLPuNoQ659i68iRBYU+R22cNDtBC+GM5nagHWY23FJu1Oc6teDyeorGHPAa+7icMbf59VEQnhYoRvuZ9al/iUHnrK2VWRXC+DoGbkBuNsO/yES1kxOAO9nDSvmYDY4qWKyvqL7xcqQGXzMdacNKw+AWVeN/tktB9N8inegJ5JUnH4g+sE2CYKyXkrkXTKiQAUiXsFE="; i18n-prefs=USD; csm-hit=tb:GS67EWXDC4E5503MTBCD+s-C89J1HN1YCGJ8YEDA0P3|1691322739988&t:1691322739989&adb:adblk_yes',
        "device-memory": "8",
        //sp-cdn is for delivery place
        "downlink": "9",
        "dpr": "1.25",
        "ect": "4g",
        "rtt": "200",
        "sec-ch-device-memory": "8",
        "sec-ch-dpr": "1.25",
        "sec-ch-ua":
            "\"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"Windows\"",
        "sec-ch-ua-platform-version": "\"10.0.0\"",
        "sec-ch-viewport-width": "847",
        "sec-fetch-dest": "document",
        "sec-fetch-mode": "navigate",
        "sec-fetch-site": "same-origin",
        "sec-fetch-user": "?1",
        "upgrade-insecure-requests": "1",
        "user-agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36",
        "viewport-width": "847"
      };
      List<scrapedItem> itemsList = [];
      String url =
          "https://www.amazon.co.uk/s?k=$query&page=${pageNo}&currency=USD";
      final respone = await http.get(Uri.parse(url), headers: headers);
      dom.Document html = dom.Document.html(respone.body);
      String selector = ".s-main-slot";
      List? items = html
          .querySelector(selector)
          ?.children
          .map((e) => e.innerHtml.trim())
          .toList();
      if (items != null) {
        items.removeAt(0);
        items.asMap().forEach((index, ele) {
          dom.Document eleHtml = dom.Document.html(ele);
          var strPrice = eleHtml
              .querySelector("span.a-price > span.a-offscreen")
              ?.innerHtml
              .trim()
              .replaceAll("&nbsp;", " ");
          if (strPrice == null) {
            strPrice = eleHtml
                .querySelector(
                    "a.a-size-base > span.a-price > span.a-offscreen")
                ?.text
                .trim()
                .replaceAll("\u{00A0}", " ");
            if (strPrice == null) {
              strPrice = '0.0';
            }
          }
          var title = eleHtml
              .querySelector("div.a-section > h2 > a > span")
              ?.innerHtml
              .trim();
          var rateBase = stringToPrice(eleHtml
              .querySelector("i.a-icon-star-small > span")
              ?.text
              .split(" out")[0]);
          var link = eleHtml
              .querySelector(".a-section > .s-image")
              ?.parent!
              .parent!
              .attributes["href"]!
              .trim();
          link = "https://www.amazon.co.uk${link}";
          var img = eleHtml
              .querySelector(".a-section > .s-image")
              ?.attributes["src"]!
              .trim();

          if (title != null) {
            double price = stringToPrice(strPrice);
            itemsList.add(scrapedItem(
                title, "Amazon", img, rateBase, strPrice, link, price));
          }
          // rateBase ??= 0;
        });
      }

      amazonItems = itemsList;
      scrapedItems.addAll(amazonItems);
    } catch (e) {
      error = "Amazon Error: ${e.toString()}";
    }
    notifyListeners();
  }
}
