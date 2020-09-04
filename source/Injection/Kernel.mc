
(:background)
class Kernel {

  private var bindings_;

  function initialize() {
    bindings_ = {};
  }

  function load(mod) {
    mod.getBindings(self, bindings_);
  }

  function build(interface) {
    if(bindings_[interface] != null) {
      return bindings_[interface].build();
    }

    // Really should throw an exception here.
    return null;
  }
}
