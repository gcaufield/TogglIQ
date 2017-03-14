using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Date;
using Toybox.Timer as Timer;
using Toybox.StringUtil as Util;

class TogglView extends Ui.View {

    hidden var _timer;
    hidden var _uiUpdate;

    function initialize(timer) {
        View.initialize();
        _timer = timer;
        _uiUpdate = new Timer.Timer();
    }

    // Load your resources here
    function onLayout(dc) {
    }

    function uiUpdate() {
        Ui.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        Ui.requestUpdate();
        _uiUpdate.start(method(:uiUpdate), 1000, true);
    }

    function updateTimerState(dc) {
        var colors = {
            Toggl.TIMER_STATE_RUNNING=> Gfx.COLOR_GREEN,
            Toggl.TIMER_STATE_STOPPED=> Gfx.COLOR_RED
        };

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_DK_GRAY);
        dc.clear();
        if(_timer.getWarnings().isEmpty()) {
            dc.setColor(colors[_timer.getTimerState()], Gfx.COLOR_DK_GRAY);
        } else {
            dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_DK_GRAY);
        }
        dc.setPenWidth(6);
        dc.drawArc(width/2, height/2, width/2 - 3, Gfx.ARC_CLOCKWISE, 245, 295);

        if( _timer.getTimerState() == Toggl.TIMER_STATE_RUNNING ) {
            var duration = _timer.getTimerDuration();
            var currentTask = _timer.getActiveTaskString();

            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_DK_GRAY);

            currentTask = wrapString( dc, currentTask, 20, 3 );

            var stringSize = dc.getTextDimensions(currentTask, Gfx.FONT_SMALL);

            dc.drawText( width/2,
                ( height / 2 ) - ( stringSize[1] / 2 ),
                Gfx.FONT_SMALL,
                currentTask,
                Gfx.TEXT_JUSTIFY_CENTER );

            // Draw the Timer Label
            dc.drawText( width/2,
                height - 33,
                Gfx.FONT_SMALL,
                formatAsTime( duration.value() ),
                Gfx.TEXT_JUSTIFY_CENTER );
        }
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
        _uiUpdate.stop();
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

    hidden function wrapString(dc, currentTask, margin, maxNumLines) {
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
            if( dc.getTextWidthInPixels( words[i], Gfx.FONT_SMALL ) >= ( width - ( 2* margin ) ) ) {
                word = "...";
            }

            newLine = newLine + word;
            tempNewLine = newLine;

            if( numLines + 1 >= maxNumLines && ( i < ( words.size() - 1 ) ) ) {
                // This is the last line and we still have words to add we need to start trying to append "..."
                tempNewLine = tempNewLine + "...";
            }

            var newLineLength = dc.getTextWidthInPixels(tempNewLine, Gfx.FONT_SMALL);
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
