/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects;

import static com.google.common.collect.Iterables.filter;

import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.CheckMode;
import org.eclipse.xtext.validation.IResourceValidator;
import org.eclipse.xtext.validation.Issue;

import com.google.common.base.Predicate;

/**
 * Helper (package local) to for EMF Validation.
 * 
 * Implementation is based on ch.vorburger.el.engine.ExpressionFactory (and 3 lines from org.eclipse.xtext.junit4.validation.ValidationTestHelper).
 * 
 * @author Michael Vorburger
 */
class ValidationHelper {

	// copy/paste even ch.vorburger.el.engine.ExpressionParsingException ?  Open Bugzilla to have outside of test..
	
	public List<Issue> getValidationIssues(EObject model) {
		IResourceValidator validator = ((XtextResource) model.eResource()).getResourceServiceProvider().getResourceValidator();
		return validator.validate(model.eResource(), CheckMode.ALL, CancelIndicator.NullImpl);
	}
	
	public Iterable<Issue> getValidationErrors(final EObject model) {
		final List<Issue> validate = getValidationIssues(model);
		Iterable<Issue> issues = filter(validate, new Predicate<Issue>() {
			@Override
			public boolean apply(Issue input) {
				return Severity.ERROR == input.getSeverity();
			}
		});
		return issues;
	}
}
