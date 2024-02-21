import 'package:dio/dio.dart';

const String _apikey = "350ea5a75emsh78b2de01ad544b1p182c18jsnc50108772d70";
const contentType = "application/x-www-form-urlencoded";
const accept_Encoding = "application/gzip";
const host = "google-translate1.p.rapidapi.com";
const url =
    "https://google-translate1.p.rapidapi.com/language/translate/v2/languages";

Future<List<String>> fetchLanguages() async {
  try {
    final dio = Dio();

    dio.options.headers.addAll({
      'Content-Type': contentType,
      'Accept-Encoding': accept_Encoding,
      'X-Rapidapi-Key': _apikey,
      'X-Rapidapi-Host': host,
    });

    Response response = await dio.get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.data;
      List<dynamic> languagesData = responseData['data']['languages'];
      List<String> languages =
          languagesData.map((lang) => lang['language']).cast<String>().toList();
      return languages;
    } else {
      // Handle Dio Errors
      print('Error: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    // Handle Dio errors
    print('Error: $e');
    return [];
  }
}

Future<String> detectLanguage(String text) async {
  print('detect language called');
  try {
    // Create Dio instance
    //Dio dio = Dio();
    final dio = Dio();

    // Set headers
    dio.options.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept-Encoding': 'application/gzip', // Include Accept-Encoding header
      'X-Rapidapi-Key': _apikey,
      'X-Rapidapi-Host': 'google-translate1.p.rapidapi.com',
    });
    print('headers are set');
    // Encode text
    String encodedText = Uri.encodeQueryComponent(text);

    // Prepare data
    Map<String, dynamic> data = {
      'q': encodedText,
    };
    print('post request is going to be made');
    // Make POST request
    Response response = await dio.post(
      'https://google-translate1.p.rapidapi.com/language/translate/v2/detect',
      data: data,
    );
    print('response has been taken in');
    print('Parsing response commences');
    print(data);

    print('response.statusCode is $response.statusCode');
    // Parse response
    if (response.statusCode == 200) {
      // Assuming response is in JSON format
      Map<String, dynamic> responseData = response.data;
      print('maping of response is completed');
      String detectedLanguage =
          responseData['data']['detections'][0][0]['language'];
      print(detectedLanguage);
      return detectedLanguage;
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
      return 'Error';
    }
  } catch (e) {
    // Handle Dio errors
    print('Error: $e');
    return 'Error';
  }
}

Future<String> translateText(String text, String targetLanguage,
    {required String sourceLanguage}) async {
  try {
    // Create Dio instance
    final dio = Dio();

    // Set headers

    dio.options.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept-Encoding': 'application/gzip', // Include Accept-Encoding header
      'X-Rapidapi-Key': _apikey,
      'X-Rapidapi-Host': 'google-translate1.p.rapidapi.com',
    });
    print('translate headers are set');

    // Encode text
    String encodedText = Uri.encodeQueryComponent(text);

    // Prepare data
    print('preparing data');
    Map<String, dynamic> data = {
      'q': encodedText,
      'target': targetLanguage,
    };
    print('data prepared');

    // Add source language if provided

    data['source'] = sourceLanguage;

    print('data ready and making POST request');
    // Make POST request
    Response response = await dio.post(
      'https://google-translate1.p.rapidapi.com/language/translate/v2',
      data: data,
    );
    print('POST request made');
    print(response.statusCode);

    // Parse response
    if (response.statusCode == 200) {
      // Assuming response is in JSON format
      Map<String, dynamic> responseData = response.data;
      String translatedText =
          responseData['data']['translations'][0]['translatedText'];
      print('translatiton success and translate text is \n$translatedText');
      return translatedText;
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
      return 'Translation Error';
    }
  } catch (e) {
    // Handle Dio errors
    print('Error: $e');
    return 'Translation Error';
  }
}

// Future<String> detectLanguage(String text) async {
//   print('detectLanguage called');

//   try {
//     final dio = Dio();

  

//     dio.options.headers.addAll({
//       // 'Content-Type': contentType,
//       'Accept-Encoding': accept_Encoding,
//       'X-Rapidapi-Key': _apikey,
//       'X-Rapidapi-Host': host,
//       // 'Host': host,
//       // 'Content-Length': text.length,
//     });
//     print("Hearders are set");

//     String endcodedText = Uri.encodeQueryComponent(text);

//     //Prepare data
//     Map<String, String> data = {
//       'q': text,
//     };
//     print('post request is going to be made');

//     Response response = await dio.post(
//       url,
//       data: data,
//     );
//     print('response has been taken in ');
//     print('Parsing response commences ');
//     print('Now printing data');
//     print(data);

//     print('response.statusCode is $response.statusCode');

//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = response.data;
//       print('mapping of response is completed');
//       String detectedLaguage = responseData['data'][0][0]['language'];
//       print(detectedLaguage);
//       return detectedLaguage;
//     } else {
//       print('Error: ${response.statusCode}');
//       return 'Error';
//     }
//   } catch (e) {
//     print('Error: $e');
//     return 'Error';
//   }
// }

// Future<String> translateText(String text, String targetLanguage,
//     {required String sourceLanguage}) async {
//   try {
//     final dio = Dio();
//     print('headers are being sent in');
//     dio.options.headers.addAll({
//       'Content-Type': contentType,
//       'Accept-Encoding': accept_Encoding,
//       'X-Rapidapi-Key': _apikey,
//       'X-Rapidapi-Host': host,
//     });
//     print('headers are sent');

//     String encodedText = Uri.encodeQueryComponent(text);

//     Map<String, dynamic> data = {
//       'q': encodedText,
//       'target': 'ja',
//     };

//     // data['source'] = 'en';

//     //Make POST response
//     print('post request is being made');
//     Response response = await dio.post(
//       url,
//       data: data,
//     );
//     print('post request success');

//     //Parse Response
//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = response.data;
//       String translatedText =
//           responseData['data']['translation'][0]['translatedText'];
//       print(translatedText);
//       return translatedText;
//     } else {

//       print('Error: ${response.statusCode}');
//       return 'Translation Error';
//     }
//   } catch (e) {
//     print('Error: $e');
//     return 'TranslationError';
//   }
// }
