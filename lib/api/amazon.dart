import 'package:arkhasproject/util/usefulfunctions.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'dart:core';
import 'itemClass.dart';

RegExp exp = RegExp(r"USD&nbsp;\d{0,100}\.\d{0,100}");
searchAmazon(query, pageNo) async {
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
  List<item> itemsList = [];
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
// <div class="sg-col-inner"><div cel_widget_id="MAIN-SEARCH_RESULTS-1" class="s-widget-container s-spacing-small s-widget-container-height-small celwidget slot=MAIN template=SEARCH_RESULTS widgetId=search-results_1" data-csa-c-pos="1" data-csa-c-item-id="amzn1.asin.1.B09QQQWM3T" data-csa-op-log-render="" data-csa-c-type="item"><div class="s-card-container s-overflow-hidden aok-relative puis-wide-grid-style puis-wide-grid-style-t3 puis-include-content-margin puis s-latency-cf-section s-card-border"><div class="a-section"><div class="sg-row"><div class="sg-col sg-col-4-of-12 sg-col-4-of-16 sg-col-4-of-20 sg-col-4-of-24 s-list-col-left"><div class="sg-col-inner"><div class="a-section a-spacing-none aok-relative puis-status-badge-container s-list-status-badge-container"></div><div class="s-product-image-container aok-relative s-text-center s-image-overlay-grey puis-image-overlay-grey s-padding-left-small s-padding-right-small s-flex-expand-height"><div class="aok-relative"><span data-component-type="s-product-image" class="rush-component"><a class="a-link-normal s-no-outline" href="/Samsung-A13-White-Old-Version/dp/B09QQQWM3T/ref=sr_1_1?currency=USD&amp;keywords=iphone&amp;qid=1691258579&amp;sr=8-1"><div class="a-section aok-relative s-image-fixed-height"><img class="s-image" src="https://m.media-amazon.com/images/I/718IIORHgAL._AC_UY218_.jpg" srcset="https://m.media-amazon.com/images/I/718IIORHgAL._AC_UY218_.jpg 1x, https://m.media-amazon.com/images/I/718IIORHgAL._AC_UY327_FMwebp_QL65_.jpg 1.5x, https://m.media-amazon.com/images/I/718IIORHgAL._AC_UY436_FMwebp_QL65_.jpg 2x, https://m.media-amazon.com/images/I/718IIORHgAL._AC_UY545_FMwebp_QL65_.jpg 2.5x, https://m.media-amazon.com/images/I/718IIORHgAL._AC_UY654_FMwebp_QL65_.jpg 3x" alt="Samsung Galaxy A13 Mobile Phone SIM Free Android Smartphone 64 GB Awesome White" data-image-index="1" data-image-load="" data-image-latency="s-product-image" data-image-source-density="1"></div></a></span></div></div></div></div><div class="sg-col sg-col-4-of-12 sg-col-8-of-16 sg-col-12-of-20 sg-col-12-of-24 s-list-col-right"><div class="sg-col-inner"><div class="a-section a-spacing-small a-spacing-top-small"><div class="a-section a-spacing-none puis-padding-right-small s-title-instructions-style"><h2 class="a-size-mini a-spacing-none a-color-base s-line-clamp-2"><a class="a-link-normal s-underline-text s-underline-link-text s-link-style a-text-normal" href="/Samsung-A13-White-Old-Version/dp/B09QQQWM3T/ref=sr_1_1?currency=USD&amp;keywords=iphone&amp;qid=1691258579&amp;sr=8-1"><span class="a-size-medium a-color-base a-text-normal">Samsung Galaxy A13 Mobile Phone SIM Free Android Smartphone 64 GB Awesome White</span></a> </h2></div><div class="a-section a-spacing-none a-spacing-top-micro"><div class="a-row a-size-small"><span aria-label="4.4 out of 5 stars"><span class="a-declarative" data-action="a-popover" data-csa-c-type="widget" data-csa-c-func-deps="aui-da-a-popover" data-a-popover="{&quot;closeButton&quot;:false,&quot;closeButtonLabel&quot;:&quot;&quot;,&quot;position&quot;:&quot;triggerBottom&quot;,&quot;popoverLabel&quot;:&quot;&quot;,&quot;url&quot;:&quot;/review/widgets/average-customer-review/popover/ref=acr_search__popover?ie=UTF8&amp;asin=B09QQQWM3T&amp;ref=acr_search__popover&amp;contextId=search&quot;}"><a href="javascript:void(0)" role="button" class="a-popover-trigger a-declarative"><i class="a-icon a-icon-star-small a-star-small-4-5 aok-align-bottom"><span class="a-icon-alt">4.4 out of 5 stars</span></i><i class="a-icon a-icon-popover"></i></a></span> </span><span aria-label="741"><a class="a-link-normal s-underline-text s-underline-link-text s-link-style" href="/Samsung-A13-White-Old-Version/dp/B09QQQWM3T/ref=sr_1_1?currency=USD&amp;keywords=iphone&amp;qid=1691258579&amp;sr=8-1#customerReviews"><span class="a-size-base s-underline-text">741</span> </a> </span></div></div><div class="sg-row"><div class="sg-col sg-col-4-of-12 sg-col-4-of-16 sg-col-4-of-20 sg-col-4-of-24"><div class="sg-col-inner"></div></div><div class="sg-col sg-col-4-of-12 sg-col-4-of-16 sg-col-8-of-20 sg-col-8-of-24"><div class="sg-col-inner"></div></div></div></div></div></div></div></div></div></div></div>
  if (items != null) {
    items.removeAt(0);
    // print(html.querySelector(selector)!.text);
    items.asMap().forEach((index, ele) {
      dom.Document eleHtml = dom.Document.html(ele);
      var strPrice = eleHtml
          .querySelector("span.a-price > span.a-offscreen")
          ?.innerHtml
          .trim()
          .replaceAll("&nbsp;", " ");
      if (strPrice == null) {
        strPrice = eleHtml
            .querySelector("a.a-size-base > span.a-price > span.a-offscreen")
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
        itemsList
            .add(item(title, "Amazon", img, rateBase, strPrice, link, price));
      }
      // rateBase ??= 0;
    });
  }

  return itemsList;
}
