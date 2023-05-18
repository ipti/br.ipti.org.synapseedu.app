import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:flutter/material.dart';

class TextMultimedia extends StatelessWidget {
  final ElementModel elementModel;
  const TextMultimedia({Key? key, required this.elementModel}) : super(key: key);

  //Visibility(visible: widget.showAudioComponent, child: SoundWidgetButton(element: widget.elementModel), replacement: SizedBox(width: 24)),

  Future<void> loadText() async {
    debugPrint("[TextInputMultimedia] Iniciando myFuture");
    widget.elementModel.textController.text = await Provider.of<TaskProvider>(context, listen: false).getTextMultimedia(widget.elementModel.multimedia_id!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 630,
      child: Container(
        width: 500,
        child: FutureBuilder(
            future: elementModel.textController.text == '' ? loadText() : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData && widget.elementModel.textController.text == "") {
                widget.elementModel.textController.text = snapshot.data.toString();
              }
              return TextFormField(
                keyboardType: TextInputType.multiline,
                controller: widget.elementModel.textController,
                decoration: InputDecoration(fillColor: editorPrimaryLight.shade50),
                minLines: 1,
                maxLines: 3,
                onTap: () {
                  Provider.of<CommentProvider>(context, listen: false).unselectComment();
                  _taskProvider.changeSelectedElement(widget.elementModel);
                },
                onChanged: (value) {
                  if (!widget.elementModel.isEdited) {
                    widget.elementModel.isEdited = true;
                  }
                },
              );
            }),
      ),
    );
  }
}
