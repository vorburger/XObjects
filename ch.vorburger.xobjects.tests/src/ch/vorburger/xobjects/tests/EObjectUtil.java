/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects.tests;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;

/**
 * Helper for EObjects.
 * 
 * @author Michael Vorburger
 */
public class EObjectUtil {
	
	// HOW TO how about proposing to put (something like this) helper into core EMF? 
	
	public static Integer getAsInt(EObject eObject, String featureName) {
		return getAs(eObject, featureName, Integer.class);
	}

	public static <T> T getAs(EObject eObject, String featureName, Class<T> clazz) {
		final Object obj = get(eObject, featureName);
		if (obj == null) {
			return null;
		}
		else if (clazz.isAssignableFrom(obj.getClass())) {
			@SuppressWarnings("unchecked")
			T castedObj = (T)obj;
			return castedObj;
		} else {
			throw new IllegalArgumentException(featureName + " is not a " 
					+ clazz.toString() + " but a " + obj.getClass()
					+ " for eObject: " + eObject); // TODO nicer toString() how-to?
		}
	}

	public static Object get(EObject eObject, String featureName) {
		if (eObject == null)
			return null;
		EStructuralFeature feature = eObject.eClass().getEStructuralFeature(featureName);
		return eObject.eGet(feature);
	}

}
