/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects;

import java.util.List;

import javax.inject.Inject;

import org.eclipse.emf.common.util.WrappedException;
import org.eclipse.xtext.validation.Issue;
import org.eclipse.xtext.xbase.interpreter.IEvaluationResult;

import ch.vorburger.xobjects.interpreter.XObjectsInterpreter;
import ch.vorburger.xobjects.interpreter.XObjectsInterpreterException;
import ch.vorburger.xobjects.xObjects.File;
import ch.vorburger.xobjects.xObjects.XObject;

/**
 * Reads *.xobjects files (or String/Stream), and constructs new objects.
 * 
 * Implementation is based on org.eclipse.xtext.junit4.util.ParseHelper<T>.
 * 
 * @author Michael Vorburger
 */
public class XObjectsReader {

	protected @Inject ParseHelper<File> parser;
	protected @Inject ValidationHelper validator;
	protected @Inject XObjectsInterpreter interpreter;
	
	@SuppressWarnings("unchecked")
	public <T> T fromString(String xObjectText) throws XObjectsInterpreterException {
		File xObjectFile = parser.parse(xObjectText);
		try {
			List<Issue> issues = validator.getValidationIssues(xObjectFile);
			if (!issues.isEmpty()) {
				// copy/paste even ch.vorburger.el.engine.ExpressionParsingException ?  Open Bugzilla to have outside of test..
				throw new IllegalArgumentException("Invalid XObjects syntax: " + xObjectText + ", " + issues);
			}
			
			XObject xObject = xObjectFile.getRoot();
			IEvaluationResult result = interpreter.evaluate(xObject);
			if (result.getException() != null) {
				throw new XObjectsInterpreterException("Failed to evaluated", result.getException());
			} else {
				return (T) result.getResult();
			}
		} finally {
			// This is super important to avoid a memory leak..
			if (xObjectFile != null && xObjectFile.eResource() != null) 
				xObjectFile.eResource().unload();
		}		
	}
	
	public <T> T fromClasspath(String resourcePath) { 
		throw new UnsupportedOperationException();
		// return null;
	}
}
