//! Matcher.mc
//!
//! Copyright Greg Caufield 2020

module MonkeyTest {
(:Mocks)
module Mocks {
class Matcher {
  function isMatch(other) {
    return false;
  }
}
}
}
