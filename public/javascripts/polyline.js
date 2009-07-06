/*Archivo para modificaciones temporales para impedir conflictos*/
var poly_markers = [];
var poly_latlngs = []
var poly;
//Array para almacenar los recorridos mostrados
var polylines = [];

function initMapNewLine(){
  commonsMap();
  GEvent.addListener(map, "click", function(overlay, latlng){addMarkerNewLine(latlng);});
  
}

function addMarkerNewLine(latlng){
  var marker = new GMarker(latlng, {icon: loadMiniPoint(), draggable: true, bouncy:false,dragCrossMove:true});
  poly_markers.push(marker);
  poly_latlngs.push(latlng);
   
  if(poly_latlngs.length == 2)
  {
    poly = new GPolyline(poly_latlngs, "#000000", 2, 1);
    map.addOverlay(poly);
  }
  else if(poly_latlngs.length > 2)
  {
    poly.insertVertex(poly_latlngs.length, latlng);
  }
    
  /*Eventos de arrastrar, borrar, etc*/
  polilyneEvents(marker);
  
  map.addOverlay(marker);
}


function loadCourse(encoded_course){
  latlngs = decodeLine(encoded_course);
  for(var n=0; n < latlngs.length; n++){
    var latlng = new GLatLng(latlngs[n][0], latlngs[n][1]);
    var marker = new GMarker(latlng, {icon: loadMiniPoint(), draggable: true, bouncy:false,dragCrossMove:true});
    polilyneEvents(marker);
    poly_markers.push(marker);
    poly_latlngs.push(latlng);
    map.addOverlay(marker);
  }
  updatePoly();
}
  
  
function polilyneEvents(marker){
  /*Borramos vertice*/
  GEvent.addListener(marker,"click",function(){
    removePolyVertex(marker);
  });
  /*Movemos un vertice*/
  GEvent.addListener(marker,"drag",function(){
      for(var v=0; v< poly_markers.length; v++){
        if(poly_markers[v] == marker) 
        {
          map.removeOverlay(poly_latlngs[v]);
          poly_latlngs.splice(v,1,marker.getLatLng()); 
          updatePoly(); 
          break;
        }
      }});
}

function removePolyVertex(marker){
  for(var n=0; n < poly_markers.length; n++){
    if(poly_markers[n] == marker)
    {
      map.removeOverlay(poly_markers[n]);
      poly_markers.splice(n,1);poly_latlngs.splice(n,1);
      updatePoly();
      break;
    }                
  }
}

/*Redibuja el polyline*/
function updatePoly(){
  //Polyline
  if(poly != null){map.removeOverlay(poly);}
  poly = new GPolyline(poly_latlngs, "#000000", 2, 1);
  map.addOverlay(poly);
}

function showPolyFromEncoded(encoded_points, color){
   if(color == null)color = "#0000FF"
   poly = GPolyline.fromEncoded({color: color,
                                      weight: 4,
                                      points: encoded_points,
                                      zoomFactor: 32,
                                      levels: "AAA",
                                      numLevels: 4
                                     });
  //Lo guardamos en un array por si hay q borrar una a una                                     
  polylines.push(poly);
  map.addOverlay(poly);

}
