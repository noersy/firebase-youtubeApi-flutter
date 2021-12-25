import 'package:challenge_intern_veturo/models/VideoList.dart';
import 'package:challenge_intern_veturo/providers/main_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ScreenOne extends StatefulWidget {
  final VoidCallback callback;

  const ScreenOne({Key? key, required this.callback}) : super(key: key);

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          onPressed: widget.callback,
          icon: const Icon(Icons.list),
        ),
        title: const Text("Materi"),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
        future: Provider.of<MainProviders>(context).getVideos(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot<Object?>>> snapshot) {
          return ListView.separated(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data?[index].get("title") + " - Part 1" ?? "",
                      style: const TextStyle(
                        fontSize: 23,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                subtitle:  YoutubeWiget(id : snapshot.data?[index].get("id") ?? ""),
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              );
          },
          );
        },
      ),
    );
  }
}


class YoutubeWiget extends StatefulWidget {
  final String id;
  const YoutubeWiget({Key? key, required this.id}) : super(key: key);

  @override
  _YoutubeWigetState createState() => _YoutubeWigetState();
}

class _YoutubeWigetState extends State<YoutubeWiget> {
  String? videoId;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        enableCaption: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: _controller != null ? YoutubePlayer(
        controller: _controller!,
        liveUIColor: Colors.amber,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.white,
        onReady: () {
          if (kDebugMode) {
            print('Player is ready.');
          }
        },
      ) : null,
    );
  }
}
