import 'package:auto_size_text/auto_size_text.dart';
import 'package:elesson/app/feature/home_offline/controller/offline_controller.dart';
import 'package:flutter/material.dart';
import '../../../core/block/data/model/block_model.dart';
import '../widgets/leason_card.dart';

class TeacherBlocksPage extends StatefulWidget {
  final List<BlockModel> list_block;
  final OfflineController offlineController;

  const TeacherBlocksPage({super.key, required this.list_block, required this.offlineController});

  @override
  State<TeacherBlocksPage> createState() => _TeacherBlocksPageState();
}

class _TeacherBlocksPageState extends State<TeacherBlocksPage> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Aulas Do professor'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.list_block.length,
        itemBuilder: (context, index) {
          return LeasonCard(offlineController: widget.offlineController, block: widget.list_block[index]);
        },
      ),
    );
  }
}
