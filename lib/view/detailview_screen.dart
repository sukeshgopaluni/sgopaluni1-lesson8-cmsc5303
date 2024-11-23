import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/detailview_controller.dart';
import 'package:lesson6/model/detailview_model.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:lesson6/view/web_image.dart';

class DetailViewScreen extends StatefulWidget {
  const DetailViewScreen({required this.photoMemo, super.key});

  static const routeName = '/detailViewScreen';

  final PhotoMemo photoMemo;

  @override
  State<StatefulWidget> createState() {
    return DetailViewState();
  }
}

class DetailViewState extends State<DetailViewScreen> {
  late DetailViewController con;
  late DetailViewModel model;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = DetailViewController(this);
    model = DetailViewModel(
      user: currentUser!,
      photoMemo: widget.photoMemo,
    );
  }

  void callSetState(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${model.user.email}: Detail View'),
        actions: [
          model.editMode
              ? IconButton(
                  onPressed: con.update,
                  icon: const Icon(Icons.check),
                )
              : IconButton(
                  onPressed: con.edit,
                  icon: const Icon(Icons.edit),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                photoEditView(),
                TextFormField(
                  enabled: model.editMode,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                  ),
                  initialValue: model.tempMemo.title,
                  validator: PhotoMemo.validateTitle,
                  onSaved: model.saveTitle,
                ),
                TextFormField(
                  enabled: model.editMode,
                  decoration: const InputDecoration(
                    hintText: 'Enter Memo',
                  ),
                  initialValue: model.tempMemo.memo,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  validator: PhotoMemo.validateMemo,
                  onSaved: model.saveMemo,
                ),
                TextFormField(
                  enabled: model.editMode,
                  decoration: const InputDecoration(
                    hintText: 'Enter sharedWith',
                  ),
                  initialValue: model.tempMemo.sharedWith.join(' '),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: PhotoMemo.validateSharedWith,
                  onSaved: model.saveSharedWith,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget photoEditView() {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: model.photo == null
              ? WebImage(url: model.tempMemo.photoURL)
              : (kIsWeb ? Image.memory(model.photo) : Image.file(model.photo)),
        ),
        if (model.editMode)
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              color: Colors.blue[100],
              child: PopupMenuButton(
                onSelected: con.getPhoto,
                itemBuilder: (BuildContext context) {
                  if (kIsWeb) {
                    return [
                      PopupMenuItem(
                        value: CameraOrGallery.gallery,
                        child: Text(CameraOrGallery.gallery.name.toUpperCase()),
                      ),
                    ];
                  } else {
                    return [
                      for (var source in CameraOrGallery.values)
                        PopupMenuItem(
                          value: source,
                          child: Text(source.name.toUpperCase()),
                        ),
                    ];
                  }
                },
              ),
            ),
          ),
        if (model.progressMessage != null)
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Container(
              color: Colors.blue[100],
              child: Text(
                model.progressMessage!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
      ],
    );
  }
}