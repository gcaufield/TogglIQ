
(:background)
class List {
  class Iterator {
    private var current;

    function initialize(start) {
      current = start;
    }

    function get() {
      return current.val;
    }

    function next() {
      if( current.next != null ) {
        current = current.next;
        return self;
      }
      else {
        return null;
      }
    }
  }

  class Element {
    var next;
    var val;

    function initialize(){
    }
  }

  private var first;
  private var last;
  private var length;

  function initialize() {
    clear();
  }

  function clear() {
    first = null;
    last = null;
    length = 0;
  }

  function contains(element) {
    for(var it = getIterator(); it != null; it = it.next()) {
      if(it.get().equals(element)) {
        return true;
      }
    }

    return false;
  }

  function pushBack(val) {
    var element = new Element();

    element.val = val;
    element.next = null;

    if(first == null) {
      first = element;
      last = element;
    } else {
      last.next = element;
      last = element;
    }

    length++;
  }

  function size() {
    return length;
  }

  function getIterator() {
    if(first == null) {
      return null;
    }
    return new Iterator(first);
  }
}
