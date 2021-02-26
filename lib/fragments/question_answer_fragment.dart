import 'package:camera/camera.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/no_folder_widget.dart';
import 'package:eventklip/models/question.dart';
import 'package:eventklip/screens/capture_screen.dart';
import 'package:eventklip/ui/parts/eventklip_video_player.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/view_models/qr_user_state.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class QuestionAndAnswer {
  final String questionLabel;
  final String videoUrl;
  final bool isAnswered;

  QuestionAndAnswer(this.questionLabel,
      {this.videoUrl, this.isAnswered = false});
}

class QuestionAnswerFragment extends StatefulWidget {
  @override
  _QuestionAnswerFragmentState createState() => _QuestionAnswerFragmentState();
}

class _QuestionAnswerFragmentState extends State<QuestionAnswerFragment>
    with AutomaticKeepAliveClientMixin {
  var selectedQuestionIndex = 0;
  QrUserState _provider;
  List<Question> _questions;
  Map<String, double> _mediaProgress = {};

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBarWidget(
        'Questions',
        showBack: false,
        color: navigationBackground,
        textColor: Colors.white,
      ),
      body: Consumer<QrUserState>(
        builder: (context, state, child) {
          _provider = state;
          _questions = _provider.questions;
          return RefreshIndicator(
            onRefresh: ()=>_provider.fetchQuestions(),
            child: Padding(
              padding: const EdgeInsets.all(spacing_standard_new),
              child: Stack(
                children: [
                  _questions.isNotEmpty
                      ? buildBody()
                      : NoFolderWidget(
                          title: "No questions found",
                          subtitle: "",
                        ),
                  Loader()
                      .withSize(height: 40, width: 40)
                      .center()
                      .visible(_provider.loading)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Column buildBody() {
    Question _question = _questions[selectedQuestionIndex];
    bool _answered = _question.answerUrl != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _answered
            ? EventklipVideoPlayer(
                videoUrl: _question.answerUrl,
                videoTitle: _question.question,
                disableNavigations: true,
                onVideoEnd: () {
                  setState(() {
                    selectedQuestionIndex =
                        selectedQuestionIndex < _questions.length - 1
                            ? selectedQuestionIndex + 1
                            : 0;
                  });
                },
              ).paddingBottom(spacing_standard_new)
            : SizedBox(
                height: MediaQuery.of(context).size.width * 9 / 16,
                child: NoFolderWidget(
                  title: "No video available",
                  subtitle: "Videos become available once you have posted them",
                ),
              ).paddingBottom(spacing_standard_new),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: selectedQuestionIndex == position
                      ? Border.all(color: colorPrimary, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: buildQuestionWidget(position, context),
              ).paddingOnly(bottom: 8);
            },
            itemCount: _questions.length,
          ),
        )
      ],
    );
  }

  GestureDetector buildQuestionWidget(int position, BuildContext context) {
    Question _question = _questions[position];
    bool _answered = _question.answerUrl != null;
    double _questionUploadProgress =
        _answered ? 1 : _mediaProgress[_question.id] ?? 0;
    return GestureDetector(
      onTap: () {
        setState(() => selectedQuestionIndex = position);
        if (!_answered) {
          postAnswer(context, position);
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6, top: 6),
                      child: Icon(
                        _answered ? Icons.check_circle : Icons.add,
                        color: Colors.greenAccent,
                      ),
                    ),
                    CircularProgressIndicator(
                      value: _questionUploadProgress,
                      strokeWidth: 2,
                      backgroundColor: Colors.transparent,
                    )
                  ],
                ),
              ),
              Flexible(
                child: text(context, _question.question, isLongText: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void postAnswer(BuildContext context, int position) async {
    XFile _file;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CaptureScreen(
          cameraEnabled: false,
          onVideoCaptured: (XFile file) => _file = file,
        ),
      ),
    );
    if (_file != null) {
      String _questionId = _provider.questions[position].id;
      _provider.postAnswer(
        _file.path,
        position,
        (count, total) {
          setState(() {
            double progress = count / total;
            if (_mediaProgress.containsKey(_questionId)) {
              _mediaProgress[_questionId] = progress;
            } else {
              _mediaProgress.addAll({_questionId: progress});
            }
          });
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
