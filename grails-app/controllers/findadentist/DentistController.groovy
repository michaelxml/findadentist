package findadentist

import grails.converters.JSON

class DentistController {

    def index() { }

    def providerSearchResults() {

        ProviderSearchResults results = new ProviderSearchResults(
                originatingLatitude:44.977,
                originatingLongitude: -93.265,
                alterRule:'NoFilter',
                status:'PROVIDERS_FOUND',
                geoCodeQuality:'RANGE_INTERPOLATED');

        results.providers.add(new Provider(
                                  businessName : 'Hanks Hardware and Tooth Repair',
                                  firstName : 'Alpha',
                                  lastName : 'Male',
                                  middleInitial : 'M',
                                  suffix : 'DDS',
                                  providerEmail : 'provider1@gmail.com',
                                  genderCode : 'M',
                                  providerServcDisableAdlt : true,
                                  providerServcDisableChld : false)
        )
        results.providers[0].locations.add(new Location(
                                  businessName : 'Hanks Hardware and Tooth Repair',
                                  addressOne  :  '123 Seseme Street',
                                  addressTwo  :  '',
                                  stateCode  :  'MN',
                                  city  :  'Minneapolis',
                                  zip  :  '55438',
                                  officeEmail  :  'location1@gmail.com',
                                  urlText  :  'http://www.hanks-location1.com',
                                  telephoneNumber  :  '(999)123-4567',
                                  publicTransAvailable  :  true,
                                  officeServcDisableAdlt  :  true,
                                  officeServcDisableChld  :  true,
                                  handicappedAccessible  :  true,
                                  officeEmergencyMessage  :  'Not Sure What This Is',
                                  facilityId  :  'Location1',
                                  distance  :  100,
                                  latitude  :  44.9778,
                                  longitude : -93.2650)
        )
        results.providers[0].locations.add(new Location(
                businessName : 'Hanks Hardware and Tooth Repair',
                addressOne  :  '456 Other Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55439',
                officeEmail  :  'location2@gmail.com',
                urlText  :  'http://www.hanks-location2.com',
                telephoneNumber  :  '(888)456-7890',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location2',
                distance  :  200,
                latitude  :  45.029327,
                longitude : -93.362576)
        )
        results.providers[0].locations.add(new Location(
                businessName : 'Hanks Hardware and Tooth Repair',
                addressOne  :  '789 Yet Another Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55439',
                officeEmail  :  'location2@gmail.com',
                urlText  :  'http://www.hanks-location2.com',
                telephoneNumber  :  '(888)456-7890',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location3',
                distance  :  200,
                latitude  :  44.9776,
                longitude : -93.2652)
        )
        results.providers[0].locations.add(new Location(
                businessName : 'Hanks Hardware and Tooth Repair',
                addressOne  :  '291 Even Another Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55439',
                officeEmail  :  'location2@gmail.com',
                urlText  :  'http://www.hanks-location2.com',
                telephoneNumber  :  '(888)456-7890',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location4',
                distance  :  200,
                latitude  :  44.9770,
                longitude : -93.2659)
        )
        results.providers[0].locations.add(new Location(
                businessName : 'Hanks Hardware and Tooth Repair',
                addressOne  :  '382 Still Another Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55439',
                officeEmail  :  'location2@gmail.com',
                urlText  :  'http://www.hanks-location2.com',
                telephoneNumber  :  '(888)456-7890',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location4',
                distance  :  200,
                latitude  :  44.9710,
                longitude : -93.2699)
        )
        results.providers[0].products.add(new Product())
        results.providers[0].education.add("Degree 1, Education Place 1")
        results.providers[0].specialties.add("Speciality 1")
        results.providers[0].prvdrLanguages.add('English')
        results.providers[0].prvdrLanguages.add('Spanish')
        results.providers[0].officeTimes.add('EVE')
        results.providers[0].officeTimes.add('WKD')

        results.providers.add(new Provider(
                businessName : 'Yet Another Provider',
                firstName : 'Me',
                lastName : 'Myself',
                middleInitial : 'I',
                suffix : 'DDS',
                providerEmail : 'provider2@gmail.com',
                genderCode : 'M',
                providerServcDisableAdlt : true,
                providerServcDisableChld : false)
        )
        results.providers[1].locations.add(new Location(
                businessName : 'Yet Another Provider Location 1',
                addressOne  :  '789 Whatever Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55438',
                officeEmail  :  'provider2location1@gmail.com',
                urlText  :  'http://www.another-location.com',
                telephoneNumber  :  '(999)888-7777',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location1',
                distance  :  100,
                latitude  :  45.019387,
                longitude : -93.392586)
        )

        results.providers[1].locations.add(new Location(
                businessName : 'Yet Another Provider Location 2',
                addressOne  :  '222 One Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55438',
                officeEmail  :  'provider3location1@gmail.com',
                urlText  :  'http://www.another-location.com',
                telephoneNumber  :  '(888)999-6666',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location1',
                distance  :  100,
                latitude  :  44.995144,
                longitude :  -93.395276)
        )

        results.providers[1].locations.add(new Location(
                businessName : 'Yet Another Provider Location 3',
                addressOne  :  '111 Two Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55438',
                officeEmail  :  'provider3location1@gmail.com',
                urlText  :  'http://www.another-location.com',
                telephoneNumber  :  '(888)999-6666',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location1',
                distance  :  100,
                latitude  :  44.915144,
                longitude :  -93.315276)
        )

        results.providers[1].products.add(new Product())
        results.providers[1].education.add("Degree 1, Education Place 1")
        results.providers[1].specialties.add("Speciality 1")
        results.providers[1].prvdrLanguages.add('English')
        results.providers[1].prvdrLanguages.add('Spanish')
        results.providers[1].officeTimes.add('EVE')
        results.providers[1].officeTimes.add('WKD')

        results.providers.add(new Provider(
                businessName : 'A Third Provider',
                firstName : 'Alpha',
                lastName : 'Male',
                middleInitial : 'M',
                suffix : 'DDS',
                providerEmail : 'provider1@gmail.com',
                genderCode : 'M',
                providerServcDisableAdlt : true,
                providerServcDisableChld : false))

        results.providers[2].locations.add(new Location(
                businessName : 'A Third Provider',
                addressOne  :  '567 Third Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55438',
                officeEmail  :  'provider3location1@gmail.com',
                urlText  :  'http://www.another-location.com',
                telephoneNumber  :  '(888)999-6666',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location1',
                distance  :  100,
                latitude  :  44.964144,
                longitude :  -93.395276)
        );
        results.providers[2].locations.add(new Location(
                businessName : 'A Third Provider',
                addressOne  :  '888 Wow Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55438',
                officeEmail  :  'provider3location1@gmail.com',
                urlText  :  'http://www.another-location.com',
                telephoneNumber  :  '(888)999-6666',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location1',
                distance  :  100,
                latitude  :  44.960144,
                longitude :  -93.305276)
        );
        results.providers[2].locations.add(new Location(
                businessName : 'A Third Provider',
                addressOne  :  '777 Cool Street',
                addressTwo  :  '',
                stateCode  :  'MN',
                city  :  'Minneapolis',
                zip  :  '55438',
                officeEmail  :  'provider3location1@gmail.com',
                urlText  :  'http://www.another-location.com',
                telephoneNumber  :  '(888)999-6666',
                publicTransAvailable  :  true,
                officeServcDisableAdlt  :  true,
                officeServcDisableChld  :  true,
                handicappedAccessible  :  true,
                officeEmergencyMessage  :  'Not Sure What This Is',
                facilityId  :  'Location1',
                distance  :  100,
                latitude  :  44.965144,
                longitude :  -93.355276)
        );


        results.providers[2].products.add(new Product())
        results.providers[2].education.add("Degree 1, Education Place 1")
        results.providers[2].specialties.add("Speciality 1")
        results.providers[2].prvdrLanguages.add('English')
        results.providers[2].prvdrLanguages.add('Spanish')
        results.providers[2].officeTimes.add('EVE')
        results.providers[2].officeTimes.add('WKD')

        render results as JSON

    }
}
