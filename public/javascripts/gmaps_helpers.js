function geocodePosition(pos) {
  geocoder.geocode({
    latLng: pos
  }, function(responses) {
    if (responses && responses.length > 0) {
      updateMarkerAddress(responses[0].formatted_address);
    } else {
      updateMarkerAddress('Cannot determine address at this location.');
    }
  });
}

function updateMarkerStatus(str) {
  document.getElementById('markerStatus').innerHTML = str;
}

function updateMarkerPosition(latLng) {
  if(document.getElementById('posting_location_attributes_lat') && document.getElementById('posting_location_attributes_lng')){
    document.getElementById('posting_location_attributes_lat').value = latLng.lat();
    document.getElementById('posting_location_attributes_lng').value = latLng.lng();
  }
  document.getElementById('info').innerHTML = [
    latLng.lat(),
    latLng.lng()
  ].join(', ');
}

function updateMarkerAddress(str) {
  document.getElementById('address').innerHTML = str;
  if(document.getElementById('posting_location_attributes_address_line')){
    document.getElementById('posting_location_attributes_address_line').value = str;
  }
}

function listenMarkerPosition(lmarker) {
  // Update current position info.
  updateMarkerPosition(lmarker.get_position());
  geocodePosition(lmarker.get_position());

  // Add dragging event listeners.
  google.maps.event.addListener(lmarker, 'dragstart', function() {
    updateMarkerAddress('Dragging...');
  });

  google.maps.event.addListener(lmarker, 'drag', function() {
    updateMarkerStatus('Dragging...');
    updateMarkerPosition(lmarker.get_position());
  });

  google.maps.event.addListener(lmarker, 'dragend', function() {
    updateMarkerStatus('Drag ended');
    geocodePosition(lmarker.get_position());
  });
}

function codeAddress(str) {
  var address = str;
  if (geocoder) {
    geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        marker.setMap(null);
        marker = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location,
            title: 'Test',
            draggable: true
        });
        listenMarkerPosition(marker);
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    });
  }
}


function openInfoWindow(infoWindow, marker) {
  return function() {
    // Close the last selected marker before opening this one.
    if (Demo.visibleInfoWindow) {
      Demo.visibleInfoWindow.close();
    }

    infoWindow.open(Demo.map, marker);
    Demo.visibleInfoWindow = infoWindow;
  };
}

