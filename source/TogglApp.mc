using Toybox.Application as App;
using Toggl;

class TogglApp extends App.AppBase {
	hidden var _manager;
	hidden var _timer;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	_timer = new Toggl.TogglTimer();
    	_manager = new Toggl.TogglManager(_timer);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new TogglView(_timer) ];
    }

}