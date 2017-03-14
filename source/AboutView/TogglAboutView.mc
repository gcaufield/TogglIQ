using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class TogglAboutView extends Ui.View {
    function initialize() {
        View.initialize();
    }

    function onShow() {
        Ui.requestUpdate();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var text = "TogglIQ\n" +
            "Version - " + Ui.loadResource(Rez.Strings.Version) + "\n" +
             Ui.loadResource(Rez.Strings.Compatibility);

        var stringSize = dc.getTextDimensions(text, Gfx.FONT_SMALL);

        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_DK_GRAY);
        dc.clear();

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_DK_GRAY);
        dc.drawText( width/2,
            ( height / 2 ) - ( stringSize[1] / 2 ),
            Gfx.FONT_SMALL,
            text,
            Gfx.TEXT_JUSTIFY_CENTER );
    }
}
