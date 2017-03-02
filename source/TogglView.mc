using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class TogglView extends Ui.View {

	hidden var label;

    function initialize(timer) {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
        dc.setPenWidth(3);
        dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getHeight()/2 - 3, Gfx.ARC_CLOCKWISE, 225, 315);
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
        dc.setPenWidth(3);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getHeight()/2 - 6);
        
        
        //label = new Ui.Text( {:text => "Timer" } );
        //label.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
