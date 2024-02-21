import 'package:dio/dio.dart';

const String _apikey = "350ea5a75emsh78b2de01ad544b1p182c18jsnc50108772d70";
const contentType = "application/x-www-form-urlencoded";
const accept_Encoding = "application/gzip";
const host = "google-translate1.p.rapidapi.com";
const url = "https://google-translate1.p.rapidapi.com/language/translate/v2/languages";

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
  print('detectLanguage called');

  try {
    final dio = Dio();

    dio.options.headers.addAll({
      'Content-Type': contentType,
      'Accept-Encoding': accept_Encoding,
      'X-Rapidapi-Key': _apikey,
      'X-Rapidapi-Host': url,
    });
    print("Hearders are set");

    String endcodedText = Uri.encodeQueryComponent(text);

    //Prepare data
    Map<String, dynamic> data = {
      'q': endcodedText,
    };
    print('post request is going to be made');

    Response response = await dio.post(
      url,
      data: data,
    );
    print('response has been taken in ');
    print('Parsing response commences ');
    print('Now printing data');
    print(data);

    print('response.statusCode is $response.statusCode');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.data;
      print('mapping of response is completed');
      String detectedLaguage = responseData['data'][0][0]['language'];
      print(detectedLaguage);
      return detectedLaguage;
    } else {
      print('Error: ${response.statusCode}');
      return 'Error';
    }
  } catch (e) {
    print('Error: $e');
    return 'Error';
  }
}

Future<String> translateText(String text, String targetLanguage,
    {required String sourceLanguage}) async {
  try {
    final dio = Dio();

    dio.options.headers.addAll({
      'Content-Type': contentType,
      'Accept-Encoding': accept_Encoding,
      'X-Rapidapi-Key': _apikey,
      'X-Rapidapi-Host': host,
    });

    String encodedText = Uri.encodeQueryComponent(text);

    Map<String, dynamic> data = {
      'q': encodedText,
      'target': targetLanguage,
    };

    data['source'] = sourceLanguage;

    //Make POST response

    Response response = await dio.post(
      url,
      data: data,
    );

    //Parse Response
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.data;
      String translatedText =
          responseData['data']['translation'][0]['translatedText'];
      print(translatedText);
      return translatedText;
    } else {
      print('Error: ${response.statusCode}');
      return 'Translation Error';
    }
  } catch (e) {
    print('Error: $e');
    return 'TranslationError';
  }
}
