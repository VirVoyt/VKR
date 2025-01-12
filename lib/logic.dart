part of 'demo.dart';

class Ramdom{
      var list = [];
      int rnv = 0;

      rnm(){
        var rng = Random();
        rnv = rng.nextInt(10000);
      }

      void main({description, price, percent}) {
        rnm();
        int count = 0;
        for (var name in list){
          if(rnv == name){
            count++;
          }
        }
        if(count == 0){
          list.add(rnv);
        } else if(count == 1){
          main();
        }
        print(list);
        Save save = Save(description: description, price: price, percent: percent, rnv: rnv);
  }
}
