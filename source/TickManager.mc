using Toybox.Timer as Tmr;

//! Manages broadcasting tick events to various sources
class TickManager {
  class TickCounter {
    var ticks;
    var duration;
    var restart;
  }

  hidden var _timer;
  hidden var _activeTimers;
  hidden var _tickLength;

  function initialize() {
    _timer = new Tmr.Timer();
    _activeTimers = {};
    _tickLength = 500;

    _timer.start( method(:onTick), _tickLength, true );
  }

  //! Add a listener
  //!
  //! @param listener - The listenerFunction for the tick event
  //! @param duration - The length of the timer in ms
  //! @param reset - Auto Restart the timer
  //! @returns - Key for the timer
  function addListener( listener, duration ) {
    var tickCounter = new TickCounter();
    tickCounter.ticks = (duration / _tickLength).toNumber();
    tickCounter.duration = tickCounter.ticks;
    tickCounter.restart = true;

    _activeTimers.put( listener, tickCounter );
  }

  function delay(listener, duration) {
    var timer = _activeTimers[listener];
    if( timer == null ) {
      timer = new TickCounter();
      timer.restart = false;

      _activeTimers.put( listener, timer );
    }

    timer.ticks = (duration / _tickLength).toNumber();
    timer.duration = timer.ticks;
  }

  function onTick() {
    var keys = _activeTimers.keys();
    var keysToRemove = new List();
    for( var i = 0; i < keys.size(); i++) {
      var key = keys[i];
      var tickCounter = _activeTimers.get(keys[i]);

      if( tickCounter.ticks == 0 ) {
        continue;
      }

      tickCounter.ticks -= 1;
      if( tickCounter.ticks == 0 ) {
        key.invoke();

        if(tickCounter.restart) {
          tickCounter.ticks = tickCounter.duration;
        }
        else {
          keysToRemove.pushBack(key);
        }
      }
    }

    // Remove any expired timers that don't have a restart set
    for(var it = keysToRemove.getIterator(); it != null; it = it.next()) {
      _activeTimers.remove(it.get());
    }
  }
}
