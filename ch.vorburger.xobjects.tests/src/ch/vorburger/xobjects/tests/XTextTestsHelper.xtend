package ch.vorburger.xobjects.tests

import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.emf.ecore.EObject

class XTextTestsHelper<T extends EObject> {
	
	@Inject ParseHelper<T> parser
	@Inject ValidationTestHelper validationHelper;
	
	def T parseAndValidate(String text) {
 		val eobject = parser.parse(text)
 		validationHelper.assertNoIssues(eobject)
 		return eobject
 	}
 
}