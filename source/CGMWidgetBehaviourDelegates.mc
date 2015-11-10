using Toybox.WatchUi as Ui;
using Toybox.System as sys;
using Toybox.Application as App;


class CGMWidgetDelegate extends Ui.BehaviorDelegate
{
//********************************************************************************************
// This is the main control in the app.  
//This enables the menu function on the main screen and can be used to set ontap and on swipe behaviours
//********************************************************************************************
    function onTap(evt)
    {
        //Ui.pushView(new SecondView(), new SecondInputDelegate(), Ui.SLIDE_IMMEDIATE );
        //return true;
		//dc.drawText(10, 20, Gfx.FONT_MEDIUM, "Tapped", Gfx.TEXT_JUSTIFY_LEFT);
		sys.println ("Tapped");
		return true;
    }

    function onMenu()
    {	
        //Ui.pushView( new CGMMenu(), new CGMMenuDelegate(), Ui.SLIDE_IMMEDIATE );
        Ui.pushView( new Rez.Menus.MainMenu(), new CGMMenuDelegate(), Ui.SLIDE_IMMEDIATE );
        //return true;
		sys.println ("Menu pressed");
		return true;
    }
    
	function onKeyReleased(releaseevt)
    {
	// For watches with buttons you need to launch the menu from a key press or release, not onMenu.
    	var keyid = releaseevt.getKey();
    	sys.println (keyid.toString());
    	if (keyid.toLong() == 13 || keyid.toLong() == 18) {
    	// key 13 is menu in fenix3
    	Ui.pushView( new Rez.Menus.MainMenu(), new CGMMenuDelegate(), Ui.SLIDE_IMMEDIATE );
       		    	}
	        //return true;
			sys.println ("key pressed");
			return true;
    }
}


class BackOutDelegate extends Ui.BehaviorDelegate
{
//********************************************************************************************
// This is the main control in the app.  
//This enables the menu function on the main screen and can be used to set ontap and on swipe behaviours
//********************************************************************************************
    function onBack(evt)
    {	
    	backOut();
     }
    
    	function onKeyReleased(releaseevt)
    {
	// For watches with buttons you need to launch the menu from a key press or release, not onMenu.
    	var keyid = releaseevt.getKey();
    	sys.println (keyid.toString());
    	if (keyid.toLong() == 19) {
    	// key 13 is menu in fenix3
    			backOut();
       		    	}
	        //return true;
			sys.println ("key pressed");
			
    }
    
    function backOut()
    {
    	tmr.stop();
		Ui.popView(Ui.SLIDE_DOWN);
        //Ui.pushView(new SecondView(), new SecondInputDelegate(), Ui.SLIDE_IMMEDIATE );
        //return true;
		//dc.drawText(10, 20, Gfx.FONT_MEDIUM, "Tapped", Gfx.TEXT_JUSTIFY_LEFT);
		sys.println ("Tapped to go");
		return true;
    }
}

class CGMMenuDelegate extends Ui.MenuInputDelegate {
//********************************************************************************************
// This is the main menu in the app.  
//
//********************************************************************************************
 
    function onMenuItem(item) {
  		sys.println ("CGMMenuDelegate entered");
        if (item == :item_1) {
//  Need to adjust this so that the settings menu does different things
			
			activemenu = new Rez.Menus.SettingsMenu();
			activemenu.setTitle("Settings");
			
         	Ui.pushView(activemenu, new SettingsMenuDelegate(), Ui.SLIDE_UP);


        } else if (item == :item_2) {
            // Do something else here in the Graphs menu
			    Ui.switchToView(new CGMGraphView(), new BackOutDelegate(), Ui.SLIDE_UP);
			    //cgmChartmodel.onGraph();
				sys.println(" entering graph screen");
			return globalText;
        }
    }
}

class SettingsMenuDelegate extends Ui.MenuInputDelegate 
	{
//********************************************************************************************
// This is the Settings menu in the app.  
//
//********************************************************************************************
     function onMenuItem(item) 
    	{
  		sys.println ("CGMMenuDelegate entered");
        if (item == :item_1) 
        	{
			//  Need to adjust this so that the settings menu does different things
			settingID = "sitename";
			
        	hidesite = apprun.getProperty("hidesite");
			sys.println(hidesite);
			
			if (hidesite) {
			sys.println("True");
			settingText = "";
        	}
        	else{
			settingText = apprun.getProperty("sitename");
        	}
        	        	
			Ui.pushView(new Ui.TextPicker(settingText), new TextPickerListener(), Ui.SLIDE_DOWN );

			} 
        else if (item == :item_2) 
        	{
            // Do something else here

			settingID = "hostdomain";
			activemenu = new Rez.Menus.HostMenu();
			activemenu.setTitle("Host Domain");
			sys.println(activemenu.toString());
			// Launch the  menu and return the result to the 
         	Ui.pushView(activemenu, new HostMenuDelegate(), Ui.SLIDE_UP);

			//return globalText;
        	}
        else if (item == :item_3) 
        	{
            // Do something else here

			settingID = "units";
			activemenu = new Rez.Menus.UnitsMenu();
			activemenu.setTitle("Units");
			sys.println(activemenu.toString());
			// Launch the  menu and return the result to the 
         	Ui.pushView(activemenu, new UnitsMenuDelegate(), Ui.SLIDE_UP);

			//return globalText;
        	}
        else if (item == :item_4) 
        	{
            // Do something else here

			settingID = "sitename";
			activemenu = new Rez.Menus.SiteSelectMenu();
			activemenu.setTitle("Pick a Site");
			sys.println(activemenu.toString());
			// Launch the  menu and return the result to the 
         	Ui.pushView(activemenu, new SiteSelectMenuDelegate(), Ui.SLIDE_UP);

			//return globalText;
        	}       
        // Now get the current value of the property using the setting ID
		//sys.println (globalText);
    	}
	}



