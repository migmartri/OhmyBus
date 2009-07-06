var centerLatitude = 37.38202518490728;
var centerLongitude = -5.978450775146484;
var map, current_marker, current_stop, startZoom = 13, buses = [], active_lines = [], selected_tab = 0, periodical;


/////////////////////////INICIALIZAMOS LOS MAPAS/////////////////////////

/* Características comunes en todos los mapas */
function commonsMap(){
  map = new GMap2(document.getElementById("map"));
  map.addControl(new GLargeMapControl());      
  map.addControl(new GMapTypeControl());
  map.enableContinuousZoom();
  map.enableScrollWheelZoom();
  map.setCenter(new GLatLng(centerLatitude, centerLongitude), startZoom);
  //map.setMapType(G_HYBRID_MAP);
}

/* Mapa principal*/
function initMainMap()
{
  if (GBrowserIsCompatible()) {
    commonsMap();
    loadStops('main');
    loadAllLines();
    GEvent.addListener(map,"zoomend", function(){if(map.getZoom()<13){map.setZoom(13);}});    
  }
}

/* Mapa stops/index */
function initMapIndexStop(){
  commonsMap();
  loadStops(true);
  loadAllLines();
  GEvent.addListener(map, "click", function(overlay, latlng){if(!overlay){addMarkerNewStop(latlng);newStopInfoWindow();}});
}

///////////////////////// PARADAS /////////////////////////

/* Cargamos todas las paradas*/
function loadStops(administration){
  new Ajax.Request( '/stops/', { 
                    method: 'get',
                    onSuccess: function(request){ 
                                var markers = eval( "(" + request.responseText + ")" ); 
                                printStops(markers, administration);
                    }});
}



function printStops(markers, administration){
  for (var i = 0 ; i < markers.length ; i++) {
    var latlng = new GLatLng(parseFloat(markers[i].lat),parseFloat(markers[i].lng));
    
    //Eventos sobre los marcadores, teniendo en cuenta si estamos en la zona de administración
    if(administration == true){
      var marker = new GMarker(latlng, {icon: loadMiniPoint(), draggable: true, bouncy:false});
      markerAdministrationEvents(marker, markers[i]);        
    }
    else
    {
      var marker = new GMarker(latlng, {icon: loadMiniPoint()});
      markerEvents(marker, markers[i]);    
    }
    map.addOverlay(marker);
  }
}

//Eventos para las paradas de main/index
function markerEvents(marker, stop){
  GEvent.addListener(marker, "click", function(){mainIndexStopInfo(stop, marker)});
}

//Eventos para admin/stops/index
function markerAdministrationEvents(marker, stop){
  GEvent.addListener(marker, "click", function(){stopsIndexInfoWindow(stop, marker)});
  
  GEvent.addListener(marker, "dragend", function(){
    stopsIndexInfoWindow(stop, marker);
  });
   
  GEvent.addListener(marker, "dragstart", function(){
    marker.closeInfoWindow();
  });

}


///////////////////////// INFO WINDOWS /////////////////////////

//Eventos de cada parada del main/index
function mainIndexStopInfo(stop, marker){
  current_marker = marker;
  //Cargamos las lineas que afectan a la parada
  //loadIncidentsLines(stop);
  marker.openInfoWindow("Cargando ...");
  loadStopTimeInfo(stop);
}

//Bubble de la paradas en la zona de administración
function stopsIndexInfoWindow(stop, marker){
  current_marker = marker;
  var id = stop.id
  var name = stop.name;
  var node = stop.node;
  
  var html = "<b>" + stop.name + "</b><br/>";
  html += "Nodo: " + stop.node + "<br/>";
  html += "<a href='#' onclick='editStopInfoWindow("+ id + ",\""+name+"\",\"" +node+"\");return false;'>Editar</a> ó ";
  html += "<a onclick=\"if (confirm('¿Seguro?')) { new Ajax.Request('/admin/stops/" + stop.id + "', {asynchronous:true, evalScripts:true, method:'delete'}); }; return false;\" href=\"#\">Eliminar</a>"
  marker.openInfoWindowHtml(html);
}


/*Cargamos en la info window con los tiempos de los buses al llegar a las paradas*/
function loadStopTimeInfo(stop){
  new Ajax.Request( '/stops/' + stop.node,
         { method: 'get',
           onSuccess: function(request){
             removeOldActiveLines();
             var result = eval( "(" + request.responseText + ")" );
             tabs = loadTabs(result, stop);
             current_marker.openInfoWindowTabsHtml(tabs, {"selectedTab":0});
             
             //Cargamos las lineas que afectan a esta parada y sus autobuses
             loadIncidentLinesAndVehicles(result)
             if(periodical!=null) periodical.stop();
             //Cargamos un periodical si existe alguna línea.
             if(result[0].label != ''){
               periodical = new PeriodicalExecuter(function(){refreshVehicles();}, 20);
             }
             
           }
     });

}

