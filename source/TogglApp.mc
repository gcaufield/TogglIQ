// TogglApp.mc
//
// Main Entry Point for the Toggl App
// Copyright Greg Caufield 2017

using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Time;
using Toggl;
using Toggl.Injection;

class TogglApp extends App.AppBase {
  hidden var _manager;
  hidden var _timer;
  hidden var _settingsService;
  hidden var _scheduler;

  hidden var _kernel;

  function initialize() {
    AppBase.initialize();

    _kernel = new Kernel();

    // Load the components that are core to the application
    _kernel.load(new Toggl.Injection.TogglCoreModule());
    _settingsService = _kernel.build(:SettingsService);
    _scheduler = _kernel.build(:BackgroundScheduler);
  }

  function restoreTimer() {
    var timer = getProperty("timer");
    if(timer != null) {
      _timer.setTimer(timer);
    }
  }

  // onStop() is called when your application is exiting
  function onStop(state) {
    // As we shutdown, schedule the next update event
    _scheduler.schedule();

    if(_timer != null) {
      setProperty("timer", _timer.getTimer());
      _timer = null;
    }

    if(_manager != null) {
      _manager.stopUpdate();
      _manager = null;
    }
  }

  function onSettingsChanged() {
    _settingsService.onSettingsUpdated();
  }

  function getServiceDelegate() {
    _kernel.load(new Toggl.Injection.BackgroundModule());
    return [ _kernel.build(:ServiceDelegate) ];
  }

  // Return the initial view of your application here
  function getInitialView() {
    // Launching into the foreground, load the foregrond components
    _kernel.load(new Toggl.Injection.ForegroundModule());

    _manager = _kernel.build(:TogglManager);
    _timer = _kernel.build(:TogglTimer);

    if(_timer != null) {
      restoreTimer();
    }

    if(_manager != null) {
      _manager.startUpdate();
    }

    return [ _kernel.build(:View), _kernel.build(:ViewBehaviourDelegate)];
  }
}
