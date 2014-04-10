package i18n;

import java.util.ResourceBundle;

public class TestResource {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		ResourceBundle bundle = ResourceBundle.getBundle("i18n.tta_message");
		System.out.println(bundle);
	}

}
