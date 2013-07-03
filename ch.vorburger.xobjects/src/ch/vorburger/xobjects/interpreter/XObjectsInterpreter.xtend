/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.vorburger.xobjects.interpreter

import ch.vorburger.xobjects.xObjects.BooleanValue
import ch.vorburger.xobjects.xObjects.JavaXObject
import ch.vorburger.xobjects.xObjects.NoSchemaFeature
import ch.vorburger.xobjects.xObjects.NoSchemaXObject
import ch.vorburger.xobjects.xObjects.StringValue
import ch.vorburger.xobjects.xObjects.XObject
import java.util.HashMap
import java.util.Map
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.xbase.interpreter.IEvaluationContext
import org.eclipse.xtext.xbase.interpreter.IEvaluationResult
import org.eclipse.xtext.xbase.interpreter.impl.DefaultEvaluationResult
import org.eclipse.xtext.xbase.interpreter.impl.EvaluationException
import org.eclipse.xtext.xbase.interpreter.impl.XbaseInterpreter

/**
 * "Interpreter" for XObjects.
 * 
 * @author Michael Vorburger
 */
class XObjectsInterpreter extends XbaseInterpreter {

	def IEvaluationResult evaluate(XObject xobject) {
		try {
			val Object result = doEvaluate(xobject, createContext(), CancelIndicator::NullImpl)
			return new DefaultEvaluationResult(result, null);
//		} catch (ReturnValue e) {
//			return new DefaultEvaluationResult(e.returnValue, null);
		} catch (EvaluationException e) {
			return new DefaultEvaluationResult(null, e.getCause());
		}
	}

	def protected dispatch Object doEvaluate(NoSchemaXObject xobject, IEvaluationContext context, CancelIndicator indicator) {
		val Map object = new HashMap(xobject.features.size);
		for (NoSchemaFeature feature: xobject.features) {
			object.put(feature.feature, newValue(feature.value));
		}
		return object; 
	}

	def protected dispatch newValue(StringValue feature) { feature.value }

	def protected dispatch newValue(BooleanValue feature) { Boolean::valueOf(feature.value) }

	
	def protected dispatch Object doEvaluate(JavaXObject xobject, IEvaluationContext context, CancelIndicator indicator) {
		// val IEvaluationContext evaluationContext = contextProvider.get();
		// evaluationContext.newValue(XbaseScopeProvider.THIS, thisElement);
		val Object o = /* if (xobject.from != null) doEvaluate(xobject.from, context, indicator) else */ invokeConstructor(xobject.type)
		// TODO iterate to set Properties..
		return o  
	}
	
	// TODO def dispatch Object doEvaluate(EcoreXObject xobject/*, IEvaluationContext context, CancelIndicator indicator */) {
	
	def protected Object invokeConstructor(JvmType/*Reference*/ type) {
		val String className = type.getQualifiedName()
		try {
			val javaClass = getClassFinder().forName(className)
			return javaClass.newInstance
		} catch (ClassNotFoundException cnfe) {
			throw new XObjectsInterpreterException("Problem occurred while evaluating XExpression", new NoClassDefFoundError(className))
		}
	}
}
