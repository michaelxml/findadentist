        var markers = [];
        var locationIndex = 0;
        var providersHtml = ' ';
        var map;
        var mapTypeIds = [];
        var marker;
        var myLatlng = new google.maps.LatLng(44.97781, -93.26501);
        var element = document.getElementById("map_canvas");
        var searchResults = null;

  
        function addMarker() {

            setAllMap(null);
            closeDirections();

            element = document.getElementById("map_canvas");

            map = new google.maps.Map(element, {
                center: new google.maps.LatLng(44.9778, -93.2650),
                zoom: 11
            });

            markers = [];

            providersHtml = '';
            locationIndex = 0;
            pageIndex = 0;

            jQuery.getJSON('http://localhost:8080/findadentist/Dentist/providerSearchResults', function (results) {
                console.log(results);
                searchResults = results;

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
                });
                var mcOptions = {gridSize: 50, maxZoom: 18};
                var mc = new MarkerClusterer(map, markers, mcOptions);

                document.getElementById("providers").innerHTML = providersHtml;
                console.log(providersHtml);
            });

        };


        function setAllMap(map) {
            for (var i = 0; i < markers.length; i++) {
                markers[i].setMap(map);
            }
        }

        function panToLocation(locationNumber) {
            var i = locationNumber-1;
            map.setZoom(18);
            map.panTo(markers[i].position);
        }

        var directionsDisplay = new google.maps.DirectionsRenderer();
        var directionsService = new google.maps.DirectionsService();
        var browserSupportFlag = false;
        var currentLocation = null;
        var directionsResult = null;
        var directionsHtml = '';
        var locationIndex = 0;

        function plotRouteFromCurrentLocation(locationNumber) {
            directionsDisplay.setMap(null);
            locationIndex = locationNumber - 1;
            closeDirections();
            document.getElementById("directionsBusinessName").innerHTML = '<p><img src="https://disneymovieclub.go.com/static/Acquisition/Browse/LoadingWheel.gif" height="18px"/>&nbsp;Please wait ...</p>';

            // Try W3C Geolocation (Preferred)
            if(navigator.geolocation) {
                browserSupportFlag = true;
                navigator.geolocation.getCurrentPosition(function(position) {
                    currentLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
                    map.setCenter(currentLocation);
                    var start = currentLocation;

                    var end = markers[locationIndex].position;
                    var request = {
                        origin:start,
                        destination:end,
                        travelMode: google.maps.TravelMode.DRIVING
                    };

                    directionsDisplay.setMap(map);

                    directionsDisplay.setPanel(document.getElementById("directions"));
                    directionsService.route(request, function(result, status) {
                        if (status == google.maps.DirectionsStatus.OK) {
                            directionsDisplay.setDirections(result);
                            document.getElementById("directionsBusinessName").innerHTML = '<p><strong>Directions To: <br/><u>'+markers[locationIndex].get("businessName")+'</u></strong> - Location ('+locationNumber+') on map<br/>'+markers[locationIndex].get("locationAddress")+ '</p>';
                            console.log(document.getElementById("directionsBusinessName").innerHTML );
                        }
                    });
                }, function() {
                    console.log('Current Location Not Supported');
                });
            }
            // Browser doesn't support Geolocation
            else {
                browserSupportFlag = false;
                console.log('Current Location Not Supported');
            }
        }