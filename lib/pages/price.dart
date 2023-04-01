import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
class Chainlink extends StatefulWidget{
  const Chainlink({Key? key}):super(key:key);
  @override
  State<Chainlink> createState()=> _ChainlinkState();
}
class _ChainlinkState extends State<Chainlink>{
  String btc="";
  String eth="";
  String cv="";
  late Client httpClient;
  late Web3Client ethClient;
  final String myaddress="0x0D9c728dB4Bd997C20c5D02bc7a2E7EC93c8BdBa";
  final String api="https://goerli.infura.io/v3/63d033148cca4f898a50d87bd6266a34";
  @override
  void initState(){
    httpClient=Client();
    ethClient=Web3Client(api, httpClient);
    super.initState();
  }
  Future<DeployedContract>getContract() async{
    String abi=await rootBundle.loadString('assets/abi.json');
    String contractAddress="0x9A5C03aa7AD485c54D8B3c966E7a7764829108f0";
    final contract=DeployedContract(ContractAbi.fromJson(abi,"PriceData"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }
  Future<List<dynamic>> callFunction(String name,List<dynamic>args) async {
    final contract=await getContract();
    final function=contract.function(name);
    final result=await ethClient.call(contract: contract,function: function,params:args);
    return result;
    setState(() {

    });
  }

  var controller=TextEditingController();
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Real-time prices"),
        backgroundColor: Colors.purple,
      ),
      body:(

      Center(
          child:Column(

            children: [
              SizedBox(height:60),
              Image.asset(
                fit: BoxFit.fitHeight
                ,
                'assets/images/bitcoin-icon-1.jpg',height:50),
              Container(
                child: ElevatedButton(
                  onPressed: ()async{
                    var x=await callFunction("getBtcPrice",[]);
                    BigInt y=x[0];
                    setState(() {
                      btc="\$"+'${y}';
                    });

                  },child: Text("Get the current price of Bitcoin "),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.deepPurple)
                          )
                      )
                ),
              ),

              ),
              SizedBox(height: 10),
              Text(btc,style: TextStyle(color: Colors.green),),
          SizedBox(height: 30,),
              Image.asset(
                  fit: BoxFit.fitHeight
                  ,
                  'assets/images/eth.png',height:50),
          Container(
            child: ElevatedButton(
              onPressed: ()async{
                var x=await callFunction("getEthPrice",[]);
                BigInt y=x[0];
                setState(() {
                  eth="\$"+'${y}';
                });

              },child: Text("Get the current price of ETH "),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
                  shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        //side: BorderSide(color: Colors.deepPurple)
                      )
                  )
              ),
            ),),SizedBox(height: 10),
               Text(
                eth,style:TextStyle(
                 color: Colors.green
               )
              ),
              SizedBox(height:20),
              Image.asset(
                  fit: BoxFit.fitHeight
                  ,
                  'assets/images/eth-btc.png',height:50),
    Container(
      padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
      child:Column(
        
      children:[
      TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: 
              BorderRadius.circular(40)
          )
          ,
        hintText:"Enter the amount in Ethers",
        )),
        ElevatedButton(
          onPressed: ()async{
            var x=await callFunction("convert_rate",[BigInt.from(int.parse(controller.text))]);
            BigInt y=x[0];
            setState(() {
              cv='Value of ${controller.text} ETH tokens in BTC is ${y}\n';
            });

          },child: Text("Get the value of Bitcoin V/S Ehtereum "),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: Colors.deepPurple)
                  )
              )
          ),
        ),
      ])
    ),
              Text(cv,style: TextStyle(fontWeight:FontWeight.bold),)
            ,Text("Powered by ChainLink",style: TextStyle(color: Colors.grey),)],
          )
      )
      )
    );
  }
}