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
import ch.vorburger.xobjects.xObjects.XObject
import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.hamcrest.CoreMatchers.*
import static org.junit.Assert.*

/**
 * Tests for XObjects.
 * 
 *  These tests run just fine as plain simple SE; no need to run them as Plug-In Tests (PDE).
 *
 * @author Michael Vorburger
 */
@InjectWith(typeof(XObjectsInjectorProvider))
@RunWith(typeof(XtextRunner))
class XObjectsTests {
	@Inject extension XTextTestsHelper<XObject> helper
	
	@Test def void testParsingTrivialObject() {
		val xobject = parseAndValidate("java:java.lang.Object TheVeryFirstXObjectEver { }")
		assertThat((xobject as JavaXObject).name, is("TheVeryFirstXObjectEver"))
		assertThat((xobject as JavaXObject).type.qualifiedName, is("java.lang.Object"))
	}
	
	@Test def void testInterpretTrivialObject() {
		fail("TODO")
	}
	
	@Test def void testInterpretWithConstructor() {
		fail("TODO")
	}
}