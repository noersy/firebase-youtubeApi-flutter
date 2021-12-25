import 'dart:convert';

import 'package:challenge_intern_veturo/models/VideoInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/youtube_api.dart';

class MainProviders extends ChangeNotifier {
  static String key = 'AIzaSyDa5TIEmXT4RbEfdWWN0nnd5HckeeOxp5w';
  YoutubeAPI ytApi = YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];

  Future<VideoInfo> checkVideo(String id) async {
    String string = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$id&key=$key";
    var data = await http.get(Uri.parse(string));
    // print(data.body);
    VideoInfo video = videoInfoFromJson(jsonEncode(jsonDecode(data.body)));
    return video;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getVideos() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot _query = await _firestore.collection("videos").get();
      return _query.docs;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return [];
  }

  Future<int> createVideo({id, title, url}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentReference _refernce = _firestore.collection("videos").doc(id);

      final data = {
        "id": id,
        "title": title,
        "url": url,
      };

      _refernce.set(data);
      return 200;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return 400;
  }

  Future<int> updateVideo({id, title, url}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {

      DocumentReference _refernce = _firestore.collection("videos").doc(id);

      final data = {
        "title": title,
        "url": url,
      };

      _refernce.update(data);
      return 200;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return 400;
  }

  Future<int> deleteVideo({id}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentReference _refernce = _firestore.collection("videos").doc(id);

      _refernce.delete();
      return 200;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return 400;
  }
}
