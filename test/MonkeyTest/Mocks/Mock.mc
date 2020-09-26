//! Mock.mc
//!
//! Copyright Greg Caufield 2020
using Toybox.System;

module MonkeyTest {

(:Mocks)
module Mocks {
enum {
  MOCK_TYPE_NICE,
  MOCK_TYPE_NAGGY,
  MOCK_TYPE_STRICT
}

//! Base class for Mock Classes
class Mock {
  private var _expectations = {};
  private var _type;

  public function initialize(mockType) {
    _type = mockType;
  }

  public function expect(key) {
    var expectation = new Expectation();

    if(!_expectations.hasKey(key)) {
      _expectations[key] = [];
    }

    _expectations[key].add(expectation);
    return expectation;
  }

  public function verifyAndClear() {
    var keys = _expectations.keys();

    for(var i = 0; i < keys.size(); i++) {
      var expectations = _expectations[keys[i]];
      for(var j = 0; j < expectations.size(); j++) {
        expectations[j].verify();
      }
    }
  }

  protected function getFunctionName(key) {
    return "Unknown";
  }

  //! Execute any expectations for the mock
  protected function execute(key, arguments) {
    var list = _expectations[key];

    if(list == null) {
      switch(_type) {
        case MOCK_TYPE_NAGGY:
          System.println(
              "Unexpected call to Mock function " + getFunctionName(key));
          return;
        case MOCK_TYPE_NICE:
          return;
        default:
        case MOCK_TYPE_STRICT:
          throw new UnexpectedInvocationException(getFunctionName(key));
      }
    }

    var candidate = null;
    var match = false;

    for(var i = 0; i < list.size(); i++) {
      var expectation = list[i];
      if(expectation.isMatch(arguments)) {
        match = true;
        if(expectation.isSaturated()) {
          candidate = expectation;
          continue;
        }

        // Unsaturated expectation that matches the arguments,
        // call it and clear any potential saturated candidates.
        expectation.execute(arguments);
        candidate = null;
        break;
      }
    }

    if(!match) {
      // TODO (caufield) Create an Exception for this
      // No Valid Expectation for Arguments
      throw new UnexpectedInvocationException(getFunctionName(key));
    }

    // A saturated candidate was found, we will call it so that an error will
    // occur
    if(candidate != null) {
      candidate.execute(arguments);
    }
  }
}
}
}
