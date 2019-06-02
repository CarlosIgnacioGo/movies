import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:movies/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey   = '62814b4d7a00eef5fb35be67719d06e7';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';

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
    final url = Uri.https(_url, '3/movie/popular',{
      'api_key'  : _apikey,
      'language' : _language
    });

    return await _procesarRespuesta(url);
  }
}