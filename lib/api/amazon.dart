import 'package:arkhasproject/util/usefulfunctions.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

import 'itemClass.dart';

searchAmazon(query, pageNo) async {
  var headers = {
    "accept":
        "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "accept-encoding": "gzip, deflate, br",
    "accept-language": "en",
    "cache-control": "max-age=0",
    "cookie":
        "session-id=135-9033544-0390703; ubid-main=134-5264130-6968240; pay-session-id=afab6b24bcb7c7f5e4433776f63241cb; _mkto_trk=id:846-RQB-314&token:_mch-amazon.com-1664595465865-78671; AMCV_A7493BC75245ACD20A490D4D%40AdobeOrg=-2121179033%7CMCIDTS%7C19267%7CMCMID%7C87987423969983405970631597656196772523%7CMCAAMLH-1665200265%7C6%7CMCAAMB-1665200265%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1664602666s%7CNONE%7CMCAID%7CNONE%7CvVersion%7C5.3.0; aws-target-data=%7B%22support%22%3A%221%22%7D; aws-target-visitor-id=1664982482792-15413.37_0; aws-ubid-main=438-0465278-4487583; aws-userInfo-signed=eyJ0eXAiOiJKV1MiLCJrZXlSZWdpb24iOiJ1cy1lYXN0LTEiLCJhbGciOiJFUzM4NCIsImtpZCI6ImFmY2M3ZGEzLWQyNWMtNGNmMC04ZTdkLWEzOGMyOTlhNTUxNSJ9.eyJzdWIiOiIiLCJzaWduaW5UeXBlIjoiUFVCTElDIiwiaXNzIjoiaHR0cDpcL1wvc2lnbmluLmF3cy5hbWF6b24uY29tXC9zaWduaW4iLCJrZXliYXNlIjoiRUl2SEc0RU9Yc3lTbTlsb1pVYjluT3FCa3RuK1czZHcrRmJ5YW1zcXBhND0iLCJhcm4iOiJhcm46YXdzOmlhbTo6NjEzMDIzMDE3NTg4OnJvb3QiLCJ1c2VybmFtZSI6ImF4ZWxzIn0.NZOD0QYTSk9L6fHP9QWbafVD_ePEx84A1csxQ9IUI-gX1oGmhmx8QS7PnYuUzhXjt_JtATzlNJXLP1RV3lcnzPZbMWFKs-6v1cqSbG-jkxmi1C7Y2KQ5WT0R4iia1n_G; aws-userInfo=%7B%22arn%22%3A%22arn%3Aaws%3Aiam%3A%3A613023017588%3Aroot%22%2C%22alias%22%3A%22%22%2C%22username%22%3A%22axels%22%2C%22keybase%22%3A%22EIvHG4EOXsySm9loZUb9nOqBktn%2BW3dw%2BFbyamsqpa4%5Cu003d%22%2C%22issuer%22%3A%22http%3A%2F%2Fsignin.aws.amazon.com%2Fsignin%22%2C%22signinType%22%3A%22PUBLIC%22%7D; regStatus=pre-register; i18n-prefs=USD; sp-cdn=\"L5Z9:IQ\"; lc-main=en_US; av-timezone=Asia/Baghdad; session-id-eu=259-7192985-9489717; ubid-acbuk=261-4086222-7469429; ubid-acbus=134-5264130-6968240; x-main=\"XyFa5nsYd5l@8RSL42Vmbmrnh5ououjqRAhi6XYfoJDSeoU@hT5RjNsU2@fJ5?y3\"; at-main=Atza|IwEBIIUjppp_fQUDn1uBtGpYXyZL9oN6h5q0jtbyWdbEEI81-ztIUV5VleiojXeBcoV8oaM_lt6H-TuqKhycym48o_yq0qbDkJ6ali-gTznxL_CIL6kN6nYS8l4sNvmpM0CmpN43FPCPYPmwhhDNtiXsR1j-vxuyTBXFXWr4yoQ5QuBctfUncd1amhrWbPKr47lACZtPAnmkl9K1VIWrw1u1yFk5; sess-at-main=\"TBTj+tPZ9TMevsf+CEkHbEOMEzq3hx0o40xNdLfh4BY=\"; sst-main=Sst1|PQHOhh8ZkCkZBIgN2b5FxC6XCXtgzdaT5RWEK8HDn1HyiAQ-n9DnGlyEUWSiPaFxWOnMOor9xI_bgRbyqhoZ_w8jwCL6xyAiwLpdUjqidTwj9siLGJHH2vvDH_SlQ0nHSHSgCtZGopPpf-uY2lp8gHv5OaBRpPEymygpy9m5yAdyMU3av4G4n4rPsF4gzoPMm7zxgCqDTNh8jbBWsp5OaFOWcdkMf2KiYT_23W1lF5N-FC8txR9PNVx4_Z4syflqEdg7DcS0cUeD1QAETU8gesd2GEs3hUsaQsYphS5oTA_NCsE; s_fid=1DFC961AA6BBF23C-20CC5D65A92257F4; s_cc=true; _rails-root_session=Q1V1RDlrSEtCeDhqVzM2Vlp6SmppclVHSHBnQ2lXbmlFN2pDRjNTT0xsb09xem1qanJGV3p2M2hKdUVCbHBRUUp0ZGpGTVk0MnV2anlWZTRyOVcvRGZsclc0cjlzR21sc1BzdDZjaWN0MUdCRWtDQm42Wm9KTGJ6Vi9mZWtqNC9oL20rdkhvYmlmMjBERTdOdEZNSXBYNE9tSFVMRlVVbDgxanV2VjZhYWY2S1hud0F0WW55ZWxPRWcvcG5qNXNsLS0wTWNLL2cwOHFnRjQzdWdkaW9kamV3PT0%3D--aa52452955d814c99d40d6a5873aeb68013dc0ed; session-id-time=2082787201l; aws_lang=en; AMCVS_7742037254C95E840A4C98A6%40AdobeOrg=1; AMCV_7742037254C95E840A4C98A6%40AdobeOrg=1585540135%7CMCIDTS%7C19435%7CMCMID%7C87472201635488554340845785351051280852%7CMCAAMLH-1679741010%7C6%7CMCAAMB-1679741010%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1679143410s%7CNONE%7CMCAID%7CNONE%7CvVersion%7C4.4.0; aws-mkto-trk=id%3A112-TZM-766%26token%3A_mch-amazon.com-1664595465865-78671; s_sq=%5B%5BB%5D%5D; csm-hit=tb:YAGFTGDGK9SPHXBHAT58+s-Z6H6C3JG06JB77S2A9M4|1679138282796&t:1679138282796&adb:adblk_yes; session-token=kb7WSwAysnPB1jpgmZCYGJ6GB55xM1Px18WerpVQjvin6bF7Xm3raCZxuGcAZ6ag3VIiSo8rlIbP22tBuBjbAH6Fqr6HTG8+Rn41rVu9sgPHcmfGJKjobcWpIJSqORM/yn/L+UR2jpvDwNXCkRolgV2nqFLSJsg+jGJ2+yinmeAwiuVuWvN7NKOotRRYnmg7nkMp3ikZ8LcPQ2ASNcNPqHNe0aPl3y1rNN0Q0uVA7ktBBnCeUDh7wF6P2GWaoyql",
    "device-memory": "8",
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
  List<item> itemsList = [];
  String url =
      "https://www.amazon.co.uk/s?k=$query&page=${pageNo}&currency=USD";
  final respone = await http.get(Uri.parse(url), headers: headers);
  dom.Document html = dom.Document.html(respone.body);
  String selector = "div.s-main-slot.s-result-list.s-search-results.sg-row";
  List? items = html
      .querySelector(selector)
      ?.children
      .map((e) => e.innerHtml.trim())
      .toList();
  print(items);
  if (items != null) {
    for (final ele in items) {
      dom.Document eleHtml = dom.Document.html(ele);
      var strPrice = eleHtml
          .querySelector("span.a-price > span.a-offscreen")
          ?.innerHtml
          .trim()
          .replaceAll("&nbsp;", " ");
      if (strPrice == null) continue;
      var title = eleHtml
          .querySelector("div.a-section > h2 > a > span")
          ?.innerHtml
          .trim();
      var rateBase = 0.0;

      var img = eleHtml
          .querySelector(".a-section > .s-image")
          ?.attributes["src"]!
          .trim();

      if (title == null) {
        continue;
      }
      // rateBase ??= 0;

      double price = stringToPrice(strPrice);
      itemsList.add(
          item(title, "Amazon", img, rateBase, strPrice, "testlink", price));
    }
  }

  return itemsList;
}
