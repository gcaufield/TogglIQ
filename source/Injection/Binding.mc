//! Binding.mc
//!
//! Copyright Greg Caufield 2020

using Toybox.System;

(:background)
class Binding {
  private var resolutionRoot_;
  private var classDef_;

  function initialize(resolutionRoot, bindingSpec_) {
    resolutionRoot_ = resolutionRoot;
    classDef_ = bindingSpec_.getClassDef();
  }

  function build() {
    var configuredDependencies = {};
    var requiredDependencies = [];

    // Convention over configuration. Classes built using this framework are
    // expected to provide a "static" function that can be called to retrieve
    // their dependencies.
    if( classDef_ has :getDependencies) {
      requiredDependencies = classDef_.getDependencies();
    }

    for(var dep = 0; dep < requiredDependencies.size(); dep++) {
      configuredDependencies[requiredDependencies[dep]] = resolutionRoot_.build(
        requiredDependencies[dep]);
    }

    if(requiredDependencies.size() == 0) {
      return new classDef_();
    }
    else {
      return new classDef_(configuredDependencies);
    }
  }
}
