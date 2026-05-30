import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/chat/presentation/views/widgets/chat_view_body.dart';
import 'package:takween/core/router/routes.dart';

class ChatView extends StatelessWidget {
  final String projectId;
  final String projectTitle;

  const ChatView({
    super.key,
    required this.projectId,
    required this.projectTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectTitle),
        actions: [
          IconButton(
            tooltip: 'Contract',
            icon: const FaIcon(FontAwesomeIcons.fileContract, size: 18),
            onPressed: () => context.push(
              Routes.contract,
              extra: {
                'projectId': projectId,
                'projectTitle': projectTitle,
              },
            ),
          ),
        ],
      ),
      body: ChatViewBody(projectId: projectId),
    );
  }
}
