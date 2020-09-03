// Binding.mc
//
// Copyright Greg Caufield 2020
using Toybox.Lang;

enum {
  BindingScopeTransient,
  BindingScopeSingleton
}

class BindingSpec {
  private var mod_;
  private var interface_;
  private var classDef_;
  private var scope_;

  function initialize(interface) {
    interface_ = interface;
    classDef_ = null;
    scope_ = BindingScopeTransient;
  }

  function to(classDef) {
    classDef_ = classDef;
    return self;
  }

  function inSingletonScope() {
    scope_ = BindingScopeSingleton;
    return self;
  }

  function getClassDef() {
    if(classDef_ != null) {
      return classDef_;
    }

    //TODO Throw an exception
    return null;
  }

  function getScope() {
    return scope_;
  }
}
