
class Module {

  private var interfaces;

  function initialize() {
    interfaces = {};
  }

  function canBuild(interface) {
    return interfaces[interface] != null;
  }

  function getDependencies(interface) {
    return interfaces[interface][:dependencies];
  }

  function build(interface, dependencies) {
    interfaces[interface][:buildFunc](dependencies);
  }

  function bind(interface, dependencies, buildFunc) {
    interfaces[interface] = {:dependencies => dependencies, :buildFunc => buildFunc};
  }
}
