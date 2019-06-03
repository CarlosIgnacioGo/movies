class Actores {
  List<Actor> listaActores = List();

  Actores();

  Actores.fromJsonList(List<dynamic>jsonList){
    if(jsonList == null ) return;

    jsonList.forEach((item){
      final actor = Actor.fromJsonMap(item);
      listaActores.add(actor);
    });
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap(Map<String, dynamic> json){
    castId      = json['cast_id'];
    character   = json['character'];
    creditId    = json['credit_id'];
    gender      = json['gender'];
    id          = json['id'];
    name        = json['name'];
    order       = json['order'];
    profilePath = json['profile_path'];
  }

  getPhoto(){
    if(profilePath == null){
      return "https://www.hopkinsmedicine.org/-/media/feature/noimageavailable.ashx?h=260&la=en&w=380&hash=A457CA39862F8CF1EC734AE8854EC90654A704D3";
    }else{
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
