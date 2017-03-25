using Toybox.Application as App;
using Toggl;

class TogglApp extends App.AppBase {
    hidden var _manager;
    hidden var _timer;
    hidden var _tickManager;
    hidden var _apiService;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        _apiService = new Toggl.ApiService( );
        _tickManager = new TickManager(500);
        _timer = new Toggl.TogglTimer(_tickManager);
        _manager = new Toggl.TogglManager(_timer, _apiService, getProperty("apiKey"));

        restoreTimer();
        _manager.startUpdate();
    }

    function restoreTimer() {
        var timer = getProperty("timer");
        if(timer != null) {
            _timer.setTimer( timer );
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        // Save the current timer
        setProperty("timer", _timer.getTimer());
        _manager.stopUpdate();

        _timer = null;
        _manager = null;
    }

    function onSettingsChanged() {
        _manager.setApiKey(getProperty("apiKey"));
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new TogglView(_timer, _tickManager), new TogglViewBehaviourDelegate(_manager, _timer) ];
    }

}