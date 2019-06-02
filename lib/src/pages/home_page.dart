import 'package:flutter/material.dart';

import 'package:movies/src/widgets/card_swiper_widget.dart';

import 'package:movies/src/provider/peliculas_provider.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cine'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        ),
      )
    );
  }

  Widget _swiperTarjetas(){
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return CardSwiper(peliculas: snapshot.data);
        }else{
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
      },
    );
  }

  Widget _footer(context){
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead)
          ),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if(snapshot.hasData){
                return MovieHorizontal(
                  peliculas: snapshot.data, 
                  siguientePagina: peliculasProvider.getPopular
                );
              }else{
                return Center(
                  child: CircularProgressIndicator()
                );
              }
            },
          )
        ],
      ),
    );
  }
}