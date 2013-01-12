/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects.scoping;

import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.xbase.scoping.XbaseQualifiedNameProvider;

import ch.vorburger.xobjects.xObjects.JavaXObject;

/**
 * @author Michael Vorburger
 */
@SuppressWarnings("restriction")
public class XObjectsNameProvider extends XbaseQualifiedNameProvider {

// TODO remove? MIGHT be eventually be needed, because name is optional we'll see NPEs? or are there null safe checks everywere, and this thus won't be in index etc?
// probably best to implement it based on HashCode like Object.toString?

	/*
	StringBuilder result = new StringBuilder("Anonymous XObject java:");
	result.append(javaXObject.getType().getQualifiedName());
    result.append(' @');
    result.append(Integer.toHexString(hashCode()));

	 */
	
//	// TODO probably have to adapt to do same for EcoreXObject 
//	protected QualifiedName qualifiedName(JavaXObject javaXObject) {
//		QualifiedName fqn = QualifiedName.create();
//		// TODO package name..
//		if (javaXObject.getName() != null) {
//			return null;
//		} else {
//			
//		}
//		return fqn;
//	}
}
