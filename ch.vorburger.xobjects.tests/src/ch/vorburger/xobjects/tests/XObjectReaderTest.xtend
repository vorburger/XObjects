package ch.vorburger.xobjects.tests

import org.example.library.Book
import org.junit.Test
import ch.vorburger.xobjects.XObjectsReader
import org.eclipse.emf.ecore.EObject

import static org.hamcrest.CoreMatchers.*
import static org.junit.Assert.*

class XObjectReaderTest {
	
 	@Test
	def testDynXObjectStaticClass() {
		val Book b = new XObjectsReader().fromClasspath("/objects/FirstBook.xobject");
 		assertThat(b.title, is("Core Java Data Objects"))
 		assertThat(b.pages, is(123));
	}

	@Test
	def testDynXObjectDynEClass() {
		val EObject b = new XObjectsReader().fromClasspath("/simple/first.xobject" /*, EObject.class */);
		// TODO assert via EObject API - as no static class in this case..
	}
 
}
