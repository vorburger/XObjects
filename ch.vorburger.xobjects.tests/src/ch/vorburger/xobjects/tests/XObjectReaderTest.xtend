package ch.vorburger.xobjects.tests

import org.example.library.Book
import org.junit.Test
import ch.vorburger.xobjects.XObjectsReader

import static org.hamcrest.CoreMatchers.*
import static org.junit.Assert.*
import org.eclipse.emf.ecore.EObject

class XObjectReaderTest {
	
	// TODO Compare the API intended here with EFactory's
	
 	@Test
	def testDynXObjectStaticClass() {
		val Book b = new XObjectsReader().readFromClasspath("/objects/FirstBook.xobject");
 		assertThat(b.title, is("Core Java Data Objects"))
 		assertThat(b.pages, is(123));
	}

	@Test
	def testDynXObjectDynEClass() {
		val EObject b = new XObjectsReader().readFromClasspath("/simple/first.xobject" /*, EObject.class */);
		// TODO assert via EObject API - as no static class in this case..
	}
 
}
