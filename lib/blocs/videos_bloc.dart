import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_fav_app/models/video.dart';

import '../api.dart';

class VideosBloc implements BlocBase{

  Api api;
  List<Video> videos;
  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream; //saida dos dados

  final StreamController<String> _searchController = StreamController<String>(); //entrada de dados
  Sink get inSearch => _searchController.sink;

  VideosBloc(){
    api = Api();
    
    _searchController.stream.listen(_search);
  }

  void _search(String search) async{
    if(search != null){
      _videosController.sink.add([]); // retorna os dados para uma stream de saída
      videos = await  api.search(search);
    }else{
     videos += await api.nextPage();
    }

    _videosController.sink.add(videos); // retorna os dados para uma stream de saída
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

}