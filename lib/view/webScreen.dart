import 'package:browser/provider/webProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  WebProvider? providerF;
  WebProvider? providerT;

  @override
  void initState() {
    super.initState();

    providerF?.pullToRefreshController = PullToRefreshController(
      onRefresh: () {
        providerF!.appWebViewController!.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    providerT = Provider.of<WebProvider>(context, listen: true);
    providerF = Provider.of<WebProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black87,
      body: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            color: Colors.black87,
            child: TextField(
              controller: providerF?.txtsearch,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                icon: Icon(Icons.search,color: Colors.white,),
                onPressed: () {
                  var search = providerF!.txtsearch.text;
                  providerF!.appWebViewController!.loadUrl(
                      urlRequest: URLRequest(
                          url: Uri.parse(
                              "https://www.google.com/search?q=$search")));
                },
              )),
            ),
          ),
          LinearProgressIndicator(value: providerT!.progress.toDouble()),
          Expanded(
            child: InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse("https://www.google.com/")),
              onLoadStart: (controller, url) {
                providerF!.appWebViewController = controller;
              },
              onLoadStop: (controller, url) {
                providerF!.pullToRefreshController!.endRefreshing();
                providerF!.appWebViewController = controller;
              },
              onLoadError: (controller, url, code, message) {
                providerF!.pullToRefreshController!.endRefreshing();
                providerF!.appWebViewController = controller;
              },
              onProgressChanged: (controller, progress) {
                providerF!.pullToRefreshController!.endRefreshing();
                providerF!.appWebViewController = controller;
                providerF!.changeProgress(progress/100.toDouble());
              },
              pullToRefreshController: providerF!.pullToRefreshController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    providerF!.appWebViewController!.goBack();
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.white)),
              IconButton(
                  onPressed: () {
                    providerF!.appWebViewController!.reload();
                  },
                  icon: Icon(Icons.bookmark_add_outlined,color: Colors.white)),
              IconButton(
                  onPressed: () {
                    providerF!.appWebViewController!.reload();
                  },
                  icon: Icon(Icons.refresh,color: Colors.white)),
              IconButton(
                  onPressed: () {
                    providerF!.appWebViewController!.reload();
                  },
                  icon: Icon(Icons.local_fire_department_outlined,color: Colors.white)),
              IconButton(
                  onPressed: () {
                    providerF!.appWebViewController!.goForward();
                  },
                  icon: Icon(Icons.arrow_forward,color: Colors.white,)),
            ],
          ),
        ],
      ),
    ));
  }
}
