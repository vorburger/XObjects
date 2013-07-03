/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects;

import java.io.IOException;
import java.io.InputStream;

import javax.inject.Inject;
import javax.inject.Named;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.common.util.WrappedException;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.Constants;
import org.eclipse.xtext.resource.IResourceFactory;
import org.eclipse.xtext.resource.XtextResourceSet;
import org.eclipse.xtext.util.StringInputStream;

import com.google.inject.Provider;

/**
 * Helper (package local) to reads *.xobjects syntax from files/String/Stream.
 * 
 * Implementation is based on org.eclipse.xtext.junit4.util.ParseHelper<T>.
 *
 * @author Michael Vorburger
 */
class ParseHelper<T extends EObject> {
	
	// TODO Should we do any Validation here, using org.eclipse.xtext.junit4.validation.ValidationTestHelper, similarly to ch.vorburger.el.engine.ExpressionFactory ?
	
	private @Inject Provider<XtextResourceSet> resourceSetProvider;
	
	private @Inject IResourceFactory resourceFactory;

	private @Inject @Named(Constants.FILE_EXTENSIONS) String fileExtension;
	
	protected T parse(InputStream in, URI uriToUse, ResourceSet resourceSet) {
		Resource resource = resourceFactory.createResource(uriToUse);
		resourceSet.getResources().add(resource);
		try {
			resource.load(in, null);
			@SuppressWarnings("unchecked")
			final T root = (T) (resource.getContents().isEmpty() ? null : resource.getContents().get(0));
			return root;
		} catch (IOException e) {
			throw new WrappedException(e);
		}
	}
	
	protected T parse(CharSequence text) {
		return parse(text, resourceSetProvider.get());
	}

	protected T parse(CharSequence text, ResourceSet resourceSetToUse) {
		return parse(getAsStream(text), computeUnusedUri(resourceSetToUse), resourceSetToUse);
	}

	protected T parse(CharSequence text, URI uriToUse, ResourceSet resourceSetToUse) {
		return parse(getAsStream(text), uriToUse, resourceSetToUse);
	}

	protected URI computeUnusedUri(ResourceSet resourceSet) {
		String name = "__synthetic";
		for (int i = 0; i < Integer.MAX_VALUE; i++) {
			URI syntheticUri = URI.createURI(name + i + "." + getFileExtension());
			if (resourceSet.getResource(syntheticUri, false) == null)
				return syntheticUri;
		}
		throw new IllegalStateException();
	}

	protected String getFileExtension() {
		return fileExtension;
	}

	protected InputStream getAsStream(CharSequence text) {
		return new StringInputStream(text == null ? "" : text.toString());
	}

}
