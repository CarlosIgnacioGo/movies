import 'package:flutter/material.dart';

import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/provider/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = PeliculasProvider();

  final peliculas = [
    'cacaman',
    'holaman',
    'culoman 2'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Putiman'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    query = seleccion;

    return Center(
      child: Container(
        height: 100.0,
        width:  1000.0,
        color: Colors.red,
        child: Text(seleccion)
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){
          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context,null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula );
                },
              );
            }).toList(),
          );
        }else{
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    ); 
  }

  //@override
  //Widget buildSuggestions(BuildContext context) {
  //  final listaSugerida = (query.isEmpty) ? peliculasRecientes : peliculas.where((p)=> p.toLowerCase().startsWith(query.toLowerCase())).toList();

  //  return ListView.builder(
    //  itemCount: listaSugerida.length,
      //itemBuilder: (context, i) {
        //return ListTile(
          //leading: Icon(Icons.movie),
          //title: Text(listaSugerida[i]),
          //onTap: (){
            //seleccion = listaSugerida[i];
            //showResults(context);
          //},
        //);
      //},
    //);
  //}

}