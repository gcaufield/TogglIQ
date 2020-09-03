// Module.mc
//
// Copyright 2020 Greg Caufield

using Toybox.Lang;

(:background)
class Module {
  private var interfaces;

  function initialize() {
    interfaces = {};
  }

  function bind(interface) {
    interfaces[interface] = new BindingSpec(interface);
    return interfaces[interface];
  }

  function getBindings(resolutionRoot, bindings) {
    var keys = interfaces.keys();

    // Copy all of our bindings into the new dictionary
    for(var i = 0; i < keys.size(); i++) {
      var spec = interfaces[keys[i]];

      if(spec.getScope() == BindingScopeTransient) {
        bindings[keys[i]] = new Binding(resolutionRoot, spec);
      } else if(spec.getScope() == BindingScopeSingleton) {
        bindings[keys[i]] = new SingletonBinding(resolutionRoot, spec);
      }
    }
  }
}
