import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPoliciesScreen extends StatefulWidget {
  @override
  _WebPoliciesScreenState createState() => _WebPoliciesScreenState();
}

class _WebPoliciesScreenState extends State<WebPoliciesScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            await controller.runJavaScript('''
              // Adjust meta tags and styles as needed
              document.querySelector('meta[name="viewport"]')?.remove();
              var meta = document.createElement('meta');
              meta.name = 'viewport';
              meta.content = 'width=device-width, initial-scale=0.6, maximum-scale=2.0';
              document.getElementsByTagName('head')[0].appendChild(meta);
              
              var style = document.createElement('style');
              style.textContent = `
                body {
                  margin: 0 !important;
                  padding: 8px !important;
                  width: 100% !important;
                  box-sizing: border-box !important;
                  transform-origin: top left !important;
                  
                }
              `;
              document.head.appendChild(style);
            ''');

            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..setBackgroundColor(Color(100))
      ..loadRequest(Uri.parse('https://pers.tngqatar.online/Module/PPP/WebPolicies.php'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    'Web Policies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: WebViewWidget(controller: controller),
                    ),
                  ),
                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
