class Viajes{
  var property idiomas
  
  method diasViaje()
  method implicaEsfuerzo()
  method sirveBronceo()= true
  method viajeInteresante()= idiomas.size()> 1
  method actividadRecomendadaPara(unSocio){
    return self.viajeInteresante() && unSocio.leAtraeActividad(self) && !unSocio.actividades().contains(self)}

}

class ViajeDePlaya inherits Viajes{
  var property largo
 override method diasViaje()= largo/500
  override method implicaEsfuerzo()= largo>1200
}

class ViajeCiudad inherits Viajes{
  var property atraccionesAVisitar
  override method diasViaje()= atraccionesAVisitar/2
  override method implicaEsfuerzo()= atraccionesAVisitar.between(5, 8)
  override method sirveBronceo()= false
  override method viajeInteresante()= super() or atraccionesAVisitar>5
}

class ViajeCiudadTropical inherits ViajeCiudad{
  override method diasViaje()= super() + 1
  
}

class ViajeTrekking inherits Viajes{
  var property kilometros
  var property diasSol
  override method diasViaje() = kilometros/50
  override method implicaEsfuerzo()= 80
  override method sirveBronceo()= diasSol>200 or (diasSol.between(100, 200)&& kilometros>120)
  override method viajeInteresante()= super() or diasSol>140
}

class ClasesGimnasia inherits Viajes{
   override method diasViaje()= 1
   override method implicaEsfuerzo()= true
   override method sirveBronceo()= false
   override method actividadRecomendadaPara(unSocio)= unSocio.edad().between(20, 30)
    method initialize(){
      idiomas.clear()
      idiomas.add("español")
      if(idiomas!=["español"]) self.error("solo se permite idioma español")
    }
}

class TallerLiterario inherits Viajes{
  var librosDisponibles
  override method idiomas() = librosDisponibles.map({l=>l.idioma()})
  override method diasViaje()= librosDisponibles.size() + 1
  override method implicaEsfuerzo(){
    return librosDisponibles.any({l=>l.cantPaginas()>500}) or librosDisponibles.map({l=>l.nombreAutor()}).asSet().size() == 1 && librosDisponibles.size() > 1
  } 
  override method sirveBronceo()= false
  override method actividadRecomendadaPara(unSocio)= unSocio.idioma().size() >1
}

class Libro {
  var property idioma
  var property cantPaginas
  var property nombreAutor
}

class Socio{
  var property edad
  var idiomas
  var property actividades
  var cantMaxActividades
  method realizarActividad(unaActividad) {
      if(actividades.size() == cantMaxActividades){
        throw new Exception(message = "ya realizaste la cantidad maxima de actividades")
      }
      actividades.add(unaActividad)
    }
  method adoraSol(){
    return actividades.all({a=>a.sirveBronceo()})
  }
  method actividadesForzadas(){
    return actividades.map({a=>a.implicaEsfuerzo()})
  }
  method initialize(){
    if(actividades.size()== cantMaxActividades){
      self.error("erorrrr")
    }
  }
  method leAtraeActividad(unaActividad) 
}

class SocioTranquilo inherits Socio{
  override method leAtraeActividad(unaActividad)= unaActividad.diasViaje() >=4 
}

class SocioCoherente inherits Socio{
  override method leAtraeActividad(unaActividad)= self.adoraSol() && unaActividad.sirveBronceo() or unaActividad.implicaEsfuerzo()
    
}

class SocioRelajado inherits Socio{
  override method leAtraeActividad(unaActividad)= idiomas.any({i=>unaActividad.idiomas().contains(i)})
  // !self.idiomasHablados().intersection(unaActividad.idiomas()).isEmpty()
}