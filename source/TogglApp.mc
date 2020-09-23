// TogglApp.mc
//
// Main Entry Point for the Toggl App
// Copyright Greg Caufield 2017

using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Time;
using Toggl;
using Toggl.Injection;
using MonkeyInject;

(:background, :glance)
class TogglApp extends App.AppBase {
  hidden var _settingsService;
  hidden var _scheduler;
  hidden var _togglManager;

  hidden var _kernel;

  function initialize() {
    AppBase.initialize();

    _kernel = new MonkeyInject.Kernel();

    // Load the components that are core to the application
    _kernel.load(new Toggl.Injection.TogglCoreModule());

    _settingsService = _kernel.build(:SettingsService);

    if( Toybox.System has :ServiceDelegate) {
      _scheduler = _kernel.build(:BackgroundScheduler);
    }
  }

  // onStop() is called when your application is exiting
  function onStop(state) {
    // As we shutdown, schedule the next update event
    if(_scheduler != null) {
      _scheduler.schedule();
    }
  }

  function onBackgroundData(data) {
    var timer = _kernel.build(:TogglTimer);
    timer.setTimer(timer);
  }

  function onSettingsChanged() {
    _settingsService.onSettingsUpdated();
  }

  function getServiceDelegate() {
    _kernel.load(new Toggl.Injection.BackgroundModule());

    // Incase we are killed before we complete. Schedule the next event as we
    // start up
    _scheduler.schedule();
    return [ _kernel.build(:ServiceDelegate) ];
  }

  // Return the initial view of your application here
  function getInitialView() {
    // Launching into the foreground, load the foregrond components
    _kernel.load(new Toggl.Injection.ForegroundModule());
    _togglManager = _kernel.build(:TogglManager);
    _togglManager.startUpdate();

    return [ _kernel.build(:View),
             _kernel.build(:ViewBehaviourDelegate)];
  }
}
