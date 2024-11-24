import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeeInvoiceScreen extends StatefulWidget {
  final String studentId;
  final String sessionId;
  final String feeTypeId;

  FeeInvoiceScreen({
    required this.studentId,
    required this.sessionId,
    required this.feeTypeId,
  });

  @override
  _FeeInvoiceScreenState createState() => _FeeInvoiceScreenState();
}

class _FeeInvoiceScreenState extends State<FeeInvoiceScreen> {
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
              const meta = document.createElement('meta');
              meta.name = 'viewport';
              meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
              document.getElementsByTagName('head')[0].appendChild(meta);
            ''');
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..setBackgroundColor(Color(100)) // Adjust the zoom level if needed
      ..loadRequest(Uri.parse(
        'https://pers.tngqatar.online/Module/Fee/StudentInvoice.php'
            '?StudentID=${widget.studentId}'
            '&SessionID=${widget.sessionId}'
            '&FeeTypeID=${widget.feeTypeId}',
      ));
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
                    'Fee Invoice',
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
