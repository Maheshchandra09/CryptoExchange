import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
class Swaptokens extends StatefulWidget{
  final String address;
  const Swaptokens({Key?key, required this.address}):super(key:key);
   State<Swaptokens> createState()=>_swaptokens();
}
class _swaptokens extends State<Swaptokens>{
  @override
  late Client httpClient;
  late Web3Client ethClient;
  EthereumAddress myaddress=EthereumAddress.fromHex("0x0D9c728dB4Bd997C20c5D02bc7a2E7EC93c8BdBa");
  final String api="https://goerli.infura.io/v3/63d033148cca4f898a50d87bd6266a34";
  var privAddress;
  var credentials;
  var temp;
  @override
  void initState(){
    httpClient=Client();
    ethClient=Web3Client(api, httpClient);
    myaddress=EthereumAddress.fromHex(widget.address);
     privAddress="9ccaca35a792d3600560bbd88cfd1d1d39368827debbc47042688e0c9542f858";
     temp=EthPrivateKey.fromHex(privAddress);
    credentials=temp.address;
    super.initState();
  }
  Future<DeployedContract>getContract() async{
    String abi=await rootBundle.loadString('assets/swapabi.json');
    String contractAddress="0xDd8A42c6F2046E410CCc226cF2F4e3C7Ff3ca0eB";
    final contract=DeployedContract(ContractAbi.fromJson(abi,"swapToken"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }


  Future<String> callFunction(String name,List<dynamic>args) async {
    final contract=await getContract();
    final function=contract.function(name);
    EthPrivateKey key=EthPrivateKey.fromHex(privAddress);
    Transaction transaction = await Transaction.callContract(
        contract: contract,
        function: function,
        parameters: args,
        maxGas: 100000,
        );
    print(transaction.nonce);
    final result =
    await ethClient.sendTransaction(key, transaction, chainId: 5);
    return result;
    // final result=await ethClient.call(contract: contract,function: function,params:args);
    // return result;
    setState(() {

    });
  }
  // Future<void> _confirmOrder(String orderID) async {
  //   final transaction = Transaction(
  //     to: EthereumAddress.fromHex("0xDd8A42c6F2046E410CCc226cF2F4e3C7Ff3ca0eB"),
  //     from: EthereumAddress.fromHex(widget.address),
  //     value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 0),
  //   );
  //
  //   launchUrlString("https://metamask.app.link/");
  //
  //   String returned = await contract.confirmOrder(BigInt.parse(orderID),
  //       credentials: credentials, transaction: transaction);
  // }

  late int amount;
  String val="";
  var res;
  bool f=false;
  Widget build(BuildContext context){
    var controller=TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text("BlockchainATM"),
          backgroundColor: Colors.purple,
        ),
        body:(
            Center(
                child:Column(
                    children:[
                      SizedBox(height: 40,),
                      Text("Send Gold Tokens for Silver Tokens in exchange",style: TextStyle(color: Colors.teal),),
                      SizedBox(height: 20,),
                      SizedBox(height: 30,),
                      Text("Enter amount",style: TextStyle(color: Colors.blue),),
                      SizedBox(height: 20,)
                      ,TextField(
                        controller:
                        controller,
                        
                        decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            hintText: "Enter Amount of Gold Tokens"
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      child:ElevatedButton(onPressed: ()async{
                        setState(() {
                          amount=int.parse(controller.text);
                          val="";
                        });
                         res=await callFunction("swap", [EthereumAddress.fromHex("0x61d65ce0f3528cD9b5C5710d220d3A79287FCdb9"),
                        EthereumAddress.fromHex("0x8CBCF6fBBDcFca433661e7d7fBC3cC54704D0f77"),
                        EthereumAddress.fromHex("0x0D9c728dB4Bd997C20c5D02bc7a2E7EC93c8BdBa"),
                        EthereumAddress.fromHex("0xe1e4f4Ee6a7be78101f77De85A751Db7055527b5"),BigInt.from(amount)]);
                         val=res;
                         print(res);
                         }, child: const Text("Swap"),style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.pink)
                        ,
                        shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(

                                borderRadius: BorderRadius.circular(14.0)
                            )
                        ),
                      ),)),
                      Text(val,style: const TextStyle(color: Colors.blue),)
                    ])))
    );

  }

}