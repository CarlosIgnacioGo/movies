import 'package:flutter/material.dart';

import 'package:movies/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    final _pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.3
    );

    _pageController.addListener((){
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ){
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.2 + 15,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _tarjeta(context, peliculas[i] 
        ),
      )
    );
  }

  Widget _tarjeta(context, Pelicula pelicula){
    pelicula.uniqueId = '${pelicula.id}-poster';
    
    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 140.0,
                ),
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption
            )
          ],
        ),
      );

    return GestureDetector(
      child: tarjeta,
      onTap: (){
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }

  List<Widget> _tarjetas(context){
    return peliculas.map((pelicula){
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 140.0,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption
            )
          ],
        ),
      );
    }).toList();
  }
}