function loadTabs(tabs, stop){
  var res = [];
  for (var i = 0 ; i < tabs.length - 1; i++) {
    res.push(new GInfoWindowTab(tabs[i].label, stopContent(tabs[i].label, tabs[i].content, stop, tabs.length)));    
  }
  return res;
}


function stopContent(label, content, stop, tabs_number){
  current_stop = stop;
  var html= "<div class='bubble'>"
  //Si tenemos mas de 3 tabs modificamos el atributo width del info window
  if(tabs_number > 3){
    html= "<div class='bubble' style='width:"+tabs_number*75+"px'>"
  }  
  //Mostramos si existe algún bus
  if(label != ''){
    //Cabecera
    html += "<div class='bubble_header'><b> Línea "+ label + "</b><hr class='mb0'/></div>"  
    //Opciones
    html += "<div class=\"bubble_stop_options\">";
    html += "<img src=\"/images/alarm.png\"/>";
    html += "<span><a href='#' onclick=\"new Ajax.Request('/alerts/new', {parameters: {'line_id': '" + label + "', 'stop_id': " + stop.node + " }, asynchronous:true, evalScripts:true}); return false;\">Crear Alarma</a></span>";  
    html += "<img src=\"/images/reload.png\" alt=\"Recargar\"/>";
    html += "<span><a href='#' onclick=\"reloadStopTimeInfo();return false;\">Recargar</a></span></div>";
  }
  //Contenido
  html += "<div class='bubble_content'>" + content + "</div></div>";
  return html;
}

function reloadStopTimeInfo(){
  current_marker.openInfoWindow("Recargando ...");
  loadStopTimeInfo(current_stop);
}
///////////////////////// LINEAS /////////////////////////

//Cargamos todas las líneas
function loadAllLines(){
  new Ajax.Request( '/lines/', { 
                    method: 'get',
                    onSuccess: function(request){ 
                                var lines = eval( "(" + request.responseText + ")" );                                 
                                printMainIndexLines(lines);
                    }});
}

function loadIncidentLinesAndVehicles(result){
  removeOldLines();
  for (var i = 0 ; i < result.length -1 ; i++) {
    loadLine(result[i].label);
    loadVehicles(result[i].label);
    active_lines.push(result[i].label);
  }
}

//Nos traemos la información de una parada
function loadLine(label){
   new Ajax.Request( '/lines/' + label, { 
                    method: 'get',
                    onSuccess: function(request){ 
                                var line = eval( "(" + request.responseText + ")" );                                 
                                showPolyFromEncoded(line.course, line.color);
                    }});
}

function printMainIndexLines(lines){
  removeOldLines();
  for(var i=0; i<lines.length; i++){
    showPolyFromEncoded(lines[i].course, lines[i].color);
  }
}

function removeOldLines(){
  //Borramos polylines anteriores para q no se solapen
  for(var i=0; i<polylines.length; i++){
    map.removeOverlay(polylines[i]);
  }
}

///////////////////////// NUEVA/EDITAR PARADA /////////////////////////

/* Muestra en pantalla el nuevo punto */
function addMarkerNewStop(latlng){
  if (current_marker){
    map.removeOverlay(current_marker);
  }
  current_marker = new GMarker(latlng, {draggable: true, bouncy:false});
  map.addOverlay(current_marker);
  
  GEvent.addListener(current_marker, "dragend", function(){
    newStopInfoWindow();
   });
   
  GEvent.addListener(current_marker, "dragstart", function(){
    current_marker.closeInfoWindow();
   });
   
  
  GEvent.addListener(current_marker, 'click', function(){if(!overlay){newStopInfoWindow();}});
}


