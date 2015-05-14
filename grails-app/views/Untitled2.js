      function nextPage() {
            closeDirections();

            markers = [];

            providersHtml = '';
            locationIndex = 0;
            pageIndex = pageIndex + 1;

                var centerLatlng = new google.maps.LatLng(searchResults.originatingLatitude, searchResults.originatingLongitude);
                map.setCenter(centerLatlng);
                jQuery.each((searchResults.providers).slice(pageIndex,1), function (providerIndex, provider) {
                    providersHtml = providersHtml + '<div class="prvdrBox noMedHomeDetails" id="pvdr'+providerIndex+'">';
                    providersHtml = providersHtml + '<p class="name"><span class="subhead">';
                    providersHtml = providersHtml + '<a id="pvdr'+providerIndex+'" href="#"  class="ex2trigger">';
                    providersHtml = providersHtml + provider.businessName + '</a> </span><span class="note2">';
                    providersHtml = providersHtml + provider.specialties[0]+'</span></p>';

                    jQuery.each(provider.locations, function (i, location) {
                        locationIndex = locationIndex + 1;
                        var myLatlng = new google.maps.LatLng(location.latitude, location.longitude);
                        var marker = new google.maps.Marker({
                            position: myLatlng,
                            icon: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld='
                            +locationIndex
                            +'|51447A|FFFFFF',
                            id: locationIndex,
                            //map: map,
                            title: provider.businessName
                        });

                        marker.set('businessName',provider.businessName);
                        marker.set('providerIndex',providerIndex);
                        marker.set('locationIndex',locationIndex);
                        marker.set('directions','');
                        marker.set('locationAddress','<span class="locationAddress" name="locationAddress" id="locationAddress">'+location.addressOne+'<br/>'+location.city+',&nbsp;'+location.stateCode+'&nbsp;'+location.zip+'<br/>'+location.telephoneNumber+'</span>');
                        markers.push(marker);
                        console.log('location index: ' + locationIndex);

                        var infoWindow = new google.maps.InfoWindow();

                        google.maps.event.addListener(marker, 'click', function () {
                            var markerContent = '<div class="location altRow noMedHome"><div class="pinpoint"><a href="#" class="marker" onClick="panToLocation('+locationIndex+');closeDirections();">'+locationIndex+'</a></div><div class="prvdrAddr"><p><strong>Distance: '+location.distance+'<br/></strong><br/>'+provider.businessName+'<br/>'+location.addressOne+'<br/>'+location.city+',&nbsp;'+location.stateCode+'&nbsp;'+location.zip+'<br/>'+location.telephoneNumber+'</p></div></div>' + marker.get('directions');
                            infoWindow.setContent(markerContent);
                            infoWindow.open(map, this);
                        });


                        providersHtml = providersHtml + '<div class="location altRow noMedHome"><div class="pinpoint"><a href="#" class="marker" onClick="panToLocation('+locationIndex+');closeDirections();">Location ('+locationIndex+') on map</a></div><div class="prvdrAddr"><p><strong>Distance: '+location.distance+'<br/></strong><br/>'+location.addressOne+'<br/>'+location.city+',&nbsp;'+location.stateCode+'&nbsp;'+location.zip+'<br/>'+location.telephoneNumber+'</p><p><strong><a href="#" onClick="plotRouteFromCurrentLocation('+locationIndex+');">Plot Route</a></strong></p></div></div>';

                    });
                    providersHtml = providersHtml + '</div>';

                var mcOptions = {gridSize: 50, maxZoom: 18};
                var mc = new MarkerClusterer(map, markers, mcOptions);

                document.getElementById("providers").innerHTML = providersHtml;
                console.log(providersHtml);
          })
        }
