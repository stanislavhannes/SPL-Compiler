/*
 * ParamTypeList -- a list of parameter type representations
 */

package types;

import java.util.*;

public class ParamTypeList extends ArrayList<ParamType> {

	/**
	 * ParamTypeList is a list of ParamType Elements
	 */
	private static final long serialVersionUID = 1L;

	public void add(Type type, boolean isRef) {
		this.add(new ParamType(type, isRef));
	}

	public void show() {
		boolean printSeparator = false;

		System.out.print("(");

		for (ParamType p : this) {
			if (printSeparator)
				System.out.print(", ");
			else
				printSeparator = true;
			p.show();
		}

		System.out.print(")");
	}
}
