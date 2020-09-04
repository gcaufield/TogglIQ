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

  // onStop() is called when your application is exiting
  function onStop(state) {
    // As we shutdown, schedule the next update event
    if(_scheduler != null) {
      _scheduler.schedule();
    }
  }

  function onBackgroundData(data) {
    var storageService = _kernel.build(:StorageService);
    if(storageService != null) {
      storageService.setTimer(data);
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
    return [ _kernel.build(:View), _kernel.build(:ViewBehaviourDelegate)];
  }
}
