import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

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
  bool isDownloading = false;

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
                  zoom: 0.6 !important;
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
              
              // Force layout recalculation
              document.body.style.display = 'none';
              document.body.offsetHeight;
              document.body.style.display = '';
              
              // Adjust content to fit width
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
      ..loadRequest(Uri.parse(
        'https://pers.tngqatar.online/Module/Fee/StudentInvoice.php'
            '?StudentID=${widget.studentId}'
            '&SessionID=${widget.sessionId}'
            '&FeeTypeID=${widget.feeTypeId}',
      ));
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true; // iOS doesn't need storage permission for app directory
    }
    return false;
  }

  Future<void> _showPermissionDeniedDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
          'Storage permission is required to download the PDF. Please grant the permission in app settings.',
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Open Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> downloadAndOpenPDF() async {
    try {
      setState(() {
        isDownloading = true;
      });

      // Check permissions
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        await _showPermissionDeniedDialog();
        return;
      }

      // Generate PDF URL
      final pdfUrl = 'https://pers.tngqatar.online/Module/Fee/StudentInvoicePDF.php'
          '?StudentID=${widget.studentId}'
          '&SessionID=${widget.sessionId}'
          '&FeeTypeID=${widget.feeTypeId}';

      // Download PDF
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode != 200) {
        throw 'Failed to download PDF';
      }

      // Get download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Create directory if it doesn't exist
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw 'Could not access storage directory';
      }

      // Generate unique filename
      final fileName = 'fee_invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${directory.path}/$fileName';

      // Save PDF
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Open PDF
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw 'Could not open PDF: ${result.message}';
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
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
                  Expanded(
                    child: Text(
                      'Fee Invoice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
                    onPressed: isDownloading ? null : downloadAndOpenPDF,
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
                  if (isLoading || isDownloading)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                          ),
                          if (isDownloading) ...[
                            SizedBox(height: 16),
                            Text('Downloading PDF...'),
                          ],
                        ],
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