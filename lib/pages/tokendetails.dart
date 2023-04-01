import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'swap.dart';
class Tokendetails extends StatefulWidget{
  final String address;
  const Tokendetails({Key? key,required this.address}):super(key:key);

  @override
  State<Tokendetails> createState()=>_Tokendetails();
}

class _Tokendetails extends State<Tokendetails>{
  late Client httpClient;
  late Web3Client ethClient;
   EthereumAddress myaddress=EthereumAddress.fromHex("0x0D9c728dB4Bd997C20c5D02bc7a2E7EC93c8BdBa");
  final String api="https://goerli.infura.io/v3/63d033148cca4f898a50d87bd6266a34";
  @override
  void initState(){
    httpClient=Client();
    ethClient=Web3Client(api, httpClient);
    myaddress=EthereumAddress.fromHex(widget.address);
    super.initState();
  }
  Future<DeployedContract>getContract(String token) async{
    String abi=await rootBundle.loadString('assets/gold.json');
    String contractAddress="";
    if(token=="gd"){
      contractAddress="0x38181A9Eb6733964A5359B614925440D1932f596";
    }
    else{
      contractAddress="0x8CBCF6fBBDcFca433661e7d7fBC3cC54704D0f77";
    }
    final contract=DeployedContract(ContractAbi.fromJson(abi,"Token"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> callFunction(String token,String name,List<dynamic>args) async {
    final contract=await getContract(token);
    final function=contract.function(name);
    final result=await ethClient.call(contract: contract,function: function,params:args);
    return result;
    setState(() {

    });
  }
  var balg="";
  var bals="";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Token details"),
        backgroundColor: Colors.purple,
      ),
      body:
      (
      Center(
        child: Column(
          children: [
            SizedBox(height: 90,),
            ElevatedButton(onPressed: ()async{
              var amt=await callFunction("gd", "balanceOf", [myaddress]);
              setState(() {
                balg='${amt[0]}';
              });
            }, child:const Text("Get balance of Gold tokens"),style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.pink)
              ,
              shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(14.0)
                  )
              ),
            ),)
            ,
            Text(
              balg,style:
                TextStyle(color:Colors.black)
            ),
            SizedBox(height: 40,),
            ElevatedButton(onPressed: ()async{
              var amt=await callFunction("sl", "balanceOf", [myaddress]);
              setState(() {
                bals='${amt[0]}';
              });
            }, child:const Text("Get balance of Silver tokens"),
            style:ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.pink)
              ,
              shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(14.0)
                  )
              ),
            )),
            Text(bals,style: TextStyle(color: Colors.black),),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Swaptokens(address: widget.address,)));
            }
             , child:Text("Swap Tokens"),style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.purpleAccent)
                ,
                shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(14.0)
                    )
                ),
            ),),
            SizedBox(height: 40,),
            Text("Note the amounts are represented in terms of 1 ETH\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t 1 ETH= 10 power 18 coins",style: TextStyle(color: Colors.grey),)
          ],
        ),
      )
      )
    );
  }

}