import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/creatememo_controller.dart';
import 'package:lesson6/model/creatememo_model.dart';
import 'package:lesson6/model/photomemo.dart';

class CreateMemoScreen extends StatefulWidget {
  const CreateMemoScreen({super.key});

  static const routeName = '/createMemoScreen';

  @override
  State<StatefulWidget> createState() {
    return CreateMemoState();
  }
}

class CreateMemoState extends State<CreateMemoScreen> {
  late CreateMemoModel model;
  late CreateMemoController con;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    model = CreateMemoModel(user: currentUser!);
    con = CreateMemoController(this);
  }

  void callSetState(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New'),
        actions: [
          IconButton(
            onPressed: con.save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                photoPreview(),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                  autocorrect: true,
                  validator: PhotoMemo.validateTitle,
                  onSaved: model.onSavedTitle,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'memo',
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  validator: PhotoMemo.validateMemo,
                  onSaved: model.onSavedMemo,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Shared with (email list separated by , ;)',
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: PhotoMemo.validateSharedWith,
                  onSaved: model.onSavedSharedWith,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget photoPreview() {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: model.photo == null
              ? const FittedBox(
                  child: Icon(Icons.photo_library),
                )
              : (kIsWeb ? Image.memory(model.photo) : Image.file(model.photo)),
        ),
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
                }),
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
          )
      ],
    );
  }
}