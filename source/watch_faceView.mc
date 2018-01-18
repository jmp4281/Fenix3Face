using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian;
using Toybox.AntPlus as AntPlus;

class watch_faceView extends Ui.WatchFace {

    var customFont=null;
    var consolasFont=null;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
       customFont =  Ui.loadResource( Rez.Fonts.customFont );
       consolasFont =  Ui.loadResource( Rez.Fonts.consolasFont );
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
	    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        ShowCurrentTime(dc);
        ShowDate(dc);
        ShowBatteryStatus(dc);
    }
       
    function ShowCurrentTime(dc)
    {
        var clockTime = Sys.getClockTime();
        var hour = clockTime.hour;
        if(!Sys.getDeviceSettings().is24Hour)
        {
        	hour = hour % 12;
        	if(hour == 0)
            {
        		hour=12;
        	}
        }

        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2, 24, customFont, hour.toString(), Gfx.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2, 24, customFont, Lang.format("$1$", [clockTime.min.format("%02d")]), Gfx.TEXT_JUSTIFY_LEFT);
     }

	
	function getSpanishMont(month)
    { 
	    switch(month)
	    {   
            case 1: return "Ene";
            case 2: return "Feb";
            case 3: return "Mar";
            case 4: return "Abr";
            case 5: return "May";
            case 6: return "Jun";
            case 7: return "Jul";
            case 8: return "Ago";
            case 9: return "Sep";
            case 10: return "Oct";
            case 11: return "Nov";
            case 12: return "Dic";
        }
    }

	function ShowDate(dc)
    {
      	var clockTime = Sys.getClockTime();
        var local_now = Time.now();
    	var today = Gregorian.info(local_now, Time.FORMAT_SHORT	);
	    var dateString = today.day + getSpanishMont(today.month);
	    Sys.println(dateString);
     
	    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
	    dc.drawText(dc.getWidth()/2, 2, consolasFont, dateString,  Gfx.TEXT_JUSTIFY_CENTER);
    }

    function ShowBatteryStatus(dc)
    {
        var stats = Sys.getSystemStats();
        var pwr = stats.battery;
        var batStr = Lang.format( "$1$%", [ pwr.format( "%2d" ) ] );

	    Sys.println(batStr);

        var color = Gfx.COLOR_WHITE;
        if(pwr <= 20)
        {
            color = Gfx.COLOR_RED;
        }
        else if( pwr >= 80)        
        {
            color = Gfx.COLOR_GREEN;
        }

	    dc.setColor(color, Gfx.COLOR_BLACK);

	    dc.drawText(dc.getWidth()/2, 152, consolasFont, batStr,  Gfx.TEXT_JUSTIFY_CENTER);
    }


    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
