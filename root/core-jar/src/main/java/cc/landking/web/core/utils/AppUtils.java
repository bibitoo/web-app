package cc.landking.web.core.utils;

import java.math.BigInteger;

public class AppUtils {
	/**
	 * 
	 * @param bytes
	 * @param si
	 * @return value on kB,MB,GB
	 */
	public static String humanReadableByteCount(long bytes, boolean si) {
	    int unit = si ? 1000 : 1024;
	    if (bytes < unit) return bytes + " B";
	    int exp = (int) (Math.log(bytes) / Math.log(unit));
	    String pre = (si ? "kMGTPE" : "KMGTPE").charAt(exp-1) + (si ? "" : "");
	    return String.format("%.2f %sB", bytes / Math.pow(unit, exp), pre);
	}
	/**
	 * The number of bytes in a kilobyte.
	 */
	public static final BigInteger ONE_KB = BigInteger.valueOf(1024);

	/**
	 * The number of bytes in a megabyte.
	 */
	public static final BigInteger ONE_MB = ONE_KB.multiply(ONE_KB);

	/**
	 * The number of bytes in a gigabyte.
	 */
	public static final BigInteger ONE_GB = ONE_KB.multiply(ONE_MB);

	/**
	 * The number of bytes in a terabyte.
	 */
	public static final BigInteger ONE_TB = ONE_KB.multiply(ONE_GB);

	/**
	 * The number of bytes in a petabyte.
	 */
	public static final BigInteger ONE_PB = ONE_KB.multiply(ONE_TB);

	/**
	 * The number of bytes in an exabyte.
	 */
	public static final BigInteger ONE_EB = ONE_KB.multiply(ONE_PB);

	/**
	 * The number of bytes in a zettabyte.
	 */
	public static final BigInteger ONE_ZB = ONE_KB.multiply(ONE_EB);

	/**
	 * The number of bytes in a yottabyte.
	 */
	public static final BigInteger ONE_YB = ONE_KB.multiply(ONE_ZB);

	/**
	 * Returns a human-readable version of the file size, where the input
	 * represents a specific number of bytes.
	 *
	 * @param size
	 *         the number of bytes
	 * @return a human-readable display value (includes units - YB, ZB, EB, PB, TB, GB,
	 *      MB, KB or bytes)
	 */
	public static String byteCountToDisplaySize(BigInteger size) {
	   String displaySize;
	   if (size.divide(ONE_YB).compareTo(BigInteger.ZERO) > 0) {
	      displaySize = String.valueOf(size.divide(ONE_YB)) + " YB";
	   } else if (size.divide(ONE_ZB).compareTo(BigInteger.ZERO) > 0) {
	      displaySize = String.valueOf(size.divide(ONE_ZB)) + " ZB";
	   } else if (size.divide(ONE_EB).compareTo(BigInteger.ZERO) > 0) {
	      displaySize = String.valueOf(size.divide(ONE_EB)) + " EB";
	   } else if (size.divide(ONE_PB).compareTo(BigInteger.ZERO) > 0) {
	      displaySize = String.valueOf(size.divide(ONE_PB)) + " PB";
	   } else if (size.divide(ONE_TB).compareTo(BigInteger.ZERO) > 0) {
	      displaySize = String.valueOf(size.divide(ONE_TB)) + " TB";
	   } else if (size.divide(ONE_GB).compareTo(BigInteger.ZERO) > 0) {
	      displaySize = String.valueOf(size.divide(ONE_GB)) + " GB";
	   } else if (size.divide(ONE_MB).compareTo(BigInteger.ZERO) > 0) {
	      displaySize = String.valueOf(size.divide(ONE_MB)) + " MB";
	   } else if (size.divide(ONE_KB).compareTo(BigInteger.ZERO) > 0) {
	      displaySize = String.valueOf(size.divide(ONE_KB)) + " KB";
	   } else {
	      displaySize = String.valueOf(size) + " bytes";
	   }
	   return displaySize;
	}
	public static String byteCountToDisplaySize(Long size) {
		BigInteger sizeInt = BigInteger.valueOf(size);
		return byteCountToDisplaySize(sizeInt);
	}
}
