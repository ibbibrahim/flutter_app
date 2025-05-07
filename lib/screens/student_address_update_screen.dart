import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddressUpdateScreen extends StatefulWidget {
  final String studentId;
  final String fatherQatarId;

  AddressUpdateScreen({
    required this.studentId,
    required this.fatherQatarId,
  });

  @override
  _AddressUpdateScreenState createState() => _AddressUpdateScreenState();
}

class _AddressUpdateScreenState extends State<AddressUpdateScreen> {
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
              // Remove existing viewport meta tag if it exists
              document.querySelector('meta[name="viewport"]')?.remove();

              // Add new viewport meta tag
              var meta = document.createElement('meta');
              meta.name = 'viewport';
              meta.content = 'width=device-width, initial-scale=0.6, maximum-scale=2.0';
              document.getElementsByTagName('head')[0].appendChild(meta);

              // Add custom CSS
              var style = document.createElement('style');
              style.textContent = `
                body {
                  margin: 0 !important;
                  padding: 8px !important;
                  width: 100% !important;
                  box-sizing: border-box !important;
                  transform-origin: top left !important;
                  zoom: 1 !important;
                }

                table {
                  width: 100% !important;
                  max-width: 100% !important;
                  margin: 0 !important;
                  box-sizing: border-box !important;
                  font-size: 14px !important;
                  transform-origin: top left !important;
                }

                td, th {
                  padding: 4px !important;
                  word-break: break-word !important;
                }

                * {
                  max-width: 100% !important;
                  box-sizing: border-box !important;
                }
              `;
              document.head.appendChild(style);

              document.body.style.display = 'none';
              document.body.offsetHeight;
              document.body.style.display = '';

              function adjustContent() {
                const content = document.documentElement;
                const scale = window.innerWidth / content.scrollWidth;
                if (scale < 1) {
                  document.body.style.transform = `scale(\${scale})`;
                  document.body.style.transformOrigin = 'top left';
                  document.body.style.width = `\${100 / scale}%`;
                }
              }

              adjustContent();
              window.addEventListener('resize', adjustContent);
            ''');

            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..setBackgroundColor(Color(100))
      ..loadRequest(Uri.parse(
        'https://pers.tngqatar.online/Module/AddressPlusParentInfoUpdate.php'
            '?SearchStudentID=${widget.studentId}&SearchFatherQID=${widget.fatherQatarId}',
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
                    'Update Address & Parent Info',
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
