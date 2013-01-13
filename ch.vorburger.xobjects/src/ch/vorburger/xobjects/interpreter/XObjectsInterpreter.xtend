/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.vorburger.xobjects.interpreter

import ch.vorburger.xobjects.xObjects.JavaXObject
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.xbase.interpreter.IEvaluationContext
import org.eclipse.xtext.xbase.interpreter.impl.XbaseInterpreter

class XObjectsInterpreter extends XbaseInterpreter {

	def protected dispatch Object doEvaluate(JavaXObject xobject, IEvaluationContext context, CancelIndicator indicator) {
		// val IEvaluationContext evaluationContext = contextProvider.get();
		// evaluationContext.newValue(XbaseScopeProvider.THIS, thisElement);
		val Object o = if (xobject.from != null) doEvaluate(xobject.from, context, indicator) else invokeConstructor(xobject.type)
		// TODO iterate to set Properties..
		return o  
	}
	
	// TODO def dispatch Object doEvaluate(EcoreXObject xobject/*, IEvaluationContext context, CancelIndicator indicator */) {
	
	def protected Object invokeConstructor(JvmTypeReference type) {
		val String className = type.getQualifiedName()
		try {
			val javaClass = getClassFinder().forName(className)
			return javaClass.newInstance
		} catch (ClassNotFoundException cnfe) {
			throw new XObjectsInterpreterException("Problem occurred while evaluating XExpression", new NoClassDefFoundError(className))
		}
	}
}
