import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voice_assistant_provider.dart';
import '../screens/voice_assistant_screen.dart';

class FloatingAssistantButton extends StatelessWidget {
  const FloatingAssistantButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voiceAssistantProvider = Provider.of<VoiceAssistantProvider>(context);

    return Positioned(
      bottom: 24,
      right: 24,
      child: FloatingActionButton(
        heroTag: 'assistant_button',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
        onPressed: () {
          if (voiceAssistantProvider.isVisible) {
            voiceAssistantProvider.toggleVisibility();
          } else {
            voiceAssistantProvider.toggleVisibility();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const VoiceAssistantScreen(),
            ).then((_) {
              if (voiceAssistantProvider.isVisible) {
                voiceAssistantProvider.toggleVisibility();
              }
            });
          }
        },
      ),
    );
  }
}
