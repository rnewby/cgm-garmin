using Toybox.Application as App;
using Toybox.System as sys;
using Toybox.Timer as Timr;

//Declare global variables, only set type when first used
var globalText = "Starting up";
var settingText = "";
var settingID;
var gotData = false;
var battery;
var lastDataTime;
var settings = {};
//var propsite;
//var prophost;
var propunits;
var activemenu;	
var devicehgt;
var devicewd;
var graphpts = 18;
var statistics;
var tmr;
var tmrrefresh;
var hidesite;


//var string4;
//var string5;
//var string6;

//variable for application runtime
var apprun;

class CGMWidgetApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    // get the runtime of the application for use within app.
    apprun = App.getApp();
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
    
 		//This is just to test property setting and make it work first time when developing.
//    setProperty("units", "mmol");   
//    setProperty("hostdomain", ".azurewebsites.net");  
//    setProperty("sitename", "phimbyscgm");
//    setProperty("appVersion", "0.0.2");
		// to help debug properties
		//var props = apprun.getProperty("bobster");
		//sys.println(props);
		tmr = new Timr.Timer();
		tmr.stop();
		statistics = new sys.Stats();
		// if the hostdomain or sitename properties are null set them to a default
		if (apprun.getProperty("hostdomain") == null) {
		setProperty("hostdomain", ".azurewebsites.net");	
		}
		
		if (null == apprun.getProperty("sitename")) {
		setProperty("sitename", "phimbycgm");	
		}
		
				if (apprun.getProperty("units") == null) {
		setProperty("units", "mmol");	
		}

				if (apprun.getProperty("hidesite") == null) {
		setProperty("hidesite", false);	
		}



    	        return [ new CGMWidgetView(), new CGMWidgetDelegate() ];
    }

}