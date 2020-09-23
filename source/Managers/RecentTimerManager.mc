//! RecentTimerManager.mc
//!
//! Copyright Greg Caufield 2020
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Communications;

module Toggl {
module Managers {

  class TimerData {
    protected var _description;
    protected var _pid;

    function initialize(data) {
      _description = data["description"];
      _pid = data["pid"];
    }

    function equals(other) {
      return (_description.equals(other._description));
    }

    function getDescription() {
      return _description;
    }

    function getShortDescription() {
      if(_description.length() < 20) {
        return _description;
      }
      else {
        return _description.substring(0,19) + "...";
      }
    }

    function getProjectId() {
      return _pid;
    }
  }

  //! Handles Managing the Ui State for restarting a recent timer
  class RecentTimerManager {
    const ITEM_LIST_MAX_SIZE = 10;

    // Look back 2 weeks
    const MAX_LOOKBACK = new Time.Duration(14 * 24 * 3600);

    private var _uiFactory;
    private var _apiService;

    private var _cancelled;
    private var _requestInProgress;
    private var _lastEnd;
    private var _requestWindow;
    private var _tickManager;

    private var _items;

    public function getDependencies() {
      return [:UiFactory, :TogglApiService, :TickManager];
    }

    public function initialize(deps) {
      _uiFactory = deps[:UiFactory];
      _apiService = deps[:TogglApiService];
      _tickManager = deps[:TickManager];
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
        _items.clear();

        // Start with a 48 hour request window
        _requestWindow = 48 * 3600;
        _lastEnd = Time.now();

        // Send request to Api to get timers from the request window.
        startRequest();
      }
    }

    public function cancel() {
      _cancelled = true;
    }

    public function getRecentTimers() {
      return _items;
    }

    function onRequestComplete(responseCode, data) {
      _requestInProgress = false;

      if(_cancelled) {
        // We got the response but the user already backed out, so we will drop
        // it on the floor.
        return;
      }

      switch(responseCode) {
        case 200:

          // Iterate the list in reverse order so the most recent timer is
          // listed first.
          for(var i = data.size() - 1; i > 0; i--) {
            var item = new TimerData(data[i]);
            if(item.getDescription() == null) {
              continue;
            }

            if(!_items.contains(item)) {
              _items.pushBack(item);
            }

            if(_items.size() >= ITEM_LIST_MAX_SIZE) {
              // A list of more than 10 recent timers might not be that helpful
              break;
            }
          }

          if(_items.size() < ITEM_LIST_MAX_SIZE && Time.now().subtract(_lastEnd).lessThan(MAX_LOOKBACK) ) {
            // Move the last end back and start a new request, attempt a linear
            // expansion to reduce the number of timers
            _lastEnd = _lastEnd.subtract(new Time.Duration(_requestWindow));
            _requestWindow += (48 * 3600);
            startRequest();
          } else {
            // We have enough elements
            // Pop the progress spinner, and show the list.
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);

            if(_items.size() > 0) {
              WatchUi.pushView( _uiFactory.get(:RecentTimerView),
                  _uiFactory.get(:RecentTimerDelegate),
                  WatchUi.SLIDE_IMMEDIATE);
            }
          }
          break;

        case Communications.INVALID_HTTP_BODY_IN_NETWORK_RESPONSE:
        case 429:
          // Rate Limited, try again...
          _tickManager.delay(method(:startRequest), 500);
          break;

        case Communications.NETWORK_RESPONSE_OUT_OF_MEMORY:
        case Communications.NETWORK_RESPONSE_TOO_LARGE:
          // Looks like the request window we tried to use has too many things
          // in it... Perform an exponential back off and try again.
          _requestWindow = _requestWindow / 2;
          startRequest();
          break;

        default:
          WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
          break;
      }
    }

    function startRequest() {
      _requestInProgress = true;
      _apiService.getTimers(
          _lastEnd.subtract(new Time.Duration(_requestWindow)),
          _lastEnd,
          method(:onRequestComplete));
    }
  }
}
}

