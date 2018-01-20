using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian;
using Toybox.AntPlus as AntPlus;
using Toybox.ActivityMonitor;
using Toybox.System;


class watch_faceView extends Ui.WatchFace {

    var VERT_OFFSET  = 5;
    var TIME_X = null;
    var TIME_Y = 24+VERT_OFFSET;
    var DATE_X = null;
    var DATE_Y = 2+VERT_OFFSET;
    var BAT_X = 150;
    var BAT_Y = 145+VERT_OFFSET;
    var HR_X = 35;
    var HR_Y = 145+VERT_OFFSET;
    var STEPS_X = 55;
    var STEPS_Y = 172+VERT_OFFSET;



    var customFont=null;
    var consolasFont=null;
    var heartRate = null;

    function initialize() {
        WatchFace.initialize();
    }

    function onSensor(sensorInfo) {
        heartRate = sensorInfo.heartRate;
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
	  
        DATE_X  = dc.getWidth()/2;
        TIME_X  = DATE_X;

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        ShowCurrentTime(dc);
        ShowDate(dc);
        ShowBatteryStatus(dc);
        ShowHeartRate(dc);
        ShowSteps(dc);
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
        dc.drawText(TIME_X, TIME_Y, customFont, Lang.format("$1$", [hour.format("%02d")]), Gfx.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
        dc.drawText(TIME_X, TIME_Y, customFont, Lang.format("$1$", [clockTime.min.format("%02d")]), Gfx.TEXT_JUSTIFY_LEFT);
     }

	function getSpanishMonth(month)
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
	    var dateString = today.day + getSpanishMonth(today.month);
	    //Sys.println(dateString);
	    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
	    dc.drawText(DATE_X, DATE_Y, consolasFont, dateString,  Gfx.TEXT_JUSTIFY_CENTER);
    }


    function ShowBatteryStatus(dc)
    {
        var stats = Sys.getSystemStats();
        var pwr = stats.battery;
        var batStr = Lang.format( "$1$%", [ pwr.format( "%2d" ) ] );
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
	    dc.drawText(BAT_X, BAT_Y, consolasFont, batStr,  Gfx.TEXT_JUSTIFY_LEFT);
    }

    function ShowHeartRate(dc)
    {
        var hrIterator = ActivityMonitor.getHeartRateHistory(1, true); //pido dos
        var sample = hrIterator.next();
   
        if (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE)    // check for invalid samples
        {
            var lastSampleTime = sample.when;
        }

        // get ActivityMonitor info
        // var info = ActivityMonitor.getInfo();
        //var steps = info.steps;
        //var calories = info.calories;

        var hrRate = sample.heartRate;
        var color = Gfx.COLOR_LT_GRAY;
        //Supongo mi HR maximo = 180
        if(hrRate >= 162)
        {
            color = Gfx.COLOR_RED;
        }
        else if( hrRate < 162 && hrRate>= 144)        
        {
            color = Gfx.COLOR_ORANGE;
        }
        else if( hrRate < 144 && hrRate>= 126)        
        {
            color = Gfx.COLOR_RED;
        }else if( hrRate < 126 && hrRate>= 108)        
        {
            color = Gfx.COLOR_BLUE;
        }

        dc.setColor(color, Gfx.COLOR_BLACK);
        var hrText = "HR: " + hrRate;
        dc.drawText(HR_X, HR_Y, consolasFont, hrText,  Gfx.TEXT_JUSTIFY_LEFT);
     }

    function ShowSteps(dc)
    {
        var info = ActivityMonitor.getInfo();
        var steps = Lang.format("$1$", [info.steps.format("%04d")]);
        //var calories = info.calories;

        var color = Gfx.COLOR_RED;

        if(info.steps >=5000)
        {
            color = Gfx.COLOR_GREEN;
        }else if(info.steps < 5000  && info.steps >=2000) {
            color = Gfx.COLOR_BLUE;
        }

        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        dc.drawText(STEPS_X, STEPS_Y, dc.FONT_SMALL, "Steps: ",  Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.drawText(STEPS_X+65, STEPS_Y, dc.FONT_SMALL, steps,  Gfx.TEXT_JUSTIFY_LEFT);
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
