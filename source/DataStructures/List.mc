
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
    var prev;
    var val;

    function initialize(){
    }
  }

  private var first;
  private var last;
  private var length;

  function initialize() {
    first = null;
    last = null;
    length = 0;
  }

  function pushBack( val ) {
    var element = new Element();

    element.val = val;
    element.next = null;
    element.prev = last;

    if(first == null) {
      first = element;
      last = element;
    } else {
      last.next = element;
      last = element;
    }

    length++;
  }

  function getIterator() {
    if(first == null) {
      return null;
    }
    return new Iterator(first);
  }
}
