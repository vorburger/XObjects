/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects.tests

import ch.vorburger.xobjects.XObjectsReader
import org.eclipse.emf.ecore.EObject
import org.junit.Test
import org.eclipse.xtext.junit4.InjectWith
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import ch.vorburger.xobjects.XObjectsInjectorProvider
import javax.inject.Inject

import static org.hamcrest.CoreMatchers.*
import static org.junit.Assert.*

import static extension ch.vorburger.xobjects.tests.EObjectUtil.*;

/**
 * Tests for "non schema" Xobjects, straight from mObject Spec.
 * 
 * @author Michael Vorburger
 */
@InjectWith(typeof(XObjectsInjectorProvider))
@RunWith(typeof(XtextRunner))
class NoSchemaXObjectReaderTest {
	
	@Inject XObjectsReader reader;
	
 	@Test
	def test1() {
		val EObject b = reader.fromString(" { 'a': '1' }");
 		assertThat(b.getAsInt("a"), is(1))
	}

 	@Test
	def test2() {
		val EObject b = reader.fromString("a: 1");
 		assertThat(b.getAsInt("a"), is(1))
	}
 
}
