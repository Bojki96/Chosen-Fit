import 'dart:io';
import 'package:chosen/buttons.dart';
import 'package:chosen/loadingdata.dart';
import 'package:chosen/providers/client.dart';
import 'package:chosen/providers/imagepicker.dart';
import 'package:chosen/providers/meals.dart';
import 'package:chosen/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WeeklyUpdate extends StatefulWidget {
  WeeklyUpdate({Key key}) : super(key: key);

  @override
  State<WeeklyUpdate> createState() => _WeeklyUpdateState();
}

class _WeeklyUpdateState extends State<WeeklyUpdate> {
  TextEditingController weightController = TextEditingController();
  double fontSize = 21;
  String tjedan;
  String datumNedjelje;
  String weight;
  String admin;
  bool loadingWidget = false;
  loadingWidgetFunction(bool loading) {
    setState(() {
      loadingWidget = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    var imageChosen = Provider.of<ChooseImage>(context);
    var weeklyUpdate = Provider.of<DailyUpdateInput>(context);
    Map weeklyUpdateRoute = ModalRoute.of(context).settings.arguments;
    tjedan = weeklyUpdateRoute['tjedan'];
    datumNedjelje = weeklyUpdateRoute['datumNedjelje'];
    weight = weeklyUpdateRoute['weight'];
    admin = weeklyUpdateRoute['admin'];
    if (weight != null) {
      weightController.value = weightController.value.copyWith(text: weight);
    }
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 95, 60, 146),
                  ),
                  child: Text(
                    'Tjedni unos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize + 14,
                    ),
                  ),
                ),
                Positioned(
                    top: 6,
                    left: 10,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ))),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 89, 48, 150),
              ),
              child: Text(
                tjedan,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize - 3,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: [
                  Text(
                    'Težina:',
                    style: TextStyle(
                        fontSize: fontSize + 3,
                        color: Color.fromARGB(255, 95, 60, 146)),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  LimitedBox(
                    maxWidth: 82,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: weightController,
                      readOnly: weight != null ? true : false,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSize + 3),
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 95, 60, 146))),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 95, 60, 146)),
                        ),
                      ),
                      onChanged: (value) {
                        weightController.value =
                            weightController.value.copyWith(text: value);
                        weeklyUpdate.setWeight(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'kg',
                    style: TextStyle(
                        fontSize: fontSize + 3,
                        color: Color.fromARGB(255, 95, 60, 146)),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            PicturePick(
                fontSize: fontSize, datumNedjelje: datumNedjelje, admin: admin),
          ]),
        ),
        !imageChosen.getImageNull
            ? const SizedBox()
            : admin == null
                ? Center(
                    child: Buttons(
                      gumb: 'Save',
                      pickingImage: 'Yes',
                      date: datumNedjelje,
                      loadingWidgetCallBack: loadingWidgetFunction,
                    ),
                  )
                : const SizedBox(),
        loadingWidget ? LoadingData(text: 'Spremanje') : const SizedBox()
      ]),
    ));
  }
}

class PicturePick extends StatefulWidget {
  const PicturePick(
      {Key key,
      @required this.fontSize,
      @required this.datumNedjelje,
      this.admin})
      : super(key: key);
  final double fontSize;
  final String datumNedjelje;
  final String admin;
  @override
  State<PicturePick> createState() => _PicturePickState();
}

class _PicturePickState extends State<PicturePick> {
  File image;
  List<File> files = [null, null, null];
  List pictures = [
    'Slika s prednje strane:',
    'Slika sa stražnje strane:',
    'Slika s bočne strane:'
  ];
  List urls = [null, null, null];

  Future getImages(String clientID) async {
    return await FireStorage.getImages(
        id: clientID, date: widget.datumNedjelje);
  }

  @override
  void initState() {
    var imageChosen = Provider.of<ChooseImage>(context, listen: false);
    var client = Provider.of<Client>(context, listen: false);
    getImages(client.getClientData['id']).then((value) {
      setState(() {
        urls = value;
      });
      if (urls.contains(null)) {
        imageChosen.containsNull(true);
      } else {
        imageChosen.containsNull(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var imageChosen = Provider.of<ChooseImage>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 95, 60, 146)),
              child: Text(pictures[i],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.fontSize + 5,
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 50),
                alignment: Alignment.center,
                constraints:
                    const BoxConstraints(maxHeight: 500, maxWidth: 400),
                height: 450,
                child: urls[i] != null
                    ? GestureDetector(
                        onLongPress: () async {
                          if (widget.admin != null) {
                            await canLaunch(urls[i])
                                ? await launch(urls[i])
                                : null;
                          }
                        },
                        child: Image.network(
                          urls[i],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                                  ? child
                                  : LoadingData(
                                      text: 'Učitavanje slike',
                                      imagePicked: 'Yes'),
                        ),
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: widget.admin != null
                            ? null
                            : () async {
                                try {
                                  final pickedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);

                                  if (pickedImage == null) {
                                    return;
                                  } else {
                                    final file = File(pickedImage.path);
                                    setState(() {
                                      files[i] = file;
                                    });
                                    imageChosen.setImages(files);
                                  }
                                } on PlatformException catch (e) {}
                              },
                        child: Container(
                          height: 450,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: files[i] == null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_camera_outlined,
                                      color: Color.fromARGB(255, 95, 60, 146),
                                      size: 40,
                                    ),
                                    Text(
                                        widget.admin == null
                                            ? 'Odaberi sliku'
                                            : 'Slika nije uploadana',
                                        style: TextStyle(
                                            fontSize: widget.fontSize,
                                            color: Color.fromARGB(
                                                255, 95, 60, 146)))
                                  ],
                                )
                              : Image.file(
                                  files[i],
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
              ),
            ),
          ],
        );
      },
      itemCount: pictures.length,
    );
  }
}
