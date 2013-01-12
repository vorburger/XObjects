/*******************************************************************************
 * Copyright (c) 2013 Michael Vorburger (http://www.vorburger.ch).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package ch.vorburger.xobjects.generator

import ch.vorburger.xobjects.xObjects.JavaXObject
import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.compiler.ImportManager
import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer

@SuppressWarnings("restriction")
class XObjectsJavaGenerator implements IGenerator {
	
	@Inject extension IQualifiedNameProvider
  	@Inject extension TypeReferenceSerializer 
  
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		// NOT for(e: resource.allContents.toIterable.filter(typeof(JavaXObject))) {
		val rootJavaXObject = resource.allContents.toIterable.filter(typeof(JavaXObject)).head 
		// NAH, let's go like this (WAS: "Because XObjects may be anon (name not mandatory) we don't do the usual:") 
		val fileName = rootJavaXObject.fullyQualifiedName.toString("/") + ".java"
		fsa.generateFile(fileName, rootJavaXObject.generate)
	}
	
	def generate(JavaXObject it) '''
	    «val importManager = new ImportManager(true)» 
	    «val body = body(importManager)»
	    «IF eContainer != null»
	      package «eContainer.fullyQualifiedName»;
	    «ENDIF»
	    
	    «FOR i:importManager.imports»
	      import «i»;
	    «ENDFOR»
	    
    	«body»
  	''' 
  	
	def body(JavaXObject it, ImportManager importManager) '''    
    	public class «name» {
«««    	FOR f : properties»
«««        «f.compile(importManager)»
«««      «ENDFOR»
    }
  '''
}
