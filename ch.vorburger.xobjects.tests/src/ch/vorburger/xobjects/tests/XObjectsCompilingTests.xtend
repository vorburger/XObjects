/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects.tests

import ch.vorburger.xobjects.XObjectsInjectorProvider
import ch.vorburger.xobjects.generator.XObjectsJavaGenerator
import ch.vorburger.xobjects.xObjects.XObject
import com.google.common.base.Supplier
import com.google.inject.Provider
import java.lang.reflect.Method
import javax.inject.Inject
import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.OnTheFlyJavaCompiler$EclipseRuntimeDependentJavaCompiler
import org.eclipse.xtext.xbase.junit.evaluation.AbstractXbaseEvaluationTest
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import static org.junit.Assert.*

/**
 * Tests for XObjects.
 * 
 * These tests have to run as Plug-In Tests (PDE), because of the compiler.
 * 
 * @author Michael Vorburger
 */
@InjectWith(typeof(XObjectsInjectorProvider))
@RunWith(typeof(XtextRunner))
class XObjectsCompilingTests {
	@Inject extension XTextTestsHelper<XObject> helper
	@Inject XObjectsJavaGenerator javaGenerator
	@Inject EclipseRuntimeDependentJavaCompiler javaCompiler
	
	@Before def void initializeClassPath() throws Exception {
		javaCompiler.clearClassPath();
		javaCompiler.addClassPathOfClass(getClass()); // this bundle
		javaCompiler.addClassPathOfClass(typeof(AbstractXbaseEvaluationTest)); // xbase.junit
		// javaCompiler.addClassPathOfClass(typeof(Functions)); // xbase.lib
		javaCompiler.addClassPathOfClass(typeof(Provider));  // google guice
		javaCompiler.addClassPathOfClass(typeof(Supplier));  // google collect
	}
	
 	
	@Test def void testJavaCodeGenTrivialObject() {
		val xobject = parseAndValidate("java:java.lang.Object TheVeryFirstXObjectEver { }")
		val InMemoryFileSystemAccess fsa = new InMemoryFileSystemAccess
		javaGenerator.doGenerate(xobject.eResource, fsa)
		val String javaClass = fsa.files.values.head.toString
		System::out.println(javaClass)
		// TODO assertTrue(javaClass, javaClass.contains("new java.lang.Object()"))
		
		val class1 = javaCompiler.compileToClass("TheVeryFirstXObjectEver", javaClass);
		val Object foo = class1.newInstance();
		val Method method = class1.getDeclaredMethod("create");
		val Object obj = method.invoke(foo);
		assertNotNull(obj)
	}
}