class HostMenuDelegate extends Ui.MenuInputDelegate {
 // Main Menu control
    function onMenuItem(item) {
  		//sys.println ("SettingsSelectMenuDelegate entered, current value is");
        if (item == :item_1) 
        	{
			settingText = ".azurewebsites.net";
			sys.println();
			} 
        else if (item == :item_2) 
        	{
			settingText = ".herokuapp.com";
        	}
 		//settingID = loadResource(prop2);
        Ui.pushView(new Ui.Confirmation(settingText), new SettingConfirmDelegate(), Ui.SLIDE_IMMEDIATE );
  		
        return globalText;
    }
}

class UnitsMenuDelegate extends Ui.MenuInputDelegate {
 // Main Menu control
    function onMenuItem(item) {
  		//sys.println ("SettingsSelectMenuDelegate entered, current value is");
        if (item == :item_1) 
        	{
			settingText = "mmol";
			sys.println();
			} 
        else if (item == :item_2) 
        	{
			settingText = "mg/dl";
        	}
 		//settingID = loadResource(prop2);
        Ui.pushView(new Ui.Confirmation(settingText), new SettingConfirmDelegate(), Ui.SLIDE_IMMEDIATE );
  		
        return globalText;
    }
}


class SiteSelectMenuDelegate extends Ui.MenuInputDelegate {
 // Site Select Menu control
//  This is where site names are hard coded.  The resource file needs to have new menu items added, 
//  like Horse, Dragon, Rabbit, Horse, Rat, Ox, Tiger, Snake....
//  The site name that gets set from the menu is the settingText.
// 	Ugly cludge, but this seems to be the only way to make it work for the vivoactive, all other watch types can use the textpicker in the Site name menu item
// To protect the innocent, sitenames have changed.

    function onMenuItem(item) {
  		//sys.println ("SettingsSelectMenuDelegate entered, current value is");
        if (item == :item_1) 
        	{
			settingText = "mysitename";
			globalText = settingText;
			} 
        else if (item == :item_2) 
        	{
			settingText = "hollywood";
			globalText = "Snake";
        	}
       	else if (item == :item_3) 
        	{
			settingText = "Ns-horse";
			globalText = "Horse";
        	}
        	
        hidesite = apprun.getProperty("hidesite");
 		//settingID = loadResource(prop2);
        Ui.pushView(new Ui.Confirmation(globalText), new SettingConfirmDelegate(), Ui.SLIDE_IMMEDIATE );
  		
        return globalText;
    }
}



class TextPickerListener extends Ui.TextPickerDelegate {
//	hidden var origText;
	
    function onTextEntered(text, changed) {
        settingText = text;
        globalText = text;
        sys.println("settingText");
        Ui.pushView(new Ui.Confirmation(settingText), new SettingConfirmDelegate(), Ui.SLIDE_IMMEDIATE );
//        lastText = text;
//        return lastText;
    }

    function onCancel() {
    // If nothing is input leave the text as it was.
        settingText = settingText;
    }
}


class SettingConfirmDelegate extends Ui.ConfirmationDelegate {
// This control sets a property to the value input if confirm is pressed, otherwise it does nothing
    function onResponse(value) {
        if( value == 0 ) {
            sys.println("Nothing done.");
            //returnVal = "Cancel/No";
        }
        else {
            sys.println("Changed setting");
            apprun.setProperty(settingID, settingText);  
            sys.println (apprun.getProperty(settingID));
            
            	sys.println(settingText);
            	
            	sys.println(globalText);
            	
            if (globalText.toString() == settingText.toString()) {
            	apprun.setProperty("hidesite", false);
            	
            	}
            else {
            	apprun.setProperty("hidesite", true);
            	sys.println("site hidden");
            }
            //returnVal = "Confirm/Yes";
        }
    }
}
