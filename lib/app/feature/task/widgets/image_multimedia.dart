import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:flutter/material.dart';

class ImageMultimedia extends StatefulWidget {
  double? width;
  ElementModel elementModel;
  ImageMultimedia({Key? key, required this.elementModel, this.width = 100}) : super(key: key);

  @override
  State<ImageMultimedia> createState() => _ImageMultimediaState();
}

class _ImageMultimediaState extends State<ImageMultimedia> {
  TaskProvider? _taskProvider;

  Future<List<int>> getBytesByMultimediaId() async {
    debugPrint("[ImageInputMultimedia] Carregando imagem ${widget.elementModel.multimedia_id}");
    String sulfixOfLink = await Provider.of<TaskProvider>(context, listen: false).getImageMultimedia(widget.elementModel.multimedia_id!);
    print("[ImageInputMultimedia] nome: $sulfixOfLink");
    return await getBytesImage(sulfixOfLink);
  }

  @override
  void didChangeDependencies() {
    _taskProvider ??= Provider.of<TaskProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Widget? childImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: GestureDetector(
        onTap: () {
          debugPrint('Clicando no Component [Position: ${widget.elementModel.position}]');
          _taskProvider!.changeSelectedElement(widget.elementModel);
        },
        child: Container(
          width: 160,
          height: 160,
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              // Não existe imagem definidam ainda
              if (widget.elementModel.multimedia_id == null) {
                childImage = Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(7),
                  child: ClipRRect(borderRadius: BorderRadius.circular(7), child: Image.asset('assets/images/placeholder-image.png')),
                );
              }
              else if (taskProvider.selectedElement == widget.elementModel && taskProvider.imageChangedFlag || childImage == null) {
                taskProvider.imageChangedFlag = false;
                childImage = FutureBuilder(
                  future: getBytesByMultimediaId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) return CircularProgressIndicator();
                    if (snapshot.hasError) return Center(child: Text('Erro ao carregar imagem'));
                    if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                      Uint8List imageData = Uint8List.fromList(snapshot.data as List<int>);
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          image: DecorationImage(image: MemoryImage(imageData), fit: BoxFit.cover),
                        ),
                      );
                    }
                    return Container();
                  },
                );
              }
              return childImage!;
            },
          ),
        ),
      ),
    );
  }
}
