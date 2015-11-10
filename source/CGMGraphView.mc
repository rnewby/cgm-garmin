using Toybox.WatchUi as Ui;
using Toybox.Communications as comms;
using Toybox.System as sys;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
//using Toybox.Attention as Attn;



class CGMGraphView extends Ui.View 
{
	// provides an object to get data into.
	var CGMGraphModel;
//	var vibep = new Attn.VibeProfile(100, 15);
				
	// scales for the chart so that points can be calculated.
	hidden 	var xscale;
	hidden 	var yscale;	
	//x and y to make it easier to set array contents.
	hidden 	var x = 0;
	hidden 	var y = 0;
	// Define a couple of arrays to receive the x and y coordinates, use th global variable to define the dimension
  	var xarray = new [graphpts];
    var yarray = new [graphpts];
    // maxx and maxy are used to define the max size of the chart, this enables scaling etc.
    hidden var maxx = 0.85;
    hidden var maxy = 0.5;
	
    //! Load your resources here
    function onLayout(dc) 
    {
    sys.println("Graph view layout");
        setLayout(Rez.Layouts.GraphLayout(dc));
		
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() 
    {
    sys.println("show");
    CGMGraphModel = new cgmGraphModel();
    CGMGraphModel.onGraph();
 	sys.println("show graph time");
    //Ui.requestUpdate();
    }


    //! Update the view
    function onUpdate(dc) 
    {

    sys.println("Graph view show");
    var viewBG = View.findDrawableById("BG");
    var viewHrStart = View.findDrawableById("HrStart");
    var viewHrMid = View.findDrawableById("HrMid");
    var viewHrEnd = View.findDrawableById("HrEnd");
//    var color = Gfx.COLOR_LT_GRAY;
   
 	sys.println("Result in onUpdate");
 	//sys.println(CGMGraphModel.graphresult);
 	 	
	//for(var i = 0; i < 2000 || cgmModel.cgmresult == {}; i ++) 
		//{
  		//
 		//sys.println("loopin'" + i);
 		//}
 	
	if (CGMGraphModel.graphresult == null) 
		{
		// if there are no results

 		sys.println("No results yet......................");
 		// reset the display fields
 		viewBG.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
 		viewBG.setText("Awaiting\nResults");
 		viewHrStart.setText("");
    	viewHrMid.setText("");
    	viewHrEnd.setText("");
 		}
 	else 
 		{
 		// otherwise when there are results

		//Attn.vibrate([vibep]);
		var result = CGMGraphModel.graphresult;
 		
 		// Set vertical scale for mmol
 		yscale = (maxy * devicehgt)/20;
 		//Set horizontal scale by minute this is the 

 		xscale = (maxx * devicewd)/(60 * ((result.lastHour - result.firstHour)+1));
 		
 		//sys.println("Last hour is: " + result.lastHour.toString() + " First hour is:" + result.firstHour.toString());
 		
 		viewHrStart.setText(result.lastHour.toString());
 		
 	//	viewBG.setText((Lang.format("$1$", [(result.BGArray[0]/18.0).format("%.1f")])))
 		viewHrMid.setText((Lang.format("$1$", [((result.firstHour+(result.lastHour-result.firstHour)/2.0)).format("%.1f")])) + "hrs");
 		
    	//viewHrMid.setText((result.lastHour-result.firstHour)/2.toString());
    	viewHrEnd.setText(result.firstHour.toString());
 		
 		viewHrEnd.locY = ((1.5 * maxy) * devicehgt.toNumber()).toNumber();
 		viewHrEnd.locX = ((maxx) * devicewd.toNumber()).toNumber();
 		 		
 		viewHrMid.locY = ((1.5 * maxy) * devicehgt.toNumber()).toNumber();
 		viewHrMid.locX = ((0.5) * devicewd.toNumber()).toNumber();
 			 		
 		viewHrStart.locY = ((1.5 * maxy) * devicehgt.toNumber()).toNumber();
 		viewHrStart.locX = ((1 - maxx) * devicewd.toNumber()).toNumber();
 		
 		
 		y =  (maxy * devicehgt.toNumber());
 		
 		sys.println(xscale.toString());
 		
 		
 		sys.println("Incoming......................");
 		
	 	//sys.println(result.BGDirection);


 	   	for(var i = 0; i < result.TimesArray.size(); i ++) 
		{
				x = (xcoord(xscale, result.firstHour, result.TimesArray[i])).toNumber();
 				y = (ycoord(yscale, result.BGArray[i])).toNumber();
 				
 				xarray[i] = x;
 				yarray[i] = y;
 				sys.println(xarray.toString());
				sys.println(yarray.toString());
		}
		
		
		//Set the last BG value above the chart
		if (propunits.equals("mmol"))
		{
		//format with one decimal point if in mmol/L
 		viewBG.setText((Lang.format("$1$", [(result.BGArray[0]/18.0).format("%.1f")])));
 		
 		sys.println(result.toString());
 
		}
		else {
		viewBG.setText((Lang.format("$1$", [result.BGArray[0].format("%+.d")])));
		}
		
		        	
		//x = (xcoord(xscale, result.firstHour, result.TimesArray[0])).toNumber();
        //	sys.println(result.TimesArray[0].toString());
        	
       // 	sys.println("Firsthour:" + result.firstHour.toString());
        	
        //	sys.println("Xscale:" + xscale.toString());
        	
        	  	
   	

 		//viewBG.setText(devicewd.toString());
 		
 		

 		}
 		
 		
 		
 		
 	
 	sys.println("ready");
   	// var viewBG = View.findDrawableById("BG");
    //var viewDir = View.findDrawableById("Direction");
 	
    // Call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);
		
	    if (gotData) {
			
			var lowy = ycoord(yscale, 72);
			var highy = ycoord(yscale, 144);
			
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
 // lines for low and high threshold
	        dc.drawLine(((1-maxx)* devicewd.toNumber()), lowy , (maxx * devicewd.toNumber()), lowy);
	        dc.drawLine(((1-maxx)* devicewd.toNumber()), highy , (maxx * devicewd.toNumber()), highy);


// border for chart
			dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
			dc.drawRectangle(
				((1-maxx)* devicewd.toNumber()), 
				(0.5* maxy * devicehgt.toNumber()), (((2*maxx)-1) * devicewd.toNumber()), (maxy * devicehgt.toNumber()));

			
			// Iterate through the data points and chart them.
			 	   	for(var i = 0; i < xarray.size(); i ++) 
		{// hypo goes red
			if (yarray[i].toNumber() > lowy)
			{dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
			}
			//hyper goes orange
			else 			if (yarray[i].toNumber() < highy)
			{dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_BLACK);
			}
			else
			
			{dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
			}
			
		dc.fillCircle(xarray[i].toNumber(), yarray[i].toNumber(), 2);
			}
			
			// Once the chart has been opened, close after 9 seconds
		tmr.start(method(:closeTheView), 9000, false);
			
 		}	

		
		
//		if (gotData) {
//			//set the drawing clour green and draw a flat line two thirds down in the middle third
//
//		x = (xcoord(xscale, result.firstHour, result.TimesArray[0])).toNumber();
//
//
//			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
//	        dc.drawLine((0.33* devicewd.toNumber()), (0.66* devicehgt.toNumber()), (0.66* devicewd.toNumber()), (0.66* devicehgt.toNumber()));
//			dc.fillCircle(x.toNumber(), y.toNumber(), 3);

// 		}
    //End of onUpdate function
    }

	function xcoord(xscale, firsthr, mins) {
	var x;
	x = ((maxx * devicewd.toNumber()) - ((mins - (firsthr * 60))* xscale)).toNumber();
	//x = ((0.8 * devicewd.toNumber()) - (mins * xscale));
	return x;
	}

	function ycoord(yscale, BG) {
				
//	if (propunits.equals("mmol"))
//		{
//			BG = BG;
// 		}
//	else {
			// to make scaling easier
			BG = BG/18.0;
//		}
 		
	var y;
	y = (((1.5*maxy)	* devicehgt.toNumber()) 	- ((BG - 2)* yscale)).toNumber();
	return y;
	}

	function closeTheView()
	{
	sys.println("poppingview");
	tmr.stop();
	Ui.popView(Ui.SLIDE_IMMEDIATE);
	}

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
   			    //Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

}
