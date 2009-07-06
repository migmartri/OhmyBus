function encodePolyline() {
  var i = 0;

  var plat = 0;
  var plng = 0;

  var encoded_points = "";
  var encoded_levels = "";

  for(i = 0; i < poly_markers.length; ++i) {
    var point = poly_latlngs[i];
    var lat = point.lat();
    var lng = point.lng();
    //Nivel de ejemplo
    var level = 2;

    var late5 = Math.floor(lat * 1e5);
    var lnge5 = Math.floor(lng * 1e5);

    dlat = late5 - plat;
    dlng = lnge5 - plng;

    plat = late5;
    plng = lnge5;

    encoded_points += encodeSignedNumber(dlat) + encodeSignedNumber(dlng);
    encoded_levels += encodeNumber(level);
  }

  if (poly_latlngs.length > 1) {
    $('line_course').value = encoded_points;
  }
}

function encodeSignedNumber(num) {
  var sgn_num = num << 1;
  if (num < 0) {
    sgn_num = ~(sgn_num);
  }
  return(encodeNumber(sgn_num));
}

function encodeNumber(num) {
  var encodeString = "";

  while (num >= 0x20) {
    encodeString += (String.fromCharCode((0x20 | (num & 0x1f)) + 63));
    num >>= 5;
  }

  encodeString += (String.fromCharCode(num + 63));
  return encodeString;
}

function decodeLine (encoded) {
  var len = encoded.length;
  var index = 0;
  var array = [];
  var lat = 0;
  var lng = 0;

  while (index < len) {
    var b;
    var shift = 0;
    var result = 0;
    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    var dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    var dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    array.push([lat * 1e-5, lng * 1e-5]);
  }

  return array;
}
