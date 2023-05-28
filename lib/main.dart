import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Youtubeコンバーター',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String channelTitle ="";
  final TextEditingController idController = TextEditingController();
  String channelID = "";
  final TextEditingController urlController = TextEditingController();
  late Map<String, dynamic> data;
  String err = "";

  @override
  Widget build(BuildContext context) {
    data = {};
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube諸々コンバーター"),
      ),
      body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildGetChTitleFromChID(),
              SizedBox(height: 30,),
              buildGetChIDFromChUrl(),
              err!=""?Text(err):SizedBox()
            ],
          )
      ),
    );
  }
  buildGetChTitleFromChID(){
    return Column(
      children: [
        const Text("チャンネルIDからチャンネル名を取得するやつ"),
        SizedBox(
          width: 500,
          child: TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder()
            ),
            controller: idController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            data = await getChTitleFromChID(idController.text);
            channelTitle = data["items"][0]["snippet"]["channelTitle"];
            setState(() {});
          },
          child: const Text("送信"),
        ),
        const SizedBox(
          height: 10,
        ),
        SelectionArea(child:Text("チャンネルタイトル:" +channelTitle) )

      ],
    );
  }

  buildGetChIDFromChUrl(){
    return Column(
      children: [
        const Text("チャンネルURlからチャンネルIDを取得するやつ"),
        SizedBox(
          width: 500,
          child: TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder()
            ),
            controller: urlController,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            data = await getChIDFromURL(urlController.text);
            channelID = data["items"][0]["snippet"]["channelId"];
            setState(() {});
          },
          child: Text("送信"),
        ),
        const SizedBox(
          height: 10,
        ),
        SelectionArea(child: Text("チャンネルID:" +channelID))
      ],
    );
  }

  Future<Map<String, dynamic>> getChTitleFromChID(String channelID) async{
    Map<String, dynamic> data = {};
    try{
      const String api = "YOUR_APIKEY";
      final url = Uri.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelID&type=video&key=$api");
      final response = await http.get(url);
      data =jsonDecode(response.body);
      err = "";
      return data;
    }catch(e){
      err = "正しいものを入力してね";
      return  data;
    }
  }

  Future<Map<String, dynamic>> getChIDFromURL(String channelUrl) async{
    Map<String, dynamic> data = {};
    try{
      const String api = "YOUR_APIKEY";
      channelUrl = channelUrl.substring(24,channelUrl.length);
      final url = Uri.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$channelUrl&type=video&key=$api");
      final response = await http.get(url);
      data =jsonDecode(response.body);
      err = "";
      return data;
    }catch(e){
      err ="正しいものを入力してね";
      return data;
    }
  }

}



