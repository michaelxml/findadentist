<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

	<link rel="shortcut icon" href="deltadental_fav.png" />

	<title>Dental Search w/ Results</title>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>
	<script type="text/javascript" src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/src/markerclusterer.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
	<script type="text/javascript" src="./jquery.ui.map.js"></script>

	<script type="text/javascript">


		function closeDirections() {
			document.getElementById("directions").innerHTML = '';
			document.getElementById("directionsBusinessName").innerHTML = '';
			directionsDisplay.setMap(null);
		}

		</script>

	<script type="text/javascript">
		var markers = [];
		var locationIndex = 0;
		var providersHtml = ' ';
		var map;
		var mapTypeIds = [];
		var marker;
		var myLatlng = new google.maps.LatLng(44.97781, -93.26501);
		var element = document.getElementById("map_canvas");

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

			jQuery.getJSON('./Dentist/providerSearchResults', function (results) {
				console.log(results);

				var centerLatlng = new google.maps.LatLng(results.originatingLatitude, results.originatingLongitude);
				map.setCenter(centerLatlng);
				jQuery.each(results.providers, function (providerIndex, provider) {

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

	</script>

	<script type="text/javascript">
		/**
		 * Randomize array element order in-place.
		 * Using Fisher-Yates shuffle algorithm.
		 */
		function shuffleArray(array) {
			for (var i = array.length - 1; i > 0; i--) {
				var j = Math.floor(Math.random() * (i + 1));
				var temp = array[i];
				array[i] = array[j];
				array[j] = temp;
			}
			return array;
		}
	</script>

	<script type="text/javascript"></script><!-- allow page-specific js to be inserted by page instances -->

	<link rel="stylesheet" type="text/css" href="stylesheet.css" />

</head>

<body>
 <div id="pagewrap">


	<div id="contentMain">

		<!-- search criteria on left -->
		<div id="navMain">

			<script type="text/javascript">
				/* <![CDATA[ */
				var cont = '/findadentist';
				var nwks = 'DPREMIERAK|DOHP|DPPOAK|DCHILD|DPREMIER|DPPO';

				function advanced(){
					document.getElementById('advancedSearchVisible').value="block";
					document.getElementById('address').style.display="block";
					document.getElementById('county').style.display="block";
					document.getElementById('langp').style.display="block";
					document.getElementById('genderp').style.display="block";
					document.getElementById('acceptp').style.display="block";
					document.getElementById('advanced').style.display="none";
				}

				/* ]]> */
			</script>
		 <!-- <table border="0">
			  <tr valign="top">
				  <td>-->
		  <div class="col span_1_of_2">
			<form id="searchForm" name="searchFormMRO" method="get" action="/findadentist/" enctype="application/x-www-form-urlencoded">
				<input type="hidden" name="searchForm" value="searchForm" />
				<span class="searchType hide">dental</span><div id="searchForm:filter">

				<div id="a1" style="display:block;"><h2>Enter/Edit Your Search</h2>

					<div class="col1">
						<label>Provider or facility name</label><input id="prover" name="prover" type="text" value="" class="modaText search" tabindex="1" />
					</div>

					<!-- Provider Type - Begin-->
					<div class="col2">
					</div>
					<!-- Provider Type - End-->

					<div class="colSpan">
						<label>Provider specialty</label><select id="speciality" name="speciality" size="1" class="custom_theme" tabindex="3">	<option value="" selected="selected">Any specialty</option>	<option value="DCLN">Dental Group</option>	<option value="LAP ">Dental Hygienist</option>	<option value="LAP ">Dental Hygienist w/special</option>	<option value="GP  ,GP  ">Dentist - General Practice</option>	<option value="PD  ">Dentist - Pediatric</option>	<option value="DU  ,DU  ">Denturist</option>	<option value="DUL ,DUL ">Denturist-OP Endorsement</option>	<option value="EN  ,EN  ">Endodontist</option>	<option value="OP  ,OP  ">Oral Pathologist</option>	<option value="OS  ,OS  ">Oral Surgeon</option>	<option value="OR  ,OR  ">Orthodontist</option>	<option value="PD  ">Pediatric Dentist</option>	<option value="PR  ,PR  ">Periodontist</option>	<option value="PT  ,PT  ,PT  ,PT  ,PT  ,PT  ">Prosthodontist</option></select>

						<a id="modalTriggerSpecialtiesDefined" class="mdl-inq" href="#">Click for help</a>
						<!--
	                        <a href="javascript:custompopUp('https://www.modahealth.com/ProviderSearch/faces/webpages/helpProvSpec.xhtml','500','600','1','1')" class="helpIcon">
	                            Click for help</a>
	                        -->
					</div>

					<!--Network Drop Down Begin-->
					<div class="colSpan colNetwork"><span id="searchForm:panelGrid03" class="allNetworkSpan">
						<label>Network/networks
						</label>

						<div class="listofcontents_right">
							<ul class="listofcontents_right">

								<li class="listofcontents_right">
									<dl class="dropdown" tabindex="4">
										<dt class="selectedNetworks">
											<span class="selectedNetworksTxt">Any network
											</span>
										</dt>
										<dd class="theQabout">
											<a id="modalTriggerNetworks" class="mdl-inq" href="#">Click for help</a>
										</dd>
										<dd class="allNetworksList">

											<ul class="listCntrls">
												<li class="listCntrls brdRght">
													<a href="#" id="slctAllNWlist">All</a>
												</li>
												<li class="listCntrls brdRght">
													<a href="#" id="dslctAllNWlist">None</a>
												</li>
												<li class="listCntrls">
													<a href="#" id="closeNwlist">Close</a>
												</li>
											</ul><span id="searchForm:panelGrid05" class="allNetworkListSpan">
											<dl class="dentalOR">
												<dt><span>Oregon</span></dt>
												<dd class="dentalORdd">
												</dd>
											</dl>
											<dl class="dentalAK">
												<dt><span>Alaska</span></dt>
												<dd class="dentalAKdd">
												</dd>
											</dl></span>
										</dd>
									</dl>
								</li>
							</ul>
						</div><input id="searchForm:selectedNetworksToSend" name="searchForm:selectedNetworksToSend" type="text" value="Any network" style="display:none;" class="selJsoNetworksTxt" /><input id="searchForm:selectedNetworks" name="searchForm:selectedNetworks" type="text" value="[]" style="display:none;" class="selJsoNetworks" /></span>
					</div>
					<!--Network Drop Down End-->
					<div class="colSpan">
						<label style="margin-bottom:4px;">Location</label><input id="address" name="address" type="text" value="" style="display:block;" class="modaText search" tabindex="5"  placeholder="Address"/>
					</div>

					<div class="col1 no-top-pad"><input id="city" name="city" type="text" value="" style="float:left; clear:none;" class="modaText search" tabindex="6" placeholder="City"/>
					</div>

					<div class="col2 no-top-pad"><select id="state" name="state" size="1" style="clear:none;" class="custom_theme" tabindex="7"  placeholder="State">
						<option value="">State</option>	<option value="AL">AL</option>	<option value="AK">AK</option>	<option value="AZ">AZ</option>	<option value="AR">AR</option>	<option value="CA">CA</option>	<option value="CO">CO</option>	<option value="CT">CT</option>	<option value="DE">DE</option>	<option value="FL">FL</option>	<option value="GA">GA</option>	<option value="HI">HI</option>	<option value="ID">ID</option>	<option value="IL">IL</option>	<option value="IN">IN</option>	<option value="IA">IA</option>	<option value="KS">KS</option>	<option value="KY">KY</option>	<option value="LA">LA</option>	<option value="ME">ME</option>	<option value="MD">MD</option>	<option value="MA">MA</option>	<option value="MI">MI</option>	<option value="MN">MN</option>	<option value="MS">MS</option>	<option value="MO">MO</option>	<option value="MT">MT</option>	<option value="NE">NE</option>	<option value="NV">NV</option>	<option value="NH">NH</option>	<option value="NJ">NJ</option>	<option value="NM">NM</option>	<option value="NY">NY</option>	<option value="NC">NC</option>	<option value="ND">ND</option>	<option value="OH">OH</option>	<option value="OK">OK</option>	<option value="OR">OR</option>	<option value="PA">PA</option>	<option value="RI">RI</option>	<option value="SC">SC</option>	<option value="SD">SD</option>	<option value="TN">TN</option>	<option value="TX">TX</option>	<option value="UT">UT</option>	<option value="VT">VT</option>	<option value="VA">VA</option>	<option value="WA">WA</option>	<option value="WV">WV</option>	<option value="WI">WI</option>	<option value="WY">WY</option></select>
						<br/><br/><input id="zip" name="zip" type="text" value="" size="6" style="float:left; clear:none;" class="modaText zip" tabindex="8"  placeholder="Zip"/>
					</div><input id="county" name="county" type="text" value="" size="25" class="advanced modaText search noLabel" tabindex="10" onfocus="this.value ='';" />


					<div class="colSpan noLabel"><select id="distance" name="distance" size="1" class="custom_theme" tabindex="9">	<option value="" selected="selected">Distance..</option>	<option value="5">5 miles</option>	<option value="10">10 miles</option>	<option value="25">25 miles</option>	<option value="50">50 miles</option>	<option value="100">100 miles</option></select>
					</div>

					<div class="colSpan">
						<label id="langp" for="language" class="advanced">Languages spoken</label><select id="language" name="language" size="1" class="custom_theme advanced" tabindex="11">	<option value="" selected="selected">No preferences</option>	<option value="ENGL">English</option>	<option value="JAPA">Japanese</option>	<option value="SPAN">Spanish</option>	<option value="FARS">Farsi</option>	<option value="KORE">Korean</option>	<option value="FREN">French</option>	<option value="CHIN">Chinese</option>	<option value="GERM">German</option>	<option value="MAND">Chinese (Mandarin)</option>	<option value="PORT">Portuguese</option>	<option value="TAGA">Tagalog</option>	<option value="CPFR">Creoles and Pidgins French Based</option>	<option value="POLI">Polish</option>	<option value="HIND">Hindi</option>	<option value="RUSS">Russian</option>	<option value="CANT">Chinese (Cantonese)</option>	<option value="ITAL">Italian</option>	<option value="ARAB">Arabic</option>	<option value="HUNG">Hungarian</option>	<option value="VIET">Vietnamese</option>	<option value="ASL ">American Sign Language</option>	<option value="MALA">Malay</option>	<option value="HEBR">Hebrew</option>	<option value="NORW">Norwegian</option>	<option value="TAMI">Tamil</option>	<option value="ROMA">Romanian</option>	<option value="DANI">Danish</option>	<option value="SWED">Swedish</option>	<option value="FILI">Filipino</option>	<option value="GREK">Greek</option>	<option value="URDU">Urdu (Pakistani)</option>	<option value="INDI">Indian</option>	<option value="LAOO">Lao</option>	<option value="THAI">Thai</option>	<option value="DUTC">Dutch</option>	<option value="INDO">Indonesian</option>	<option value="TURK">Turkish</option>	<option value="FCAN">French Canadian</option>	<option value="PUNJ">Punjabi</option>	<option value="SWAH">Swahili</option>	<option value="CZEC">Czechoslovakian</option>	<option value="PERS">Persian</option>	<option value="SIGN">Sign Language</option>	<option value="KANN">Kannada</option>	<option value="FINN">Finnish</option>	<option value="TAIW">Taiwanese</option>	<option value="NEPA">Nepali</option>	<option value="BURM">Burmese</option>	<option value="CRPI">Creoles and Pidgins (other)</option>	<option value="KMHE">Cambodian/Khmer</option>	<option value="GUJA">Gujarati</option>	<option value="CAMI">Cental American Indian</option>	<option value="BENG">Bengali</option>	<option value="CROA">Croatian</option>	<option value="AFRI">Afrikaan</option>	<option value="TUMU">Tumulung Sisaala</option>	<option value="YIDD">Yiddish</option>	<option value="TONY">Tonga</option>	<option value="TIBE">Tibetan</option>	<option value="BOSN">Bosnian</option>	<option value="SERB">Serbian</option>	<option value="SERO">SeroCroatian</option>	<option value="WELS">Welsh</option>	<option value="KHME">Cambodian/Khmer</option>	<option value="ALBA">Albanian</option></select>
					</div>

					<div class="colSpan">
						<label id="genderp" for="gender" class="advanced">Gender</label><select id="gender" name="gender" size="1" class="custom_theme advanced" tabindex="12">	<option value="" selected="selected">No preferences</option>	<option value="M">Male</option>	<option value="F">Female</option></select>
					</div>

					<div class="colSpan">
						<label id="acceptp"><input id="searchForm:acceptNewPat" type="checkbox" name="searchForm:acceptNewPat" />
							<span>Show only providers who are accepting new patients.</span>
						</label>
					</div><input id="selectedId" name="selectedId" type="text" value="" style="display:none;" /><input id="networks" name="networks" type="text" value="DPREMIERAK|DOHP|DPPOAK|DCHILD|DPREMIER|DPPO" style="display:none;" /><input id="searchType" name="searchType" type="text" value="dental" style="display:none;" /><input id="searchCateg" name="searchCateg" type="text" value="dental" style="display:none;" /><input id="advancedSearchVisible" name="advancedSearchVisible" type="text" value="display:block" style="display:none;" />


					<p>
						<a href="#" onclick="toggleAdvanced(); return false;" id="more_search_options">Show more search options
						</a>
					</p><input id="submit" name="submit" type="button" value="Search" onclick="addMarker();" class="modaBtn performSrchProv" tabindex="13" />


				</div></div><input type="hidden" name="javax.faces.ViewState" id="javax.faces.ViewState" value="j_id8:j_id16" />
			</form>
			</div>
		    <div class="col span_2_of_2">
			<!--</td>
				  <td>-->
		<div id="map_canvas" class="map_canvas" name="map_canvas">Map Canvas</div><br/><br/>
					  <div src='javascript:' class="directionsBusinessName" name="directionsBusinessName" id="directionsBusinessName" style="margin-left:32px;margin-top:15px">

					  </div>

					  <div src='javascript:' class="directions" name="directions" id="directions" style="margin-left:32px;margin-top:15px">

					  </div>

					  <div src='javascript:' class="providers" name="providers" id="providers" style="margin-left:32px;margin-top:15px">

					  </div>
			 <!-- </td>
			  </tr>


			  </table>-->
			  </div>

		</div>


	</div><!-- /contentMain -->

	</div>


</body>

</html>