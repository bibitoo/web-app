package cc.landking.web.core.utils;

import java.util.Date;


public interface DateProvider {

	Date getDate();

	public static final DateProvider DEFAULT = new CurrentDateProvider();

	public static class CurrentDateProvider implements DateProvider {

		public Date getDate() {
			return new Date();
		}
	}

	public static class ConfigurableDateProvider implements DateProvider {

		private final Date date;

		public ConfigurableDateProvider(Date date) {
			this.date = date;
		}

		public Date getDate() {
			return date;
		}
	}

}
