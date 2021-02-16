import 'package:eventklip/ui/parts/eventklip_video_player.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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

  final question = [
    QuestionAndAnswer("How was your event?",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        isAnswered: true),
    QuestionAndAnswer("How did you find this party palace?",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
        isAnswered: true),
    QuestionAndAnswer("Bishal bazaar ko kasto lagyo?",
        videoUrl: null, isAnswered: false)
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarWidget('Questions',
          showBack: false,
          color: navigationBackground,
          textColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(spacing_standard_new),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventklipVideoPlayer(
              videoUrl: question[selectedQuestionIndex].videoUrl,
              videoTitle: "hehe",
              disableNavigations: true,
              onVideoEnd: () {
                setState(() {
                  selectedQuestionIndex =
                      selectedQuestionIndex < question.length - 1
                          ? selectedQuestionIndex + 1
                          : 0;
                });
              },
            ).paddingBottom(spacing_standard_new),
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
                      if (question[position].isAnswered) {
                        setState(() {
                          selectedQuestionIndex = position;
                        });
                      } else {}
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
                                question[position].isAnswered
                                    ? Icons.check_circle
                                    : Icons.add,
                                color: Colors.greenAccent,
                              ).paddingRight(spacing_standard_new),
                              text(context, question[position].questionLabel),
                            ],
                          ),
                          question[position].isAnswered
                              ? Container()
                              : Icon(Icons.video_call)
                        ],
                      ),
                    )),
                  ),
                ).paddingOnly(bottom: 8);
              },
              padding: EdgeInsets.all(0),
              itemCount: question.length,
            ))
          ],
        ),
      ),
    );
  }
}
