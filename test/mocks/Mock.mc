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

  function initialize(mockType) {
    _type = mockType;
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
        case MOCK_TYPE_STRICT:
          throw new UnexpectedInvocationException(getFunctionName(key));
      }
    }
  }
}
}
}
