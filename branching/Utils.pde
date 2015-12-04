interface Function {
  float apply(float x);
}

abstract class Distribution {
  public Function cdf = null;
  public Function pdf = null;
  public Function invcdf = null;
}

/*
 * "Lite" utility classes and interfaces
 * Processing js does not work with java imported libraries
 * These are simple versions of data structures from java.util with only the required methods
 */

interface ComparatorLite<T> {
  int compare(T o1, T o2);
}

interface QueueLite<E> {
  boolean add(E e);
  E peek();
  E poll();
  IteratorLite<E> iterator();
  int size();
}

interface IterableLite<E> {
  IteratorLite<E> iterator();
}

interface IteratorLite<E> {
  boolean hasNext();
  E next();
}

class ArrayIteratorLite<E> implements IteratorLite<E> {
  Object[] iterable;
  int index = 0;
  int size;
  public ArrayIteratorLite(Object[] arr, int size) {
    this.iterable = arr;
    this.size = size;
  }
  
  public boolean hasNext() {
    return index < size && index < iterable.length;
  }
  
  public E next() {
    E obj = (E) iterable[index];
    index++;
    return obj;
  }
}

class PriorityQueueLite<E> implements QueueLite<E>, IterableLite<E> {
  private static final int DEFAULT_CAPACITY = 100;
  private Object[] queue;
  private int size = 0;
  private final ComparatorLite<? super E> comparator;
  
  public PriorityQueueLite(int initialCapacity, ComparatorLite<? super E> comparator) {
    this.queue = new Object[initialCapacity];
    this.comparator = comparator;
  }
  
  public PriorityQueueLite(ComparatorLite<? super E> comparator) {
    this(DEFAULT_CAPACITY, comparator);
  }
  
  private void grow(int minCapacity) {
    int oldCapacity = queue.length;
    int newCapacity = ((oldCapacity < 64)?
                       ((oldCapacity + 1) * 2):
                       ((oldCapacity / 2) * 3));
    if (newCapacity < 0) // overflow
      newCapacity = Integer.MAX_VALUE;
    if (newCapacity < minCapacity)
      newCapacity = minCapacity;
    Object[] copy = (E[]) new Object[newCapacity];
    System.arraycopy(queue, 0, copy, 0, min(queue.length, newCapacity));
    queue =(E[]) copy;
  }
  private void siftUp(int k, E x) {
    siftUpUsingComparator(k, x);
  }
  
  private void siftUpUsingComparator(int k, E x) {
    while (k > 0) {
      int parent = (k - 1) >>> 1;
      Object e = queue[parent];
      if (comparator.compare(x, (E) e) >= 0)
        break;
      queue[k] = e;
      k = parent;
    }
    queue[k] = x;
  }
  
  private void siftDown(int k, E x) {
    siftDownUsingComparator(k, x);
  }
  
  private void siftDownUsingComparator(int k, E x) {
    int half = size >>> 1;
    while (k < half) {
      int child = (k << 1) + 1;
      Object c = queue[child];
      int right = child + 1;
      if (right < size &&
        comparator.compare((E) c, (E) queue[right]) > 0)
        c = queue[child = right];
      if (comparator.compare(x, (E) c) <= 0)
        break;
      queue[k] = c;
      k = child;
    }
    queue[k] = x;
  }
  
  public boolean add(E e) {
    int i = size;
    if (i >= queue.length)
      grow(i + 1);
    size = i + 1;
    if (i == 0)
      queue[0] = e;
    else
      siftUp(i, e);
    return true;
  }
  
  public E peek() {
    if (size == 0)
      return null;
    return (E) queue[0];
  }
  
  public E poll() {
    if (size == 0) return null;
    int s = --size;
    E result = (E) queue[0];
    E x = (E) queue[s];
    queue[s] = null;
    if (s != 0)
      siftDown(0, x);
    return result;
  }
  
  public int size() {
    return size;
  }
  
  public IteratorLite<E> iterator() {
    return new ArrayIteratorLite<E>(queue, size);
  }
  
}

/*
 * Doubly Linked List with Sentinel
 */
class LinkedListLite<E> implements QueueLite<E>, IterableLite<E> {
  
  private Entry<E> header = new Entry<E>(null, null, null);
  private int size = 0;

  public LinkedListLite() {
    header.next = header.previous = header;
  }

  public boolean add(E e) {
    Entry<E> newEntry = new Entry<E>(e, header, header.previous);
    newEntry.previous.next = newEntry;
    newEntry.next.previous = newEntry;
    size++;
    return true;
  }
  
  public E peek() {
    return header.next.element;
  }

  public E poll() {
    if (size == 0) return null;
    return remove(header.next);
  }
  
  private E remove(Entry<E> e) {
    E result = e.element;
    e.previous.next = e.next;
    e.next.previous = e.previous;
    e.next = e.previous = null;
    e.element = null;
    size--;
    return result;
  }

  public int size() {
    return size;
  }
  
  public IteratorLite<E> iterator() {
    return new LinkedListIteratorLite<E>(header);
  }
  
  class LinkedListIteratorLite<E> implements IteratorLite<E> {
    Entry<E> ptr;
    int index = 0;
    public LinkedListIteratorLite(Entry<E> ptr) {
      this.ptr = ptr;
    }
  
    public boolean hasNext() {
      return index < size;
    }
  
    public E next() {
      E obj = ptr.next.element;
      index++;
      ptr = ptr.next;
      return obj;
    }
  }
  
  private class Entry<E> {
    E element;
    Entry<E> next;
    Entry<E> previous;
    
    Entry(E element, Entry<E> next, Entry<E> previous) {
      this.element = element;
      this.next = next;
      this.previous = previous;
    }
  }
}