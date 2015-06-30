package absyn;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class ListNodeIterator implements Iterator<Absyn> {
	private ListNode listNode;

	public ListNodeIterator(ListNode l) {
		listNode = l;
	}

	@Override
	public boolean hasNext() {
		return !listNode.isEmpty();
	}

	@Override
	public Absyn next() throws NoSuchElementException {
		if (listNode.isEmpty)
			throw new NoSuchElementException();
		else {
			Absyn head = listNode.head();
			listNode = listNode.tail();
			return head;
		}
	}

	@Override
	public void remove() {
		throw new UnsupportedOperationException();
	}
}
