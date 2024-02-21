import 'package:flutter/material.dart';
import 'translation_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController languageController = TextEditingController();
  String _detectedLanuguage = "";
  List<String> _languages = [];

  var output = "";
  var dropdowntext = "Select";

  Future<void> _detectLanguage(String text) async {
    String detectedLanguage = await detectLanguage(text);
    setState(() {
      _detectedLanuguage = detectedLanguage;
    });
  }

  Future<void> _fetchlanguage() async {
    List<String> languages = await fetchLanguages();
    setState(() {
      _languages = languages;
    });
  }

  void _translateText(
      String text, String targetLanguage, String sourceLanguage) async {
    var translation = await translateText(text, targetLanguage,
        sourceLanguage: sourceLanguage);

    setState(() {
      output = translation;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchlanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 200,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  maxLines: null,
                  cursorColor: Colors.white,
                  autofocus: false,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Text to Translate',
                    hintStyle: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  controller: languageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter text to translate';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                // ignore: prefer_const_constructors
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Center(
                        child: Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderOnForeground: true,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          elevation: 3,
                          child: ListTile(
                            title: Center(
                              child: Text(
                                _detectedLanuguage,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            subtitle: const Text(
                              'Auto Detect',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.translate, color: Colors.white),
                    const SizedBox(width: 15),
                    Expanded(
                      child: DropdownButton(
                        focusColor: Colors.white,
                        iconDisabledColor: Colors.white,
                        iconEnabledColor: Colors.white,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        hint: Text(
                          dropdowntext,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                        items: _languages.map((String dropDownStringItem) {
                          return DropdownMenuItem(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdowntext = value!;
                            // ignore: avoid_print
                            print(dropdowntext);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Card(
                color: Colors.amber,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                elevation: 10,
                shadowColor: Colors.amberAccent,
                child: ListTile(
                  title: const Center(child: Text('Translate Button')),
                  subtitle: const Center(child: Text('Tap me!')),
                  onTap: () {
                    _detectLanguage(languageController.text.toString());
                    // print(_detectedLanuguage);
                    // ignore: avoid_print
                    print(_languages);
                    _translateText(languageController.text.toString(),
                        dropdowntext, _detectedLanuguage);
                  },
                ),
              ),
              const SizedBox(height: 45),
              Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "\n$output",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
