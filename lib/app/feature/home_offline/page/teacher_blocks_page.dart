import 'package:auto_size_text/auto_size_text.dart';
import 'package:elesson/app/core/auth/domain/entity/login_response_entity.dart';
import 'package:elesson/app/feature/home_offline/controller/offline_controller.dart';
import 'package:flutter/material.dart';
import '../../../core/block/data/model/block_model.dart';
import '../../../core/home_offline/data/model/TeacherClassroomModel.dart';
import '../widgets/leason_card.dart';

class TeacherBlocksPage extends StatefulWidget {
  final LoginResponseEntity teacherUser;
  final List<BlockModel> list_block;
  final OfflineController offlineController;

  const TeacherBlocksPage({super.key, required this.list_block, required this.offlineController, required this.teacherUser});

  @override
  State<TeacherBlocksPage> createState() => _TeacherBlocksPageState();
}

class _TeacherBlocksPageState extends State<TeacherBlocksPage> {
  int status = 1;

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
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blue, width: 2)),
              child: Row(
                children: [
                  Text("Atualizar lista de Alunos", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  status == 2
                      ? SizedBox(width: 25, height: 25, child: Padding(padding: const EdgeInsets.all(3), child: CircularProgressIndicator(color: Colors.blue)))
                      : Icon(status == 1 ? Icons.download_for_offline_outlined : Icons.download_done, color: status == 1 ? Colors.blue : Colors.green),
                ],
              ),
            ),
            onPressed: () async {
              setState(() {
                status = 2;
              });

              List<TeacherClassroomModel> studentsTeacherClassroom = await widget.offlineController.downloadStudentsOfTeacher(widget.teacherUser.teacher_id!);
              await widget.offlineController.saveStudentsOfTeacher(widget.teacherUser.teacher_id!, studentsTeacherClassroom);

              setState(() {
                status = 0;
              });

            },
          ),
        ],
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
