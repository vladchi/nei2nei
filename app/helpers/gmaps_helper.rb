module GmapsHelper
    def google_map_tag(location, options={})
    options = {:zoom => 12, :center => 'latLng', :mapTypeId => 'google.maps.MapTypeId.ROADMAP'}.merge(options)
    options_array = []
    options.each_pair do |k,v| options_array << k.to_s+": "+v.to_s end
    options_string = options_array.join(",\n")
    string = ""
    string = <<-END_TEXT
      var geocoder = new google.maps.Geocoder();
      var map;
      var marker;

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

      function initialize() {
        var latLng = new google.maps.LatLng(#{location.lat}, #{location.lng});
        var myOpts = {
          #{options_string}
        };
        map = new google.maps.Map(document.getElementById("map_canvas"), myOpts);
        marker = new google.maps.Marker({
          position: latLng,
          title: 'Test',
          map: map,
          draggable: true
        });

        listenMarkerPosition(marker);
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
            }
          });
        }
      }

      google.maps.event.addDomListener(window, 'load', initialize);
    END_TEXT
    @google_map = string
    javascript_tag @google_map
  end

  def simple_google_map_tag(posting, options={})
    options = {:zoom => 12, :center => 'latLng', :mapTypeId => 'google.maps.MapTypeId.ROADMAP'}.merge(options)
    options_array = []
    options.each_pair do |k,v| options_array << k.to_s+": "+v.to_s end
    options_string = options_array.join(",\n")
    string = ""
    string = <<-END_TEXT
      var map;
      var marker;

      function initialize() {
        var latLng = new google.maps.LatLng(#{posting.location.lat}, #{posting.location.lng});
        var myOpts = {
          #{options_string}
        };
        map = new google.maps.Map(document.getElementById("map_canvas"), myOpts);
        marker = new google.maps.Marker({
          position: latLng,
          title: '#{h(posting.title)}',
          map: map,
          draggable: false
        });
      }
      google.maps.event.addDomListener(window, 'load', initialize);
    END_TEXT
    @google_map = string
    javascript_tag @google_map
  end

  def multimarker_map(start_point, locations, options={})
#    return "" if locations.blank?
    start_point ||= "San Francisco, CA"
    options = {:zoom => 11, :mapTypeId => 'google.maps.MapTypeId.ROADMAP'}.merge(options)
    options_array = []
    options.each_pair do |k,v| options_array << k.to_s+": "+v.to_s end
    options_string = options_array.join(",\n")
    markers = locations.map do |litem|
      m = <<-ENDM

        var latLng#{litem.id} = new google.maps.LatLng(
            #{litem.location.lat},
            #{litem.location.lng});
        var marker#{litem.id} = new google.maps.Marker({
          map: Demo.map,
          title: '#{litem.title}',
          position: latLng#{litem.id}
        });
        Demo.markers.push(marker#{litem.id});

        // Create marker info window.
        var infoWindow#{litem.id} = new google.maps.InfoWindow({
          content: [
            '<h3 style="">',
            '#{h(litem.title)}',
            '</h3>',
            '<div style="font-size: 0.8em;">',
            '#{h(litem.description)}',
            '</div>'
          ].join(''),
          size: new google.maps.Size(200, 80)
        });

        // Add marker click event listener.
        google.maps.event.addListener(
          marker#{litem.id}, 'click', Demo.openInfoWindow(infoWindow#{litem.id}, marker#{litem.id}));

        // Generate list elements for each marker.
        var aSel#{litem.id} = document.getElementById('show_posting_#{litem.id}');
        aSel#{litem.id}.href = 'javascript:void(0);';
        aSel#{litem.id}.onclick = Demo.generateTriggerCallback(marker#{litem.id}, 'click');
      ENDM
    end
    string = <<-END_TEXT
      var googleGeocoder = new google.maps.Geocoder();

      function geocodePosition(pos) {
        googleGeocoder.geocode({
          latLng: pos
        }, function(responses) {
          if (responses && responses.length > 0) {
            updateMarkerAddress(responses[0].formatted_address);
          } else {
            updateMarkerAddress('');
          }
        });
      }

      function updateMarkerAddress(str) {
        document.getElementById('origin').value = str;
      }

      function listenMarkerPosition(lmarker) {
        // Update current position info.
        geocodePosition(lmarker.get_position());

        // Add dragging event listeners.
        google.maps.event.addListener(lmarker, 'dragstart', function() {
          updateMarkerAddress('Dragging...');
        });

        google.maps.event.addListener(lmarker, 'dragend', function() {
          geocodePosition(lmarker.get_position());
        });
      }

      var Demo = {
        map: null,
        mapContainer: document.getElementById('mapContainer'),
        markers: [],
        visibleInfoWindow: null,
        currentStartMarker: null,
        startMarkerLocation: new google.maps.LatLng(-34.397, 150.644),

        openInfoWindow: function(infoWindow, marker) {
          return function() {
            // Close the last selected marker before opening this one.
            if (Demo.visibleInfoWindow) {
              Demo.visibleInfoWindow.close();
            }

            infoWindow.open(Demo.map, marker);
            Demo.visibleInfoWindow = infoWindow;
          };
        },

        generateTriggerCallback: function(object, eventType) {
          return function() {
            google.maps.event.trigger(object, eventType);
          };
        },

        clearMarkers: function() {
          for (var n = 0, marker; marker = Demo.markers[n]; n++) {
            marker.setVisible(false);
          }
        },

        geocodeStartAddress: function(str){
          var googleGeocoder = new google.maps.Geocoder();
          googleGeocoder.geocode( { 'address': str}, function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
              Demo.startMarkerLocation = results[0].geometry.location;
              Demo.map = new google.maps.Map(Demo.mapContainer, {
                center: Demo.startMarkerLocation,
                #{options_string}
              });
              //Demo.map.setCenter(Demo.startMarkerLocation);
              if (Demo.currentStartMarker) {
                Demo.currentStartMarker.setMap(null);
              }
              var startMarker = new google.maps.Marker({
                map: Demo.map,
                position: Demo.startMarkerLocation,
                title: str,
                draggable: true,
                icon: 'http://labs.google.com/ridefinder/images/mm_20_blue.png'
              });
              Demo.currentStartMarker = startMarker;
              listenMarkerPosition(Demo.currentStartMarker );
              Demo.placeMarkers();
            }
          });
        },

        placeMarkers: function() {
          #{markers.join("\n")}
        },

        init: function() {
          Demo.geocodeStartAddress('#{start_point}');
        }
      };

      google.maps.event.addDomListener(window, 'load', Demo.init, Demo);
    END_TEXT
    @google_map = string
    javascript_tag @google_map
  end
end