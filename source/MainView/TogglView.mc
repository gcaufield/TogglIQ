using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Date;
using Toybox.Timer as Timer;
using Toybox.StringUtil as Util;
using Toybox.Math as Math;

class TogglView extends Ui.View {

    const TIMER_FONT = Gfx.FONT_NUMBER_MEDIUM;
    const TASK_FONT = Gfx.FONT_MEDIUM;
    const NTFCTN_FONT = Gfx.FONT_XTINY;
    const NTFCTN_MARGIN = 6;
    const TASK_NUM_LINES = 3;
    const TASK_MARGIN = 18;

    const COLORS = {
        Toggl.TIMER_STATE_RUNNING=> Gfx.COLOR_GREEN,
        Toggl.TIMER_STATE_STOPPED=> Gfx.COLOR_RED
    };

    const NTFCTN_MESG = {
        Toggl.TIMER_NTFCTN_REQUEST_FAILED=> Rez.Strings.RequestFailed
    };

    hidden var _timer;
    hidden var _update;

    function initialize(timer, tickManager) {
        View.initialize();
        _timer = timer;

        tickManager.addListener( method(:onTick), 1000 );
    }

    // Load your resources here
    function onLayout(dc) {
    }

    function uiUpdate() {
        Ui.requestUpdate();
    }

    function onTick() {
        if( _update ) {
            uiUpdate();
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        Ui.requestUpdate();
        _update = true;
    }

    function updateTimerState(dc) {
        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_DK_GRAY);
        dc.clear();

        drawTimerLabel( dc );
        drawTimerArc( dc );
        drawNotification( dc );
    }

