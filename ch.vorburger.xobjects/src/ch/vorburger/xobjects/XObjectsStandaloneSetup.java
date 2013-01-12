
package ch.vorburger.xobjects;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class XObjectsStandaloneSetup extends XObjectsStandaloneSetupGenerated{

	public static void doSetup() {
		new XObjectsStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

