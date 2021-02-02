import 'package:eventklip/models/add_comment_payload.dart';
import 'package:eventklip/models/comment_model.dart';
import 'package:eventklip/ui/widgets/add_comment_widget.dart';
import 'package:eventklip/ui/widgets/context_menu.dart';
import 'package:eventklip/ui/widgets/user_avatar_widget.dart';
import 'package:eventklip/utils/app_widgets.dart';
import 'package:eventklip/utils/constants.dart';
import 'package:eventklip/utils/resources/colors.dart';
import 'package:eventklip/utils/resources/size.dart';
import 'package:eventklip/utils/utility.dart';
import 'package:eventklip/view_models/app_state.dart';
import 'package:eventklip/view_models/video_detail_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:eventklip/utils/widget_extensions.dart';

class CommentFragment extends StatefulWidget {
  final videoId;
  final Function onClosePressed;

  final Function(Duration) seekVideoTo;

  CommentFragment(this.videoId, this.seekVideoTo, this.onClosePressed);

  @override
  _CommentFragmentState createState() => _CommentFragmentState();
}

class _CommentFragmentState extends State<CommentFragment> {
  final comments = [];

  @override
  Widget build(BuildContext context) {
    var commentSection = Container(
        child: Row(
      children: [
        UserAvatarWithInitials(
          Provider.of<EventklipAppState>(context, listen: false)
              .userProfile
              .fullname ?? "??",
          size: 35,
        ).paddingRight(spacing_standard_new),
        text(
          context,
          "Add a comment .....",
        ),
      ],
    ).paddingAll(spacing_standard_new));
    return Consumer<VideoDetailState>(
      builder: (BuildContext context, value, Widget child) {
        final comments = value.comments;
        comments.sortByTimeAscending();
        return Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      offset: const Offset(0, -2),
                      blurRadius: 8.0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headingText(context, "Comments  ${comments?.length ?? ""}")
                      .paddingAll(ts_medium_small),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      widget.onClosePressed();
                    },
                  ),
                ],
              ),
            ),
            value.status == FetchStatus.loading
                ? LinearProgressIndicator(
                    minHeight: 1,
                  )
                : Container(),
            Expanded(
              child: comments != null
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        if (index == 0)
                          return commentSection.onTap(
                              () => showTextFieldForComment(context));
                        return CommentTile(comments[index - 1],
                            (duration) {
                          widget.seekVideoTo(duration);
                        });
                      },
                      padding: EdgeInsets.zero,
                      itemCount: comments.length + 1,
                      separatorBuilder:
                          (BuildContext context, int index) => Divider(
                        color: Colors.grey,
                        height: 0,
                      ),
                    )
                  : value.status == FetchStatus.loading
                      ? Loader()
                      : Container(),
            ),
          ],
        );
      },
    );
  }

  showTextFieldForComment(context) {
    final provider = Provider.of<VideoDetailState>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ListenableProvider.value(
            value: provider,
            child: AddCommentWidget(
              onCommentAddClicked: _onCommentAddClicked,
            ),
          );
        });
  }

  Future<void> _onCommentAddClicked(String comment, String timeSpan) async {
    final provider = Provider.of<VideoDetailState>(context, listen: false);
    print("Coment $comment");
    if (comment.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    await provider.addComment(AddCommentPayload(
      comment: comment.trim(),
      timeSpan: timeSpan,
      videoId: widget.videoId,
    ));
  }
}

class CommentTile extends StatelessWidget {
  final Comment comment;
  final Function(Duration) onClickTimeSpan;

  const CommentTile(this.comment, this.onClickTimeSpan);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatarWithInitials(
          comment.username ?? "??",
          size: 35,
        ).paddingOnly(right: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text(context, comment.commentExpressionTitle),
              RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        onClickTimeSpan(
                            convertTimeSpanToDuration(comment.timeSpan));
                      },
                    text:
                        comment.timeSpan != null ? "${comment.timeSpan} " : "",
                    children: [
                      TextSpan(
                          text: comment.comment,
                          style: TextStyle(
                              color: textColorPrimary,
                              fontFamily: font_regular,
                              fontSize: ts_medium,
                              letterSpacing: 0.1))
                    ],
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: font_regular,
                        fontSize: ts_medium,
                        letterSpacing: 0.1)),
              ),
            ],
          ),
        ),
        ContextMenu<MenuItem>(
                onSelected: (item) {
                  if (item == MenuItem.Edit) {
                    showTextFieldForComment(context);
                  } else {
                    Provider.of<VideoDetailState>(context, listen: false)
                        .deleteComment(comment.id);
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
            .visible(
                Provider.of<EventklipAppState>(context).userProfile.fullname ==
                    comment.username)
      ],
    ).paddingOnly(
        left: spacing_standard_new,
        top: spacing_standard_new,
        bottom: spacing_standard_new);
  }

  showTextFieldForComment(BuildContext context) {
    final provider = Provider.of<VideoDetailState>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ListenableProvider.value(
            value: provider,
            child: AddCommentWidget(
              initialValue: comment.comment,
              onCommentAddClicked: (updatedComment, timeSpan) =>
                  _onCommentEditClicked(updatedComment, provider, timeSpan),
            ),
          );
        });
  }

  _onCommentEditClicked(
      String updatedComment, provider, String timeSpan) async {
    await provider.editComment(AddCommentPayload(
        timeSpan: timeSpan,
        comment: updatedComment.trim(),
        commentId: comment.id));
  }
}

class MenuItem {
  static const Edit = MenuItem._('Edit');
  static const Delete = MenuItem._('Delete');
  static const values = [
    Edit,
    Delete,
  ];

  const MenuItem._(this.text);

  final String text;
}
