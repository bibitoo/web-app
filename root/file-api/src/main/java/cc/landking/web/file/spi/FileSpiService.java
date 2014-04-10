package cc.landking.web.file.spi;
import java.util.HashMap;

import javax.jws.WebService;

@WebService
public interface FileSpiService {
	public void save(String resultStr, HashMap<String,String> permissions) ;
}
