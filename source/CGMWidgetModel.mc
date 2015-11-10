using Toybox.WatchUi as Ui;
using Toybox.Communications as comms;
using Toybox.System as sys;
using Toybox.Application as App;



class WatchData
{
	var watchBattery;
	var currentTime;
}

class GraphData
{	//var records = graphpts;
	var BGArray = new [graphpts];
	var TimesArray = new [graphpts];
	var lastTime;
	var firstTime;
	var lastDateString;
	var lastHour;
	var firstHour;
}

class CGMWidgetModel 

{	hidden var url;
	var cgmresult;
	hidden var cgmdata;
	var notify;

	function initialize(handler)
    {
        notify = handler;
    }
    

	function onGo(CGMdata) 
	{
		gotData = false;
		cgmdata = CGMdata;
		sys.println ("setting the URL from application properties");
		
		url = "https://" + apprun.getProperty("sitename") + apprun.getProperty("hostdomain") + "/pebble";
 
    	//var url = "https://phimbycgm.azurewebsites.net/pebble";
        //cgmdata = new CGMData();


    	sys.println (url);
    	
    	// to get the next line to work you need to edit the manifest and add th following line into iq:permissions tags
		//            <iq:uses-permission id="Communications"/>


		var currentstats = statistics.getSystemStats();
		sys.println ("Battery percentage");
		sys.println (currentstats.battery.toString());
		
		propunits = apprun.getProperty("units");

		var currentsettings = sys.getDeviceSettings();
			//var currentsettings = dvcsettings.getDeviceSettings();
		sys.println(propunits);
		sys.println(currentsettings.phoneConnected);

		if (currentsettings.phoneConnected) {
		globalText = "Awaiting\nResults";
		
    	//sys.println (url);
// 		comms.makeJsonRequest(url ,{} ,{} ,{});
    	comms.makeJsonRequest(url ,{"units"=>propunits} ,null ,method(:onReceive));
     	sys.println ("Receiving");
     	}
    	else {
		globalText = "Phone not\nconnected";
		}
		
	}



	function onReceive(responseCode, data)
    { 
   	
		gotData = true;
    	sys.println ("Receiving data");
        if( responseCode == 200 )
        {
        
        	if (data["bgs"].size()!=0) {
	    		sys.println("BG data");
//    		sys.println ("Data back");
//            sys.println(cgmdata.lastBG);
	    		sys.println(data);
	    		sys.println(data["status"]);
	    		sys.println(data["bgs"]);
    		
    		
	    		
	            //data is returned to a dictionary
				// Sample data set
				//   {"status":[{"now":1441325110685}],"bgs":[{"sgv":"6.7","bgdelta":"-0.5","trend":5,"direction":"FortyFiveDown","datetime":1441321560000,"battery":"38"}],"cals":[]}
	            cgmdata.lastBGdict = fixArray(data["bgs"]);
				//cgmdata.lastCalsdict = fixArray(data["cals"]);  //Pulls out cals dictionary from json only use in the future
				cgmdata.lastStatusdict = fixArray(data["status"]);  //Pulls out status dictionary from json
				
				var test =  cgmdata.lastBGdict;
				
	
	    		
				
				
	    		sys.println(cgmdata.lastBGdict["sgv"]);
	    		
				
	    		cgmdata.lastBG = cgmdata.lastBGdict["sgv"].toFloat();  // Now get the Last BG value
	   		 	cgmdata.BGDirection = cgmdata.lastBGdict["direction"]; // Now get the direction
//	   		 	cgmdata.BGChange = cgmdata.lastBGdict["bgdelta"].toString(); // Now get the change
	   		 	cgmdata.BGChange = cgmdata.lastBGdict["bgdelta"].toString().toFloat(); // Now get the change
	   		 	cgmdata.BGTrend = cgmdata.lastBGdict["bgtrend"]; // Now get the trend
	   		 	cgmdata.rigBattery = cgmdata.lastBGdict["battery"]; // Now get the rig battery
				cgmdata.BGTime = cgmdata.lastBGdict["datetime"];
	 			cgmdata.timeNow = cgmdata.lastStatusdict["now"];
				
				cgmdata.BGAgeMin = (cgmdata.timeNow - cgmdata.BGTime)/60000;
				lastDataTime = cgmdata.timeNow;
				
	 //			sys.println(cgmdata.timeNow);
	 //			sys.println(cgmdata.lastBG);
	 //			sys.println(cgmdata.BGAgeMin.format("%d")); // convert min age to an integer
				
				
				
	 //			sys.println(cgmdata.lastStatusdict);	
	   		 	
	 		//var runs = App.getApp();
	 		
	 		//runs.loadProperties();
	 		var azureurl = apprun.getProperty("azureurl");
	 		
	 //   	sys.println (azureurl);
	 		
	       		cgmresult = cgmdata;
	    		//cgmdata = null;
	    		//notify.invoke(cgmresult);
    		}
    		else{
	    		sys.println("No BG data");
	    		globalText = "No BG data";
    		}
		}
		else if (responseCode == -2){
		globalText = "No internet\nconnection";
		}
		else {
		globalText = "Website\nError: " + responseCode.toString();
		}
		Ui.requestUpdate();
	}
	
	
	function fixArray (array)
	{ //Due to the nested array in the dictionaries,
	//	this pulls a dictionary out of an array for use.	
	//sys.println(array.size());
	if (array.size() == 1) 
		{
		return array[0];  // some data is not an array of dimension one this is to handle that.
		} 
	else 
		{
		return array; // just send the original back just in case.
		}
	}
	
	
}


