using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Time;
using Toggl;
using Toggl.Injection;

class TogglApp extends App.AppBase {
  hidden var _manager;
  hidden var _timer;
  hidden var _tickManager;
  hidden var _apiService;

  hidden var _kernel;

  function initialize() {
    AppBase.initialize();

    _kernel = new Kernel();

    // Load the components that are core to the application
    _kernel.load(new Toggl.Injection.TogglCoreModule());
  }

  function restoreTimer() {
    var timer = getProperty("timer");
    if(timer != null) {
      _timer.setTimer(timer);
    }
  }

  // onStop() is called when your application is exiting
  function onStop(state) {
    if(_timer != null) {
      setProperty("timer", _timer.getTimer());
      _timer = null;
    }

    if(_manager != null) {
      _manager.stopUpdate();
      _manager = null;
    }

    // When stopping register for a background event 30 seconds from now
    //var duration = new Time.Duration(30);
    //var eventTime = Time.now().add(duration);
    //Background.registerForTemporalEvent(eventTime);
  }

  function getServiceDelegate() {
    _kernel.load(new Toggl.Injection.BackgroundModule());
    return [ _kernel.build(:ServiceDelegate) ];
  }

  function onSettingsChanged() {
    if(_manager != null) {
      _manager.setApiKey(getProperty("apiKey"));
    }
  }

  // Return the initial view of your application here
  function getInitialView() {
    // Launching into the foreground, load the foregrond components
    _kernel.load(new Toggl.Injection.ForegroundModule());

    _manager = _kernel.build(:TogglManager);
    _timer = _kernel.build(:TogglTimer);

    _manager.setApiKey(getProperty("apiKey"));
    restoreTimer();

    if(_timer != null) {
      restoreTimer();
    }

    if(_manager != null) {
      _manager.startUpdate();
      _manager.setApiKey(getProperty("apiKey"));
    }

    return [ _kernel.build(:View), _kernel.build(:ViewBehaviourDelegate)];
  }
}
