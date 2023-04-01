import 'package:flutter/material.dart';
import 'package:batm/pages/tokendetails.dart';
class tokens extends StatefulWidget{
  const tokens({Key? key}):super(key:key);
  @override
  State<tokens> createState()=>_tokens();
}
class _tokens extends State<tokens>{
  String address="";
  @override
  Widget build(BuildContext context){
    var controller=TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter MetaMask Wallet Address"),
        backgroundColor: Colors.purple,
      ),
      body:(
      Center(
    child:Column(

    children:[
      SizedBox(height: 40,),
      TextField(
        controller:
          controller,
        decoration: InputDecoration(
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          hintText: "Enter Metamask address"
        ),
      ),
      ElevatedButton(onPressed: (){
        setState(() {
          address=controller.text;
        });
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=>Tokendetails(address:address)));
      }, child: const Text("Enter"))
      ])))
    );
  }
}