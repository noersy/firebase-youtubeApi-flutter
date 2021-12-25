import 'dart:ui';

import 'package:challenge_intern_veturo/providers/main_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ScreenTwo extends StatefulWidget {
  final VoidCallback callback;

  const ScreenTwo({Key? key, required this.callback}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          onPressed: widget.callback,
          icon: const Icon(Icons.list),
        ),
        title: const Text("List Materi Pembelajaran"),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
        future: Provider.of<MainProviders>(context).getVideos(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot<Object?>>> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(snapshot.data?[index].get("title") ?? ""),
                subtitle: const Text("Dari Sub Bab 1"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FormMateri(
                        id: snapshot.data?[index].get("id"),
                        title: snapshot.data?[index].get("title"),
                        url: snapshot.data?[index].get("url"),
                        callback: () => setState(() {}),
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<MainProviders>(context, listen: false)
                        .deleteVideo(id: snapshot.data?[index].get("id") ?? "");
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FormMateri(
                callback: () {
                  setState(() {});
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormMateri extends StatefulWidget {
  final VoidCallback callback;
  final String? title, url, id;

  const FormMateri({Key? key, required this.callback, this.title, this.url, this.id})
      : super(key: key);

  @override
  _FormMateriState createState() => _FormMateriState();
}

class _FormMateriState extends State<FormMateri> {
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerUrl = TextEditingController();
  bool isValid = false;
  @override
  void initState() {
    if (widget.url != null) {
      _controllerUrl = TextEditingController(text: widget.url);
    }
    if (widget.title != null) {
      _controllerTitle = TextEditingController(text: widget.title);
    }

    super.initState();
  }


  String? errorNama;
  String? errorurl;
  _checkInfo() async {
    String? videoId = YoutubePlayer.convertUrlToId(_controllerUrl.text);

    final items = await Provider.of<MainProviders>(context, listen: false).checkVideo(videoId ?? "");

    print(items.items.isEmpty);

    if (_controllerTitle.text.isEmpty) {
      setState(() {
        errorNama = "Nama Tidak Boleh Ksong";

      });
      return;
    }

    if(_controllerUrl.text.isEmpty){
      setState(() {
        errorurl = "Tidak Boleh Kosong";
      });
      return;
    }

    if(items.items.isEmpty){
      setState(() {
        errorurl = "Url tidak valid";
      });
      return;
    }

    errorNama = null;
    errorurl = null;

    widget.callback();
    Navigator.of(context).pop();

    if (widget.url != null) {
      Provider.of<MainProviders>(context, listen: false)
          .updateVideo(
        id: widget.id,
        title: _controllerTitle.text,
        url: _controllerUrl.text,
      );
    } else {
      Provider.of<MainProviders>(context, listen: false)
          .createVideo(
        id: items.items.first.id,
        title: _controllerTitle.text,
        url: _controllerUrl.text,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Form Materi Pembelajaran"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controllerTitle,
              decoration:  InputDecoration(
                errorText: errorNama,
                labelText: "Masukan Nama Materi",
              ),
            ),
            TextFormField(
              controller: _controllerUrl,
              decoration: InputDecoration(
                errorText: errorurl,
                labelText: "Masukan Url Youtube Materi",
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
              ),
              onPressed: () {
                _checkInfo();
              },
              child: const Text("Simpan Data"),
            )
          ],
        ),
      ),
    );
  }
}
