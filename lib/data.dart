part of 'demo.dart';

class Save{
  Save({description, price, percent, rnv}){
    Map des = {
    rnv: description
    };
    Map pric = {
      rnv: price
    };
    Map perc = {
      rnv:percent
    };

    print(des);
    print(pric);
    print(perc);
    for(final key in des.keys){
      print(key);
    }
  }
}

