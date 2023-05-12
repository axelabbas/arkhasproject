import 'dart:convert';

import 'package:arkhasproject/util/usefulfunctions.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class alibabaItem {
  late String title;
  late String type;
  late String img;
  late double price;
  late double rateBase;
  late String strPrice;
  late String link;

  alibabaItem(this.title, this.type, this.img, this.rateBase, this.strPrice,
      this.link, this.price);
}

searchAlibaba(query, pageNo) async {
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
  List<alibabaItem> itemsList = [];
  String url =
      "https://en.alibaba.com/trade/search?spm=a2700.galleryofferlist.0.0.561f50bbOksSmA&fsb=y&IndexArea=product_en&keywords=$query&tab=all&viewtype=L&&page=${pageNo + 1}";
  final respone = await http.get(Uri.parse(url), headers: headers);
  BeautifulSoup bs = BeautifulSoup(respone.body);
  var script = bs.findAll("script")[32].text.trim();
  var js = json.decode(script
      .split("window.__page__data__config = ")[1]
      .split("window.__page__data = window.__page__data__config.props")[0]);
  var listOfProducts = js["props"]["offerResultData"]["offerList"];

  for (final ele in listOfProducts) {
    var title = ele["information"]["title"]
        .replaceAll("<strong>", "")
        .replaceAll("</strong>", "");
    var itemLink =
        ele["information"]["productUrl"].replaceAll("//www.", "www.");
    var type = "AliBaba";
    var img = "https:" + ele["image"]["mainImage"];
    double rateBase = 0;

    if (ele["reviews"]["productScore"] == null) {
      rateBase = 0;
    } else {
      rateBase = double.tryParse(ele["reviews"]["productScore"])!;
    }
    var strPrice = ele["tradePrice"]["price"];
    double price = stringToPrice(strPrice);


    itemLink = "https://$itemLink";
    itemsList.add(
        alibabaItem(title, type, img, rateBase, strPrice, itemLink, price));
  }
  return itemsList;
}
