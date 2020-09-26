//! Expectation.mc
//!
//! Copyright Greg Caufield 2020

module MonkeyTest {

(:Mocks)
module Mocks {
//! Represents an expectation that has been set on a mock
class Expectation {
  private var _expectedArgs = null;
  private var _timesExpected = 1;
  private var _timesCalled = 0;

  function initialize() {
  }

  function withArgs(args) {
    _expectedArgs = [];
    _expectedArgs.addAll(args);
    return self;
  }

  function isSaturated() {
    if(_timesExpected == null) {
      // If times expected is null then we don't care how many times this is
      // called.
      return false;
    }

    if((_timesCalled < _timesExpected)) {
      return false;
    }

    return true;
  }

  function times(num) {
    _timesExpected = num;
  }

  function isMatch(args) {
    if(_expectedArgs == null) {
      // No args specified, all calls match.
      return true;
    }

    if(args.size() != _expectedArgs.size()) {
      return false;
    }

    for(var i = 0; i < args.size(); i++) {
      var expectedArg = _expectedArgs[i];

      if(expectedArg == :any) {
        continue;
      }
      else if((expectedArg instanceof Matcher) && !expectedArg.isMatch(args[i])) {
        // Matcher check failed
        return false;
      }
      else if( expectedArg != args[i]) {
        return false;
      }
    }

    return false;
  }

  function execute(args) {
    if(isSaturated()) {
      // TODO (caufield) create an exception for this
      // Error Expectation Over Saturated
      throw new ExpectationException();
    }

    _timesCalled++;
  }

  function verify() {
    if((_timesExpected != null) && (_timesExpected != _timesCalled)) {
      throw new ExpectationException();
    }
  }
}
}
}
