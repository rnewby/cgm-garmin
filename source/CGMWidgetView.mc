using Toybox.WatchUi as Ui;
using Toybox.Communications as comms;
using Toybox.System as sys;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Attention as Attn;

//var testString = "Test the confirm";
//var returnVal = "No response";


class CGMData
{
	var lastBGdict;
	var lastStatusdict = [];
	//var lastCalsdict;
	var lastBG;
	var BGDirection;
	var BGChange;
	var rigBattery;
	var BGTrend;
	var BGTime;
	var timeNow;
	var BGAgeMin;
}

//class BaseInputDelegate extends Ui.BehaviorDelegate {
//    var cd;
//
//    function onMenu() {
//        cd = new Ui.Confirmation( testString );
//        Ui.pushView( cd, new CD(), Ui.SLIDE_IMMEDIATE );
//    }
//
//    function onNextPage() {
//    }
//}


class CGMMenu extends Ui.View {
  function openTheMenu() {
   		sys.println ("CGMMenu entered");
 
    	//var menu = new MainMenu(self);
         Ui.pushView(new Rez.Menus.MainMenu(), new CGMMenuDelegate(), Ui.SLIDE_UP);
         sys.println (returnVal);
  }
}   

class CGMWidgetView extends Ui.View 
{

	var cgmModel;
	var cgmdata;
	var device;
	
    //! Load your resources here
    function onLayout(dc) 
    {
    
        setLayout(Rez.Layouts.MainLayout(dc));
        devicehgt = dc.getHeight();
        devicewd = dc.getWidth();
        cgmdata = new CGMData();
        cgmModel = new CGMWidgetModel();
        hidesite = apprun.getProperty("hidesite");
            
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() 
    {

    cgmModel.onGo(cgmdata);
 	sys.println("show time");
    //Ui.requestUpdate();
    }


    //! Update the view
    function onUpdate(dc) 
    {
    sys.println("update time");
    
    var vibep = new Attn.VibeProfile (25, 1000);
    
    var viewTime = View.findDrawableById("TimeLabel");
    var viewBG = View.findDrawableById("BG");
    var viewDir = View.findDrawableById("BGDirection");
    var viewBGAge = View.findDrawableById("BGAgeMin");
    var viewBGChange = View.findDrawableById("BGChange");
    var viewBGUnits = View.findDrawableById("BGUnits");
    
    var currTime = sys.getClockTime();
        
    var timeString = Lang.format("$1$:$2$", [currTime.hour.format("%0.2d"), currTime.min.format("%0.2d")]); 
//    var color = Gfx.COLOR_LT_GRAY;
   
        viewTime.locY = (0.35* devicehgt.toNumber());
 		viewTime.setText(timeString);
 	sys.println("Result in onUpdate");
 	//sys.println(cgmModel.cgmresult);
 	 	
	//for(var i = 0; i < 2000 || cgmModel.cgmresult == {}; i ++) 
		//{
  		//
 		//sys.println("loopin'" + i);
 		//}
 	
	if (cgmModel.cgmresult == null) 
		{
		// if there are no results
 		sys.println("No results yet......................");
 		// reset the display fields
 		viewBG.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
 		//globalText = "Awaiting\nResults";
 		viewBG.setText(globalText);
 		
 		//viewBG.setText("Awaiting\nResults");
 		viewBGChange.setText("");
 		viewDir.setText("");
 		viewBGAge.setText("");
 		viewBGUnits.setText("");
 		}
 	else 
 		{
 		

 		// otherwise when there are results
 		//sys.println("There are now results!!!!!!!!!!!!!!!!!!!!!");
		var result = cgmModel.cgmresult;
	//	var result = cgmdata;
 		
	 	//sys.println(result.BGDirection);

		if (propunits.equals("mmol"))
		{
		//format with one decimal point if in mmol/L
 		viewBG.setText((Lang.format("$1$", [result.lastBG.format("%.1f")])));
		}
		else {
		viewBG.setText((Lang.format("$1$", [result.lastBG.format("%d")])));
		}


 		//viewBG.setText(result.lastBG);
 		//viewBGChange.setText(result.BGChange);
 		
 		viewBGChange.setText((Lang.format("$1$", [result.BGChange.format("%+0.1f")])));
 		viewBGUnits.setText(propunits.toString());
// 		viewBG.setText(result.lastBG);
 		viewDir.setText(result.BGDirection);
 		viewBGAge.setText((Lang.format("$1$", [result.BGAgeMin.format("%d")]) + " mins"));

        viewBGChange.locX = (0.8* devicewd.toNumber());
        viewBGUnits.locX = (0.8* devicewd.toNumber());
        viewBGUnits.locY = (0.6* devicehgt.toNumber());
        viewDir.locY = (0.75* devicehgt.toNumber());
        viewBGAge.locY = (0.2* devicehgt.toNumber());
        if (result.BGAgeMin > 20)
        	{
        	viewBGAge.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
        	}
        else {
        	viewBGAge.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        	}
        	
        if ((result.lastBG < 4.0) or (!propunits.equals("mmol") and result.lastBG < 72))
        	{
        	//Vibrate and set the text to red
        	Attn.vibrate([vibep]);
        	viewBG.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
        	}
        else  if ((propunits.equals("mmol") and result.lastBG > 10.0) or result.lastBG > 180)
        	{
        	viewBG.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK);
        	}
        else{
        	viewBG.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        	}
        
        //Raw data calculation
        //$scale*($unfiltered-$intercept)/$slope= egv
        
        //sys.println(device);
 		//viewDir.setText(device.toString());
 		//viewDir.setText(AppBase.getProperty("azureurl").toString());
 		}
 		
 	
 	sys.println("ready");
   	// var viewBG = View.findDrawableById("BG");
    //var viewDir = View.findDrawableById("Direction");
 	
    // Call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);
		
		if (gotData) {
			//set the drawing clour green and draw a flat line two thirds down in the middle third
			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
	        dc.drawLine((0.33* devicewd.toNumber()), (0.66* devicehgt.toNumber()), (0.66* devicewd.toNumber()), (0.66* devicehgt.toNumber()));
 		}
    //End of onUpdate function
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
   			   // Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