function editStopInfoWindow(id, name, node){
  var html = "<div id='info'></div><form id='form' method='post'>";
  html += "<div class='span-9'><div class='span-3'><label for=\"stop_node\">Nodo:</label></div><div class='span-2 last'><input id=\"stop_node\" name=\"stop[node]\" size=\"2\" type=\"text\" value=\""+ node +"\"/></div><div id='loader' style='display:none'><img src='/images/ajax-loader.gif' /></div><div id='not_found' style='display:none'>No encontrado</div></div>";
  html += "<div class='clear'></div><div class='span-13'><div class='span-3'><label for=\"stop_name\">Nombre:</label></div><input id=\"stop_name\" name=\"stop[name]\" size='25' type='text' value=\"" + name + " \"/></div>";
  //lat and lng
  html += "<input id='stop_lat' type='hidden' name='stop[lat]' value='" + current_marker.getLatLng().lat() + "'/>"
  html += "<input id='stop_lng' type='hidden' name='stop[lng]' value='" + current_marker.getLatLng().lng() + "'/>"
  //Comprobar si estamos actalizando o creando una parada
  if(id == null){
    html += "<div class='clear'></div><input type='button' value='Save' name='commit' onclick=\"new Ajax.Request('/admin/stops', {asynchronous:true, evalScripts:true, parameters:Form.serialize(this.form)}); return false;\"/></form>";
  }else{
    html += "<div class='clear'></div><input type='button' value='Save' name='commit' onclick=\"new Ajax.Request('/admin/stops/" + id + "', {method: 'put', asynchronous:true, evalScripts:true, parameters:Form.serialize(this.form)}); return false;\"/></form>";
  }
  //Observer para obtener el nombre del nodo
  html += "<script type=\"text/javascript\">new Form.Element.EventObserver('stop_node', function(element, value) {new Ajax.Request('/admin/stops/'+value, {method: 'get', asynchronous:true, evalScripts:true, onSuccess:function(request){$('stop_name').value = request.responseText; $('loader').hide()}, onLoading:function(){$('not_found').hide();$('loader').show();}, onFailure:function(){$('loader').hide();$('not_found').show(); $('stop_name').value=''}})})</script>"
  
  current_marker.openInfoWindowHtml(html);
}

function newStopInfoWindow(){
  editStopInfoWindow(null, '','');
}


//Comportamiento al crear/actualizar una parada
function notifyStopUpdated(stop){
  current_marker.closeInfoWindow();
  current_marker.hide();
  var latlng = new GLatLng(stop.lat, stop.lng);
  var marker = new GMarker(latlng, {icon: loadMiniPoint(), draggable: true, bouncy:false});
  markerAdministrationEvents(marker, stop);
  map.addOverlay(marker);
}


/////////////////////////Autobuses/////////////////////////

//Carga los autobuses
function loadVehicles(line){
  new Ajax.Request( '/vehicles',
         { method: 'get',
           parameters: {'line': line},
           //onLoading: function(){$("cargando").show();},
           onSuccess: function(request){
             var markers = eval( "(" + request.responseText + ")" );
             //Borramos los anteriores autobuses de la linea en cuestión
             removeOldVehicles(line);
             /*Mostramos los autobuses de la línea*/  
             plotVehicles(markers, line);
             //$("cargando").hide();
           }
     });
}

//Muestra los autobuses en el mapa
function plotVehicles(markers, line){
  latlong = new Array(2);
  for (var i = 0 ; i < markers.length ; i++) {
    UTMXYToLatLon (markers[i].xcord - 135, markers[i].ycord - 200, 30, false, latlong);
    var latlng = new GLatLng(RadToDeg(latlong[0]), RadToDeg(latlong[1]));
    var marker = new GMarker(latlng, busIcon(line));
    buses.push({'marker': marker, 'label': line});
    map.addOverlay(marker);
  }
}

//Borraremos o todos los autobuses, los de la linea a refrescar o lineas ya no activas
function removeOldVehicles(line){
  for (var i = buses.length - 1; i >= 0  ; i--) {
    if(line == undefined || buses[i].label == line){
      map.removeOverlay(buses[i].marker);
      buses.splice(i, 1);
    }
  }
  
}

//La actualización periódica llamará a esta función para actualizar la posición de los auqtobuses activos.
function refreshVehicles(){
   for (var i = 0 ; i < active_lines.length; i++) {
     loadVehicles(active_lines[i]);
   }
}

//Borramos los autobuses de las lineas activas anteriores
function removeOldActiveLines(){
  removeOldVehicles();
  active_lines = [];
}

/////////////////////////Iconos/////////////////////////

/* MiniPoint */
function loadMiniPoint(){
  var icon = new GIcon();
  icon.image = "/images/point.png";
  icon.iconSize = new GSize(12, 12);
  icon.iconAnchor = new GPoint(6,6);
  icon.infoWindowAnchor = new GPoint(6,6);
  return icon;
}

function busIcon(label){
  var icon = new GIcon();
  icon.image = "/images/lines/" + label+ ".png";
  icon.iconSize = new GSize(15, 15);
  icon.iconAnchor = new GPoint(7, 7);
  return icon;
}