    hidden function drawTimerLabel( dc ) {
        if( _timer.getTimerState() == Toggl.TIMER_STATE_RUNNING ) {
            var duration = _timer.getTimerDuration();
            var currentTask = _timer.getActiveTaskString();
            var width = dc.getWidth();
            var height = dc.getHeight();

            var timeString = formatAsTime( duration.value() );

            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_DK_GRAY);
            // Draw the Timer Label
            dc.drawText( width/2,
                getTimerOffset( dc, timeString ),
                TIMER_FONT,
                timeString,
                Gfx.TEXT_JUSTIFY_CENTER );

            currentTask = wrapString( dc, currentTask, TASK_FONT, TASK_MARGIN, TASK_NUM_LINES );

            var stringSize = dc.getTextDimensions(currentTask, TASK_FONT);

            dc.drawText( width/2,
                ( height / 2 ) - ( stringSize[1] / 2 ),
                TASK_FONT,
                currentTask,
                Gfx.TEXT_JUSTIFY_CENTER );

        }

    }

    hidden function drawTimerArc(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        if(_timer.getWarnings().isEmpty()) {
            dc.setColor(COLORS[_timer.getTimerState()], Gfx.COLOR_DK_GRAY);
        } else {
            dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_DK_GRAY);
        }

        dc.setPenWidth(12);
        dc.drawArc(width/2, height/2, width/2 - 2, Gfx.ARC_CLOCKWISE, 230, 310);
    }

    //! Draws the notification box if there is a pending notification
    //!
    //! @param dc - Dc object for the current update
    hidden function drawNotification( dc ) {
        var notification = _timer.getNotification();
        if( null != notification ) {
            var width = dc.getWidth();
            var height = 60;

            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_DK_GRAY);
            dc.fillRectangle( 0, 0, width, height );

            var ntfctnStr = Ui.loadResource( NTFCTN_MESG.get( notification ) );
            var ntfctnHeight = dc.getTextDimensions( ntfctnStr, NTFCTN_FONT )[1];
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_BLACK );
            dc.drawText( width / 2,
                height - ( ntfctnHeight + NTFCTN_MARGIN ),
                NTFCTN_FONT,
                ntfctnStr,
                Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

    //! Finds the offset from the bottom of the screen required to display the timer string
    //!
    //! @param dc - Dc object for the current update
    //! @param string - String to display
    hidden function getTimerOffset(dc, string) {
        // Get the radius of the display
        var r = dc.getWidth() / 2;

        // Get the height and width of the string
        var dimensions = dc.getTextDimensions(string, TIMER_FONT);

        // Use the chord that is made by the timer string
        var x = dimensions[0] / 2;

        // Find the distance from the chord to the center of the circle using Pathgoreans
        // (and they said we wouldn't need it after high school)
        var y = Math.pow(r, 2) - Math.pow(x, 2);
        y = Math.sqrt(y);

        // Calculate the required Y offset by finding the distance from the bottom of the
        // display to the chord and add the height of the string because we want the bottom
        // of the string to sit on the chord
        return dc.getHeight() - ( ( r - y ) + dimensions[1] );
    }

    function formatAsTime(seconds) {
        var hours = seconds / Date.SECONDS_PER_HOUR;
        seconds = seconds - ( hours * Date.SECONDS_PER_HOUR );
        var minutes = seconds / Date.SECONDS_PER_MINUTE;
        seconds = seconds - ( minutes * Date.SECONDS_PER_MINUTE );

        return Lang.format("$1$:$2$:$3$", [hours.format("%02d"), minutes.format("%02d"), seconds.format("%02d")]);
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        updateTimerState(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        _update = false;
    }

    //! Splits a string into an array of words
    hidden function splitWords(currentTask) {
        if( currentTask == null ) {
            return [];
        }
        var letters = currentTask.toUtf8Array();
        var wordStart = 0;
        var wordEnd = 0;
        var words = [];

        // Split Words
        for( var i = 0; i < letters.size(); i++ ) {
            wordEnd = i;
            if(letters[i] == ' ') {
                // End of a word
                if( wordStart != wordEnd ) {
                    // New word
                    words.add(Util.utf8ArrayToString(letters.slice(wordStart, wordEnd)));
                }

                wordStart = i + 1;
            }
        }

        if( wordStart < letters.size() ) {
            // We hit the end of the array with a valid word
            words.add(Util.utf8ArrayToString(letters.slice(wordStart, null)));
        }

        return words;
    }

    hidden function wrapString(dc, currentTask, font, margin, maxNumLines) {
        // We need to wrap the text if a single line does not fit on the display
        var words = splitWords( currentTask );
        var width = dc.getWidth();
        var height = dc.getHeight();

        currentTask = "";
        var currentLine = "";
        var newLine = "";
        var newLineLength;
        var numLines = 0;

        for( var i = 0; i < words.size(); i++ ) {
            var word = words[i];
            var tempNewLine;
            if( dc.getTextWidthInPixels( words[i], font) >= ( width - ( 2* margin ) ) ) {
                word = "...";
            }

            newLine = newLine + word;
            tempNewLine = newLine;

            if( numLines + 1 >= maxNumLines && ( i < ( words.size() - 1 ) ) ) {
                // This is the last line and we still have words to add we need to start trying to append "..."
                tempNewLine = tempNewLine + "...";
            }

            var newLineLength = dc.getTextWidthInPixels(tempNewLine, font);
            if( newLineLength < ( width - ( 2 * margin ) ) ) {
                // This line is okay.
                currentLine = tempNewLine;
                newLine = newLine + " ";

            }
            else if( currentLine.length() == 0 ) {
                // This is a single word that is too long to fit on the display...
                newLine = "...";
            }
            else {
                // Append Current Line to our task, and start building a new line
                currentTask = currentTask + currentLine;
                currentLine = "";

                numLines = numLines + 1;
                if( numLines >= maxNumLines ) {
                    break;
                }
                else {
                    currentTask = currentTask + "\n";
                    newLine = "";
                    i--;
                }
            }
        }

        currentTask = currentTask + currentLine;
        return currentTask;
    }
}
