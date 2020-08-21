
class Kernel {

  private var modules;

  function initialize() {
    modules = new List();
  }

  function load(mod) {
    modules.pushBack(mod);
  }

  function build(interface) {
    for( var mod = modules.getIterator(); mod != null; mod = mod.next()) {
      if(mod.canBuild(interface)) {
        var dependencies = mod.getDependencies(interface);

        var configuredDependencies = {};

        for(var dep = 0; dep < dependencies.length; dep++) {
          configuredDependencies[dependencies[i]] = self.build(dependencies[i]);
        }

        mod.build(interface, configuredDependencies);
      }
    }
  }
}
