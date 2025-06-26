sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/dweep/managepo/test/integration/FirstJourney',
		'com/dweep/managepo/test/integration/pages/POSetList',
		'com/dweep/managepo/test/integration/pages/POSetObjectPage',
		'com/dweep/managepo/test/integration/pages/POItemSetObjectPage'
    ],
    function(JourneyRunner, opaJourney, POSetList, POSetObjectPage, POItemSetObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/dweep/managepo') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePOSetList: POSetList,
					onThePOSetObjectPage: POSetObjectPage,
					onThePOItemSetObjectPage: POItemSetObjectPage
                }
            },
            opaJourney.run
        );
    }
);