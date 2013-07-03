/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects.tests

import ch.vorburger.xobjects.XObjectsInjectorProvider
import ch.vorburger.xobjects.xObjects.JavaXObject
import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.hamcrest.CoreMatchers.*
import static org.junit.Assert.*
import ch.vorburger.xobjects.interpreter.XObjectsInterpreter

/**
 * Tests for XObjects.
 * 
 * These tests run just fine as plain simple SE; no need to run them as Plug-In Tests (PDE).
 *
 * @author Michael Vorburger
 */
@InjectWith(typeof(XObjectsInjectorProvider))
@RunWith(typeof(XtextRunner))
class XObjectsTests {
	@Inject extension XTextTestsHelper<JavaXObject>
	@Inject extension XObjectsInterpreter interpreter
	
	@Test def void testParsingTrivialObject() {
		val xobject = parseAndValidate("java:java.lang.String TheVeryFirstXObjectEver { }")
		assertThat((xobject as JavaXObject).name, is("TheVeryFirstXObjectEver"))
		assertThat((xobject as JavaXObject).type.qualifiedName, is("java.lang.String"))
	}
	
	@Test def void testInterpretTrivialObject() {
		val object = eval("java:java.lang.String TheVeryFirstXObjectEver { }")
		assertTrue(object instanceof String)
	}
	
	@Test def void testInterpretWithConstructor() {
		val Integer i = eval("java:java.lang.Integer TheVeryFirstXObjectWithoutImplicitConstructorCall from new Integer(123) { }") as Integer
		assertEquals(new Integer(123), i)
	}
	
	def Object eval(String text) {
		val model = parseAndValidate(text)
		val result = interpreter.evaluate(model)
		if (result.exception != null)
			// hack because throw result.exception doesn't work, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=382835:
			throw new AssertionError("evalute result has Exception", result.exception)	
		result.result
	}
}