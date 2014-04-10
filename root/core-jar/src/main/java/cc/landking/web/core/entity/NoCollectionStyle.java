package cc.landking.web.core.entity;

import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;

import org.apache.commons.lang3.builder.ToStringStyle;

public class NoCollectionStyle extends ToStringStyle {
	protected void appendDetail(StringBuffer buffer, String fieldName, Object value) {
	     if (value instanceof Date) {
	       value = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(value);
	     }else if (value instanceof Collection) {
		       value = "[...]";
		     }
	     buffer.append(value);
	   }
}
