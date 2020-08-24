
(:background)
class Kernel {

  private var modules;

  private var singletons = {};

  function initialize() {
    modules = new List();
  }

  function load(mod) {
    modules.pushBack(mod);
  }

  function build(interface) {
    if(singletons[interface] != null) {
      return singletons[interface];
    }

    for( var mod = modules.getIterator(); mod != null; mod = mod.next()) {
      // Check if this module knows how to build this interfgace
      if(mod.get().canBuild(interface)) {
        // Get the dependencies for the interface that we are building
        var dependencies = mod.get().getDependencies(interface);

        var configuredDependencies = {};

        // For each dependency that the interface has recurse to build it.
        for(var dep = 0; dep < dependencies.size(); dep++) {
          configuredDependencies[dependencies[dep]] = self.build(dependencies[dep]);
        }

        singletons[interface] = mod.get().build(interface, configuredDependencies);
        return singletons[interface];
      }
    }

    // Really should throw an exception here.
    return null;
  }
}
