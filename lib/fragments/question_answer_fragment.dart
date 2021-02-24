import 'package:camera/camera.dart';
import 'package:eventklip/fragments/folder_fragment/widgets/no_folder_widget.dart';
import 'package:eventklip/models/question.dart';
import 'package:eventklip/models/user_profile.dart';
import 'package:eventklip/screens/capture_screen.dart';
import 'package:eventklip/screens/shared_preferences.dart';
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

class _QuestionAnswerFragmentState extends State<QuestionAnswerFragment> {
  var selectedQuestionIndex = 0;
  QrUserState _provider;

  @override
  Widget build(BuildContext context) {
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
          List<Question> questions = state.questions;
          return Padding(
            padding: const EdgeInsets.all(spacing_standard_new),
            child: Stack(
              children: [
                questions.isNotEmpty
                    ? buildBody(questions)
                    : NoFolderWidget(
                        title: "No questions found",
                        subtitle: "",
                      ),
                Loader()
                    .withSize(height: 40, width: 40)
                    .center()
                    .visible(state.loading)
              ],
            ),
          );
        },
      ),
    );
  }

  Column buildBody(List<Question> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // EventklipVideoPlayer(
        //   videoUrl: questions[selectedQuestionIndex].question,
        //   videoTitle:
        //       questions[selectedQuestionIndex].question,
        //   disableNavigations: true,
        //   onVideoEnd: () {
        //     setState(() {
        //       selectedQuestionIndex =
        //           selectedQuestionIndex < questions.length - 1
        //               ? selectedQuestionIndex + 1
        //               : 0;
        //     });
        //   },
        // ).paddingBottom(spacing_standard_new),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: selectedQuestionIndex == position
                      ? Border.all(
                          color: colorPrimary,
                          width: 2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (questions[position].isAnswered) {
                      setState(() => selectedQuestionIndex = position);
                    } else {
                      postAnswer(context);
                    }
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                questions[position].isAnswered
                                    ? Icons.check_circle
                                    : Icons.add,
                                color: Colors.greenAccent,
                              ).paddingRight(spacing_standard_new),
                              text(context, questions[position].question),
                            ],
                          ),
                          questions[position].isAnswered
                              ? Container()
                              : Icon(Icons.video_call)
                        ],
                      ),
                    ),
                  ),
                ),
              ).paddingOnly(bottom: 8);
            },
            padding: EdgeInsets.all(0),
            itemCount: questions.length,
          ),
        )
      ],
    );
  }

  void postAnswer(BuildContext context) async {
    XFile _file;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return CaptureScreen(
            cameraEnabled: false,
            onVideoCaptured: (XFile file) async {
              _file = file;
            },
          );
        },
      ),
    );
    /* if (_file != null) {
      final postRes = await _provider
          .postAnswer(_file.path, selectedQuestionIndex, (count, total) {
        print('count $count total $total');
      });
      if (postRes.success) {
    _provider.updateQuestion(selectedQuestionIndex);
      }
    }*/
  }
}
