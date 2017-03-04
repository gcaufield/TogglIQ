using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class TogglView extends Ui.View {

	hidden var _timer;

    function initialize(timer) {
        View.initialize();
        timer.setOnPropertyChanged(method(:onPropertyChanged));
        _timer = timer;
    }

    // Load your resources here
    function onLayout(dc) {
    }
    
    function onPropertyChanged(sender, property) {
    	Ui.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    function updateTimerState(dc) {
    	var colors = {
    		Toggl.TIMER_REFRESH=>Gfx.COLOR_ORANGE,
    		Toggl.TIMER_RUNNING=>Gfx.COLOR_GREEN,
    		Toggl.TIMER_STOPPED=>Gfx.COLOR_RED
		};
		
        dc.setColor(colors[_timer.getTimerState()], Gfx.COLOR_BLACK);
        dc.setPenWidth(3);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getHeight()/2 - 3);
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        updateTimerState(dc);
        
        //label = new Ui.Text( {:text => "Timer" } );
        //label.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
