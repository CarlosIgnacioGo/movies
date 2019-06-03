import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/models/actor_model.dart';

class PeliculasProvider {
  String _apikey   = '62814b4d7a00eef5fb35be67719d06e7';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async{
    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key'  : _apikey,
      'language' : _language
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopular() async{
    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular',{
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;

    return resp;
  }

  Future<List<Actor>> getActores(String peliculaId) async{
    final url = Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key'  : _apikey,
      'language' : _language,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final actores = Actores.fromJsonList(decodedData['cast']);

    return actores.listaActores;

  }

  Future<List<Pelicula>> buscarPelicula(String query) async{
    final url = Uri.https(_url, '3/search/movie',{
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query
    });

    return await _procesarRespuesta(url);
  }

  
}