class cgmGraphModel 

{	hidden var url;
	var graphresult;
	var graphdata;
	var notify;
	

	function initialize(handler)
    {
        notify = handler;
    }
    


	function onGraph() 
	{
		gotData = false;

		sys.println ("setting the URL from application properties");
		//https://phimbycgm.azurewebsites.net/api/v1/entries/sgv.json?count=20;
		
		url = "https://" + apprun.getProperty("sitename") + apprun.getProperty("hostdomain") + "/api/v1/entries/sgv.json";

        graphdata = new GraphData();
    	sys.println (url);
    	sys.println (graphpts);
    	
    	// to get the next line to work you need to edit the manifest and add th following line into iq:permissions tags
		//            <iq:uses-permission id="Communications"/>

		//var statistics = new sys.Stats();
		var currentstats = statistics.getSystemStats();
		
		propunits = apprun.getProperty("units");


		var currentsettings = sys.getDeviceSettings();
			//var currentsettings = dvcsettings.getDeviceSettings();
		sys.println(currentsettings.phoneConnected);

		if (currentsettings.phoneConnected) {
		globalText = "Awaiting\nResults";
 		//comms.makeJsonRequest(url ,{} ,{} ,{});
    	comms.makeJsonRequest(url ,{"count"=>graphpts} ,null ,method(:onGraphReceive));
    	sys.println ("Receiving");
    	}
		else {
		globalText = "Phone not\nconnected";
 		
		}


	}

	
	function onGraphReceive(responseCode, data)
    { 
   	
		gotData = true;
    	sys.println ("Receiving data");
    	sys.println (data);
        if(responseCode == 200)
        {
    		sys.println ("Data back");
//            sys.println(cgmdata.lastBG);
			var last = data[(data.size()-1)];
			var first = data[0];
			var curr = data[(data.size()-1)];
    		sys.println(data[1]);
    		sys.println(data[1]);
    		sys.println(curr["sgv"]);
    		graphdata.lastTime = curr["date"];
    		graphdata.firstTime = first["date"];
    		graphdata.lastDateString = curr["dateString"];
    		
    		var firstmins = (lastDataTime - graphdata.firstTime)/60000;
    		var lastmins = (lastDataTime - graphdata.lastTime)/60000;
    		graphdata.firstHour = (firstmins/60).toNumber();
    		graphdata.lastHour = ((lastmins/60).toNumber()+1);
    		
    		sys.println("firstmins.toString()");
    		sys.println(firstmins.toString());
    		
    		
    	for(var i = 0; i < data.size(); i ++) 
		{curr = data[i];
			//if (propunits.equals("mmol"))
			//	{
				//divide bg by 18 if in mmol/L, as this makes charting easier
 		//		graphdata.BGArray[i] = (curr["sgv"]/18.0);
			//	}
		//		else {
				graphdata.BGArray[i] = curr["sgv"];
		//		}

	
	// Global variable lastDataTime ages data.
		graphdata.TimesArray[i] = ((lastDataTime - curr["date"])/60000);
  		//
 		sys.println(graphdata.BGArray);
 		sys.println(graphdata.TimesArray);
 		}
    		
    		
    		graphresult = graphdata;
            //data is returned to a dictionary
			// Sample data set
    		//cgmdata = null;
    		//notify.invoke(cgmresult);
  		}
		else {
		gotData = false;
		globalText = "Website\nError: " + responseCode.toString();
		}
		Ui.requestUpdate();
		
	}
	
	
	
	function fixArray (array)
	{ //Due to the nested array in the dictionaries,
	//	this pulls a dictionary out of an array for use.	
	//sys.println(array.size());
	if (array.size() == 1) 
		{
		return array[0];  // some data is not an array of dimension one this is to handle that.
		} 
	else 
		{
		return array; // just send the original back just in case.
		}
	}
	
	
}

