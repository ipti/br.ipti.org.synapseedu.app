import 'package:elesson/app/feature/shared/widgets/card_widget.dart';
import 'package:elesson/app/feature/shared/widgets/init_title.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/home/controller/home_controller.dart';
import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomeController taskSelectController;
  final TaskViewController taskViewController;
  final UserProvider userProvider;

  const HomePage({Key? key, required this.taskSelectController, required this.taskViewController, required this.userProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            initTitle(text: "Oi, ${userProvider.user.name}", heightScreen: size.height, bottomMargin: 20),
            Text('INICIAR AVALIAÇÕES', style: TextStyle(color: Color(0XFF6E7291), fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib", fontSize: 18)),
            SizedBox(height: 36.0),
            userProvider.user.user_type_id != 3
                ? Column(
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                              width: size.width * 0.55,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(hintText: 'Digite o ID da Task', border: InputBorder.none),
                                controller: taskSelectController.taskIdController,
                              ),
                            ),
                            taskSelectController.searchButtonStatus == SubmitButtonStatus.Idle
                                ? GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      taskSelectController.submitSearchTaskById(context,taskViewController);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      width: size.width * 0.2,
                                      height: size.height * 0.05,
                                      child: Center(
                                        child: Text(
                                          'BUSCAR',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
                                    width: size.width * 0.2,
                                    height: size.height * 0.05,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 36.0),
                    ],
                  )
                : Container(),
            ElessonCardWidget(
              blockDone: false,
              backgroundImage: "assets/img/mate.png",
              text: "MATEMÁTICA",
              textModulo: 'MÓDULO 1',
              screenWidth: size.width,
              onTap: (value) => null,
              context: context,
            ),
            ElessonCardWidget(
              blockDone: false,
              backgroundImage: "assets/img/ling.png",
              text: "LINGUAGEM",
              textModulo: 'MÓDULO 1',
              screenWidth: size.width,
              onTap: (value) => null,
              context: context,
            ),
            ElessonCardWidget(
              blockDone: true,
              backgroundImage: "assets/img/cien.png",
              text: "CIÊNCIAS",
              textModulo: 'MÓDULO 1',
              screenWidth: size.width,
              onTap: (value) => null,
              context: context,
            ),
            Text('AVALIAÇÕES CONCLUÍDAS', style: TextStyle(color: Color(0XFF6E7291), fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib", fontSize: 18)),
            SizedBox(height: 10.0),
            ElessonCardWidget(
              blockDone: true,
              backgroundImage: "assets/img/mate.png",
              text: "MATEMÁTICA",
              textModulo: 'MÓDULO 1',
              screenWidth: size.width,
              onTap: (value) => null,
              context: context,
            ),
            ElessonCardWidget(
              blockDone: true,
              backgroundImage: "assets/img/ling.png",
              text: "LINGUAGEM",
              textModulo: 'MÓDULO 1',
              screenWidth: size.width,
              onTap: (value) => null,
              context: context,
            ),
            ElessonCardWidget(
              blockDone: true,
              backgroundImage: "assets/img/cien.png",
              text: "CIÊNCIAS",
              textModulo: 'MÓDULO 1',
              screenWidth: size.width,
              onTap: (value) => null,
              context: context,
            )
          ],
        ),
      ),
    );
  }
}
