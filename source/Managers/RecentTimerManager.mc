//! RecentTimerManager.mc
//!
//! Copyright Greg Caufield 2020
using Toybox.WatchUi;
using Toybox.System;

module Toggl {
module Managers {

  class TimerData {
    private var _description;
    private var _pid;

    function initialize(data) {
      _description = data["description"];
      _pid = data["pid"];
    }

    function equals(other) {
      return (_description != other._description);
    }

    function getDescription() {
      return _description;
    }

    function getShortDescription() {
      if(_description.length() < 11) {
        return _description;
      }
      else {
        return _description.substring(0,8) + "...";
      }
    }

    function getProjectId() {
      return _pid;
    }
  }

  //! Handles Managing the Ui State for restarting a recent timer
  class RecentTimerManager {
    const ITEM_LIST_MAX_SIZE = 10;

    private var _uiFactory;
    private var _apiService;

    private var _cancelled;
    private var _requestInProgress;

    private var _items;

    public function getDependencies() {
      return [:UiFactory, :TogglApiService];
    }

    public function initialize(deps) {
      _uiFactory = deps[:UiFactory];
      _apiService = deps[:TogglApiService];
      _items = new List();

      _requestInProgress = false;
      _cancelled = false;
    }

    //! Start the process to show recent timers
    public function show() {
      // Push a progress view initially
      _cancelled = false;

      var delegate = _uiFactory.get(:ProgressDelegate);
      delegate.setCancellable(self);

      WatchUi.pushView(new WatchUi.ProgressBar("Updating...", null),
          delegate,
          WatchUi.SLIDE_IMMEDIATE);

      if(_requestInProgress == false) {
        // Send request to Api to get recent timers
        _apiService.getRecentTimers(method(:onRequestComplete));
        _requestInProgress = true;
      }
    }

    public function cancel() {
      System.println("Cancel");
      _cancelled = true;
    }

    public function getRecentTimers() {
      return _items;
    }

    public function startTimer(item) {
      System.println(item.getDescription() + " selected");
    }

    function onRequestComplete(responseCode, data) {
      _requestInProgress = false;

      if(_cancelled) {
        // We got the response but the user already backed out, so we will drop
        // it on the floor.
        return;
      }

      // Pop the progress spinner.
      WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);

      if( responseCode == 200 ) {
        _items.clear();
        for(var i = 0; i < data.size(); i++) {
          var item = new TimerData(data[i]);
          if(!_items.contains(item)) {
            _items.pushBack(item);
          }

          if(_items.size() >= ITEM_LIST_MAX_SIZE) {
            // A list of more than 10 recent timers might not be that helpful
            break;
          }
        }

        WatchUi.pushView( _uiFactory.get(:RecentTimerView),
            _uiFactory.get(:RecentTimerDelegate),
            WatchUi.SLIDE_IMMEDIATE);
      }
      else {
        System.println( "Request Failed: " + responseCode );
      }
    }
  }
}
}

