import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/sharedwith_controller.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:lesson6/model/sharedwith_model.dart';
import 'package:lesson6/view/web_image.dart';

class SharedWithScreen extends StatefulWidget {
  const SharedWithScreen({super.key});

  static const routeName = '/sharedWithScreen';

  @override
  State<StatefulWidget> createState() {
    return SharedWithState();
  }
}

class SharedWithState extends State<SharedWithScreen> {
  late SharedWithModel model;
  late SharedWithController con;

  @override
  void initState() {
    super.initState();
    model = SharedWithModel(user: currentUser!);
    con = SharedWithController(this);
    con.loadSharedWithList();
  }

  void callSetState(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared with ${model.user.email}'),
      ),
      body: bodyView(),
    );
  }

  Widget bodyView() {
    if (model.loadingErrorMessage != null) {
      return Text('Loading error: ${model.loadingErrorMessage}');
    } else if (model.sharedWithList == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (model.sharedWithList!.isEmpty)
                Text(
                  'No photomemos shared with you',
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              else
                for (var photoMemo in model.sharedWithList!)
                  photoMemoCardView(photoMemo),
            ],
          ),
        ),
      );
    }
  }

  Widget photoMemoCardView(PhotoMemo photoMemo) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WebImage(
              url: photoMemo.photoURL,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Text(
              photoMemo.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(photoMemo.memo),
            Text('Created By: ${photoMemo.createdBy}'),
            Text('Posted At: ${photoMemo.timestamp}'),
            Text('Shared With: ${photoMemo.sharedWith}'),
          ],
        ),
      ),
    );
  }
}