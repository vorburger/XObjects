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
import org.eclipse.xtext.xbase.XExpression
import org.eclipse.xtext.xbase.compiler.ImportManager
import org.eclipse.xtext.xbase.compiler.StringBuilderBasedAppendable
//import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer
import org.eclipse.xtext.xbase.compiler.XbaseCompiler
import org.eclipse.xtext.xbase.compiler.output.FakeTreeAppendable
import org.eclipse.xtext.common.types.JvmType
// import ch.vorburger.xobjects.xObjects.XObject

/**
 * Generate Java class source code from JavaXObject.
 * 
 * @author Michael Vorburger
 */
@SuppressWarnings("restriction")
class XObjectsJavaGenerator implements IGenerator {
	
	@Inject extension IQualifiedNameProvider
  	// @Inject extension TypeReferenceSerializer 
  	// @Inject extension XbaseCompiler
  
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		// NOT for(e: resource.allContents.toIterable.filter(typeof(JavaXObject))) {
		val rootJavaXObject = resource.allContents.toIterable.filter(typeof(JavaXObject)).head 
		// NAH, let's go like this (WAS: "Because XObjects may be anon (name not mandatory) we don't do the usual:")
		val className = getClassName(rootJavaXObject);
		val fileName = rootJavaXObject.fullyQualifiedName.toString("/") + ".java"
		fsa.generateFile(fileName, rootJavaXObject.generate(className))
	}
	
	def String getClassName(JavaXObject xObject) {
		return xObject.eResource.URI.trimFileExtension.segmentsList.last
	}
	
	def generate(JavaXObject it, String className) '''
	    «val importManager = new ImportManager(true)» 
	    «val body = body(importManager, className)»
	    «IF eContainer != null»
	      package «eContainer.fullyQualifiedName»;
	    «ENDIF»
	    
	    «FOR i:importManager.imports»
	      import «i»;
	    «ENDFOR»
	    
    	«body»
  	''' 
  	
	def body(JavaXObject it, ImportManager importManager, String className) {
		val type = type.shortName(importManager) 
		val variable = "_o" // + name
		// TODO Support JavaDoc, look at using JvmModelGenerator.generateJavaDoc()
'''    
    	public class «className» { ««« TODO May be later add "implements XObjectFactory<«type»>"
    		public «type» create() {
    			«type» «variable» = ««« «IF from == null»
    				new «type»(); ««« «ELSE» «from.compile(importManager)» «ENDIF»
«««    	FOR f : properties»
«««        «f.compile(importManager)»
«««      «ENDFOR»
				return «variable»;
    		}
		}
'''
  	}
  	
  	def compile(XExpression xExpression, ImportManager importManager) {
		val result = new FakeTreeAppendable(importManager) // StringBuilderBasedAppendable *#% ?!?
		// ?? toJavaStatement(xExpression, result, false) // NOT toJavaExpression(xExpression, result)
		result.toString
	}
  	
	def shortName(JvmType/*Reference*/ ref, ImportManager importManager) {
	    val result = new StringBuilderBasedAppendable(importManager)
	    // ref.serialize(ref.eContainer, result);
	    result.append(ref);
	    result.toString
	}
}
