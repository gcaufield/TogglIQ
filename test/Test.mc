//! Test.mc
//!
//! Copyright Greg Caufield 2020
module MonkeyTest {

(:Tests)
module Tests {
//! Base class of the Test Suite
class Test {
  //! Child classes are expected to override this and return the suite name
  public function name() {
    return "Unknown";
  }

  //! Child classes are expected to override this and return a dictionary
  //! mapping test symbols to thier names
  public function testList() {
    return {};
  }

  function setUp() {
  }

  function tearDown() {
  }

  function expectEq(expected, actual) {
    if( actual != expected ) {
      throw new TestException("Expected equality. " + actual + " != " + expected);
    }
  }
}
}
}

