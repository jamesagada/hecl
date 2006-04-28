/* Copyright 2004-2006 David N. Welton

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

package org.hecl;

/**
 * The <code>Compare</code> class exists to compare things in different ways.
 * 
 * @author <a href="mailto:davidw@dedasys.com">David N. Welton </a>
 * @version 1.0
 */
public class Compare {

    public static final int NUMCOMPARE = 1;
    public static final int STRINGCOMPARE = 2;
    public static final int PROCCOMPARE = 3;

    /**
     * <code>compareString</code> compares two Things as strings. This can't
     * fail, because all Things may be represented as strings.
     * 
     * @param a
     *            a <code>Thing</code> value
     * @param b
     *            a <code>Thing</code> value
     * @return an <code>int</code> value
     * @throws HeclException
     */
    public static int compareString(Thing a, Thing b) {
        return a.toString().compareTo(b.toString());
    }

    /**
     * The <code>compareProc</code> method takes two things to
     * compare, an interpreter, andthe name of a proc to compare the
     * two things with.  It puts together a codething, runs it, and
     * returns the result: 0 if the two things are equal, -1 if A is
     * "less than" B, and 1 if 1 if A is "greater than" B.
     *
     * @param a a <code>Thing</code> value
     * @param b a <code>Thing</code> value
     * @param interp an <code>Interp</code> value
     * @param sortproc a <code>Thing</code> value
     * @return an <code>int</code> value
     * @exception HeclException if an error occurs
     */
    public static int compareProc(Thing a, Thing b, Interp interp, Thing sortproc)
	throws HeclException {
	CodeThing ct = new CodeThing();
	/* FIXME - addstanza lineno*/
	ct.addStanza(interp, new Thing[] {sortproc, a, b}, -1);
	ct.run(interp);
	return IntThing.get(interp.result);
    }
}
