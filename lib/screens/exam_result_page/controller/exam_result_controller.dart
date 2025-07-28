import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:login_portal/utils/funtions.dart';

import '../models/end_of_term_result_model.dart';
import '../models/exam_result_model.dart';
import '../models/subject_result_model.dart';
import '../models/examprogressbar_item_model.dart';

/// A controller class for the ExamResultPage.
///
/// This class manages the state of the ExamResultPage, including the
/// current examResultModelObj


class ExamResultController extends GetxController {
  ExamResultController(this.examResultModelObj);

  Rx<ExamResultModel> examResultModelObj;
  var isLoadingProgress = true.obs;


  Future<void> fetchSubjectResults({required int studentId, required int termId}) async {
    try {
      final action = 'getResultsForStudent';
      final url = Uri.parse("https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash(action)}&StudentID=$studentId&TermID=$termId");

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == 'success') {
          var results = body['data'] as List;

          examResultModelObj.value.subjectResults.value =
              results.map((item) => SubjectResult.fromJson(item)).toList();

          examResultModelObj.refresh();
        }
      }
    } catch (e) {
      print('Error fetching subject results: $e');
    }
  }

  Future<void> fetchTermWiseResults({required int studentId}) async {
    try {
      isLoadingProgress.value = true;

      final termAction = 'getTermsForCurrentSession';
      final termUrl = Uri.parse("https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash(termAction)}");

      final termResponse = await http.get(termUrl);
      if (termResponse.statusCode == 200) {
        final termData = jsonDecode(termResponse.body);
        if (termData['status'] == 'success') {
          final terms = termData['data'] as List;
          List<ExamprogressbarItemModel> progressBarItems = [];

          for (var term in terms) {
            final termId = term['TermID'];
            final termName = term['TermDescription'];

            final resultUrl = Uri.parse("https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash('getTermWiseOverallResults')}&StudentID=$studentId&TermID=$termId");

            final resultResponse = await http.get(resultUrl);
            if (resultResponse.statusCode == 200) {
              final resultBody = jsonDecode(resultResponse.body);
              if (resultBody['status'] == 'success') {
                final result = resultBody['data'][0];
                final percentage = double.tryParse(result['OverallPercentage'].toString()) ?? 0;
                final formattedScore = "${result['OverallFormativePercentage']} / ${result['OverallSummativePercentage']}";

                progressBarItems.add(ExamprogressbarItemModel(
                  examName: Rx(termName),
                  id: Rx(termId.toString()),
                  percentage: Rx(percentage),
                  overallFormative: Rx("${result['OverallFormativePercentage']}"),
                  overallSummative: Rx("${result['OverallSummativePercentage']}"),
                  overallPercentage: Rx("${result['OverallPercentage']}"),
                ));
              }
            }
          }

          examResultModelObj.value.examprogressbarItemList.value = progressBarItems;
          examResultModelObj.refresh();
        }
      }
    } catch (e) {
      print('Error fetching term-wise results: $e');
    } finally {
      isLoadingProgress.value = false; // <- set to false even if there's an error
    }
  }

  Future<void> fetchEndOfTermResult({required int studentId}) async {
    try {
      final action = 'getEndOfTermResults';
      final url = Uri.parse("https://pers.tngqatar.online/Controler/Public/PerspectiveApi.php?Action=${generateMd5Hash(action)}&StudentID=$studentId");

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == 'success') {
          var data = body['data'];
          if (data.isNotEmpty) {
            print(data);
            final result = EndOfTermResult.fromJson(data[0]);
            examResultModelObj.value.endOfTermResult.value = result;
            examResultModelObj.refresh();
          }
        }
      }
    } catch (e) {
      print('Error fetching end-of-term result: $e');
    }
  }


}