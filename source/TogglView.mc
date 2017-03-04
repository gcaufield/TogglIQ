using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Date;
using Toybox.Timer as Timer;

class TogglView extends Ui.View {

    hidden var _timer;
    hidden var _controller;
    hidden var _uiUpdate;

    function initialize(timer, controller) {
        View.initialize();
        _timer = timer;
        _controller = controller;
        _uiUpdate = new Timer.Timer();
    }

    // Load your resources here
    function onLayout(dc) {
        //setLayout(Rez.Layouts.MainLayout(dc));
    }

    function uiUpdate() {
        Ui.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        _controller.update();
        Ui.requestUpdate();
        _uiUpdate.start(method(:uiUpdate), 1000, true);
    }

    function updateTimerState(dc) {
        var colors = {
            Toggl.TIMER_REFRESH=>Gfx.COLOR_ORANGE,
            Toggl.TIMER_RUNNING=>Gfx.COLOR_GREEN,
            Toggl.TIMER_STOPPED=>Gfx.COLOR_RED
        };

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_DK_GRAY);
        dc.clear();
        dc.setColor(colors[_timer.getTimerState()], Gfx.COLOR_DK_GRAY);
        dc.setPenWidth(6);
        dc.drawArc(width/2, height/2, width/2 - 3, Gfx.ARC_CLOCKWISE, 245, 295);

        if( _timer.getTimerState() == Toggl.TIMER_RUNNING ) {
            var duration = _timer.getTimerDuration();
            //var currentTask = new Ui.Text();
            // var taskSz = dc.getTextDimensions(mTmr.getActiveTask(), Gfx.FONT_MEDIUM);

            //currentTask.setText(mTmr.getActiveTask());
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_DK_GRAY);
            dc.drawText(
            width/2,
            height - 33, Gfx.FONT_SMALL, formatAsTime(duration.value()), Gfx.TEXT_JUSTIFY_CENTER);
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

        //label = new Ui.Text( {:text => "Timer" } );
        //label.draw(dc);
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        _controller.stopUpdate();
        _uiUpdate.stop();
    }

}
