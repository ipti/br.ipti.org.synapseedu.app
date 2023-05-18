import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:flutter/material.dart';

class AudioMultimedia extends StatefulWidget {
  final ElementModel elementModel;

  const AudioMultimedia({Key? key, required this.elementModel}) : super(key: key);

  @override
  State<AudioMultimedia> createState() => _AudioMultimediaState();
}

class _AudioMultimediaState extends State<AudioMultimedia> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: GestureDetector(
        onTap: () => _taskProvider!.changeSelectedElement(widget.elementModel),
        child: Container(
          width: 500,
          height: 45,
          alignment: Alignment.centerLeft,
          child: IconButton(
            splashRadius: 20,
            onPressed: () async {
              if (widget.elementModel.audioBytes != null) {
                debugPrint("Reproduzindo : ${widget.elementModel.audioBytes!.length}");
                Soundpool soundpool = Soundpool.fromOptions(options: SoundpoolOptions(maxStreams: 3));
                soundpool.loadAndPlayUint8List(widget.elementModel.audioBytes!);
              } else if (widget.elementModel.multimedia_id != null) {
                SoundController _soundController = SoundController();
                await _soundController.getSoundById(widget.elementModel.multimedia_id!).then((name) async {
                  await _soundController.downloadSound(name);
                });
              }
            },
            icon: Icon(Icons.play_arrow, color: editorPrimary, size: 25),
          ),
        ),
      ),
    );
  }
}
