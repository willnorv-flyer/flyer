import 'package:flutter/material.dart';
import 'package:flyer_client/models/survey_form.dart';
import 'package:flyer_client/screens/upsert_maker_survey_form_content_screen.dart';
import 'package:flyer_client/util/colors.dart';

class UpsertMakerSurveyFormNameScreen extends StatefulWidget {
  const UpsertMakerSurveyFormNameScreen({super.key, required this.surveyForm});

  final SurveyForm surveyForm;

  @override
  State<UpsertMakerSurveyFormNameScreen> createState() =>
      _UpsertMakerSurveyFormNameScreenState();
}

class _UpsertMakerSurveyFormNameScreenState
    extends State<UpsertMakerSurveyFormNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _name = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.surveyForm.name;
    _name = widget.surveyForm.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "취소",
                style: TextStyle(
                  color: Color(primaryColor),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // search bar
          const Spacer(),
          const Text(
            "설문지 이름",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0x1A767880),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            hintText: "설문지 이름 입력",
                            hintStyle: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _name = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_nameController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _nameController.clear();
                                _name = "";
                              });
                            },
                            child: Icon(
                              Icons.cancel,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // 저장 버튼. 텍스트 필드가 비어있으면 비활성화. full width except 16 horizontal padding
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _nameController.text.isEmpty
                    ? Color(disabledBackgroundColor)
                    : Color(primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 44),
              ),
              onPressed: _nameController.text.isEmpty
                  ? null
                  : () async {
                      widget.surveyForm.name = _name;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              UpsertMakerSurveyFormContentScreen(
                            surveyForm: widget.surveyForm,
                          ),
                        ),
                      );
                    },
              child: Text(
                "다음",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: _nameController.text.isEmpty
                      ? Color(disabledTextColor)
                      : Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
