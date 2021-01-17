import 'package:selibrary/selibrary.dart';

class Client extends ICubacelClient {
  Future<void> start() async {
    try {
      await login('55555555', 'password');
      await loadMyAccount();

      print(welcomeMessage);
      print(userName);
      print(phoneNumber);
      print(credit);
      print(expire);
      print(creditBonus);
      print(expireBonus);
      print(date);
      print(payableBalance);
      print(isActiveBonusServices);

      buys.forEach((p) {
        print('');
        print('');
        print('PRODUCT: ');
        print(p.title);
        print('ES BONO: ${p.isBonusPackage}');
        print('${p.restData} ${p.dataInfo}');
        print(p.percent);
        print(p.expireDate);
        print(p.packageId);
        print(p.isStatusOrange);
        print(p.isStatusRed);
      });

      // final friends = familyAndFriends;

      // print('Family And Friends');
      // print(friends.title);
      // print(friends.changesFree);
      // print(friends.subscriber);
      // print('Phones');
      // friends.phoneNumbers.forEach((p) {
      //   print(p.title);
      //   print(p.phoneNumber);
      // });

      await loadProducts();

      products.forEach((p) {
        print('\n\nProduct:');
        print(p.title);
        print(p.price);
        print(p.description);
      });

      await products[5].buy();

      print('');
    } on CommunicationException catch (e) {
      print(e.message);
    } on LoginException catch (e) {
      print(e.message);
    } on OperationException catch (e) {
      print(e.message);
    }
  }
}

void main(List<String> args) async {
  Client client = Client();

  await client.start();
}
