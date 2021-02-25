import 'package:eventklip/api/folders_api.dart';
import 'package:eventklip/di/injection.dart';
import 'package:eventklip/fragments/comment_fragment.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/no_folder_widget.dart';
import 'package:eventklip/models/folder_model.dart';
import 'package:eventklip/models/question.dart';
import 'package:eventklip/ui/parts/add_question_section.dart';
import 'package:eventklip/ui/widgets/context_menu.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class QuestionAnswerSetupScreen extends StatefulWidget {
  final FolderModel folder;

  const QuestionAnswerSetupScreen({Key key, this.folder}) : super(key: key);

  @override
  _QuestionAnswerSetupScreenState createState() =>
      _QuestionAnswerSetupScreenState();
}

class _QuestionAnswerSetupScreenState extends State<QuestionAnswerSetupScreen> {
  FoldersApi _foldersApi = getIt.get<FoldersApi>();

  List<Question> questions = [];

  bool loading = false;

  @override
  void initState() {
    fetchQuestions(widget.folder.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLayout(context, "Setup Q/A"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showTextFieldForAddingQA();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: loading
                    ? Loader()
                    : questions.isEmpty
                        ? NoFolderWidget(
                            icon: Icons.hourglass_empty_outlined,
                            title:
                                'No questions associated with ${widget.folder.name}',
                            subtitle:
                                'Please add questions from the floating button below.',
                          )
                        : ListView.builder(
                            itemBuilder: (context, position) {
                              return QuestionTile(
                                question: questions[position],
                                index: position,
                                onDelete: (question) async {
                                  await _foldersApi
                                      .deleteQuestions(question.id);
                                  fetchQuestions(widget.folder.id);
                                },
                                onEdit: (question) {
                                  showTextFieldForAddingQA(
                                      questionText: question.question,
                                      id: question.id,
                                      duration: question.duration.toString());
                                },
                              );
                            },
                            itemCount: questions.length,
                          ))
          ],
        ),
      ),
    );
  }

  Future<void> fetchQuestions(String id) async {
    try {
      setState(() {
        loading = true;
      });
      final _questions = await _foldersApi.getQuestionsForEventId(id);
      _questions.sort((a, b) {
        return b.lastModifiedDate.compareTo(a.lastModifiedDate);
      });
      setState(() {
        questions = _questions;
        loading = false;
      });
    } catch (e) {
      toast("Something went wrong while fetching questions");
    }
  }

  void showTextFieldForAddingQA(
      {String questionText = "",
      String duration = "",
      String id = "",
      bool forUpdate = false}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return AddQuestionSection(
              initialValue: questionText,
              initialDuration: duration,
              onQuestionAddClicked: (question, duration) async {
                if (id == "") {
                  await _foldersApi.postQuestionsForEventId(
                    Question(
                        duration: duration,
                        question: question,
                        eventId: widget.folder.id),
                  );
                } else {
                  await _foldersApi.updateQuestionsForEventId(
                    Question(
                        id: id,
                        duration: duration,
                        question: question,
                        eventId: widget.folder.id),
                  );
                }

                fetchQuestions(widget.folder.id);
              });
        });
  }
}

class QuestionTile extends StatelessWidget {
  final Question question;
  final int index;
  final Function(Question question) onEdit;
  final Function(Question question) onDelete;

  const QuestionTile(
      {Key key, this.question, this.index, this.onDelete, this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(context, "Q.No ${index + 1} : ${question.question}"),
                text(context,
                    "Allowed Video Duration : ${question.duration.toString()} sec"),
              ],
            ),
            ContextMenu<MenuItem>(
                onSelected: (item) {
                  if (item == MenuItem.Edit) {
                    onEdit(question);
                  } else {
                    onDelete(question);
                  }
                },
                onCanceled: () {},
                itemBuilder: (BuildContext context) {
                  return List<PopupMenuEntry<MenuItem>>.generate(
                      MenuItem.values.length * 2 - 1, (int index) {
                    if (index.isEven) {
                      final item = MenuItem.values[index ~/ 2];
                      return ContextMenuItem<MenuItem>(
                          value: item, text: item.text);
                    } else {
                      return ContextDivider();
                    }
                  });
                },
                child: Container())
          ],
        ),
      ),
    );
  }
}
