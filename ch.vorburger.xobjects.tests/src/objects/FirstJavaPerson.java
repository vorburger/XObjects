package objects;

import model.JavaPerson;

// NOTE: Gen. this Java is completely optional - see FirstTest for dynamic variant

// @Generated
public class FirstJavaPerson {
	// gen. code should, ideally, unless there is a good reason to, NOT implement or extend some RT FMK ObjectFactory<First> kind of thing

	public JavaPerson init() {
		JavaPerson o = new JavaPerson();
		init(o);
		return o;
	}

	// This variant is useful if you must control the object instation (e.g. because you do DI)
	public void init(JavaPerson object) {
		object.setName("Bill Gates is a hero");
		object.age = 53;
	}

}
