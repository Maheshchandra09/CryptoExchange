import 'package:batm/pages/tokens.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:batm/pages/price.dart';
class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}):super (key:key);

  @override
  State<LoginPage> createState()=> _LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
  var walladd;
  var connector=WalletConnect(
     bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: '',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));
  var _uri,_session;
  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(chainId: 5, onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        walladd=session.accounts[0];
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
     appBar: AppBar(
       backgroundColor: (Colors.purple),
        title: const Text('BlockChainATM',),
      ),
      body:Center(
       child:Column(
       mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height:15),
      Image.asset(alignment: Alignment.center,'assets/images/MetaMask.jpg',
      fit: BoxFit.fitHeight,
      width: 60.0,),
      Container(
          alignment: Alignment.center,
      child:ElevatedButton(onPressed: ()=>{loginUsingMetamask(context)},
        child: const Text("Connect With MetaMask",style: TextStyle(
          color: Colors.white
        ),),
        style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.orange),
        shape:MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            //side: BorderSide(color: Colors.deepPurple)
          )
        )
      ),)
    ,),
          Container(
            child: ElevatedButton(
              onPressed: (){
                launchUrlString("https://metamask.app.link/", mode: LaunchMode.externalApplication);
              },
              child: Text("Open MetaMask"),
            ),
          ),
      Container(

          alignment: Alignment.center,
        padding:EdgeInsets.fromLTRB(30,30,30,15),
         child:ElevatedButton(onPressed: (){
           Navigator.push(context,
           MaterialPageRoute(builder: (context)=>tokens()));
         },child: const Text("Manage and swap your tokens"
         ,style:TextStyle(color:Colors.purple)),style: ButtonStyle(
           backgroundColor: MaterialStateProperty.all(Colors.white),
           shape:MaterialStateProperty.all<RoundedRectangleBorder>(
               RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(18.0),
                   side: BorderSide(width: 3.0,color: Colors.purple)
               )
         ),)
      )
      ),
    Container(
        alignment: Alignment.center,
        padding:EdgeInsets.all(10),
        child:ElevatedButton(

          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder:(context)=> Chainlink()));
        },child:const Text("Get live price of currencies",
        style: TextStyle(color: Colors.black),),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.yellow),
          shape:MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(18.0)
              )
          ),
        ),)
    )
    ]),
      )
    );
  }
}