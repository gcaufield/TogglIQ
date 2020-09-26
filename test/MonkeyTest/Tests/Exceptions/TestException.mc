//! TestException.mc
//!
//! Copyright Greg Caufield 2020
using Toybox.Lang;

module MonkeyTest {
(:Tests)
module Tests {
//! Base Exception for Failures from the test framework
class TestException extends Lang.Exception {
  function initialize(msg) {
    Exception.initialize();
    self.mMessage = msg;
  }
}
}
}
