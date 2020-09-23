// Notification.mc
//
// Model representing a currently active warning
// Copyright Greg Caufield 2020

module Toggl {
module Models {
  enum {
    TIMER_NTFCTN_REQUEST_FAILED
  }

  //! Model class for representing an active notification
  class Notification {
    //! Static Interface Dependency Retriever
    //!
    //! @returns Array of required interfaces
    function getDependencies() {
      return [:TickManager];
    }

    private var _ntfctn;
    private var _ntfctnTimer = 0;

    function initialize(deps) {
      deps[:TickManager].addListener( method( :onTick ), 1000 );
    }

    function onTick() {
      if( _ntfctnTimer == 0 ) {
        return;
      }

      _ntfctnTimer -= 1;
      if( _ntfctnTimer == 0 ) {
        _ntfctn = null;
      }
    }

    //! Sets a notification
    function setNotification( ntfctn ) {
      _ntfctn = ntfctn;
      _ntfctnTimer = 5;
    }

    function getNotification() {
        return _ntfctn;
    }
  }
}
}

