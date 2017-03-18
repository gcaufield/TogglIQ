using Toybox.Timer as Tmr;

//! Manages broadcasting tick events to various sources
class TickManager {
    hidden class TickCounter {
        var ticks;
        var duration;
    }

    hidden var _timer;
    hidden var _activeTimers;
    hidden var _tickLength;

    function initialize(tickLength) {
        _timer = new Tmr.Timer();
        _activeTimers = {};
        _tickLength = tickLength;

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

        _activeTimers.put( listener, tickCounter );
    }

    function onTick() {
        var keys = _activeTimers.keys();
        for( var i = 0; i < keys.size(); i++) {
            var key = keys[i];
            var tickCounter = _activeTimers.get(keys[i]);

            if( tickCounter.ticks == 0 ) {
                continue;
            }

            tickCounter.ticks -= 1;
            if( tickCounter.ticks == 0 ) {
                key.invoke();

                tickCounter.ticks = tickCounter.duration;
            }
        }
    }
}