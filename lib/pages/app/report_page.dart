import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_state.dart';
import 'package:locainfo/utilities/loading_screen/loading_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ReportPage extends StatefulWidget {
  final Post post;

  const ReportPage({super.key, required this.post});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late final TextEditingController _textControllerReason;

  @override
  void initState() {
    _textControllerReason = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textControllerReason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Submitting...',
          );
        } else {
          LoadingScreen().hide();
        }
        if (state is PostStateCreatePostSuccessful) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: GradientText(
            'Report',
            style: CustomFontStyles.appBarTitle,
            colors: const [AppColors.lighterBlue, AppColors.darkestBlue],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Help us maintain a positive community. Briefly describe the issue and provide any relevant details or context. Your feedback is crucial for prompt action.",
                  style: CustomFontStyles.instruction,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Report for Post Titled '${widget.post.title}'",
                  style: CustomFontStyles.textFieldLabel,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _textControllerReason,
                  obscureText: false,
                  enableSuggestions: true,
                  autocorrect: true,
                  maxLines: 6,
                  maxLength: 250,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: "Reason...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
                const SizedBox(height: 45),
                MyButton(
                    onPressed: () {
                      context.read<PostBloc>().add(PostEventCreateReport(
                            widget.post,
                            _textControllerReason.text,
                          ));
                    },
                    text: 'Submit Report'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
