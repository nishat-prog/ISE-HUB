import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentDisplayPage extends StatelessWidget {
  final String documentUrl;

  const DocumentDisplayPage({Key? key, required this.documentUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print('Document Url is: $documentUrl');

    return Scaffold(
      appBar: AppBar(
        title: Text("Document",style: TextStyle(color:Colors.white),),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SfPdfViewer.network(
       documentUrl,
        canShowPaginationDialog: true,
      ),
    );
  }
}
