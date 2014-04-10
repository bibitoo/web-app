package cc.landking.web.core.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.CopyOnWriteArrayList;

import javax.annotation.PostConstruct;
import javax.servlet.Filter;

import org.apache.shiro.config.ConfigurationException;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.util.StringUtils;
import org.apache.shiro.web.filter.mgt.NamedFilterList;
import org.apache.shiro.web.filter.mgt.PathMatchingFilterChainResolver;
import org.apache.shiro.web.servlet.AbstractShiroFilter;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.utils.OrderedProperties;

@Component
@Transactional(readOnly = true)
public class ShiroRoleService implements ApplicationContextAware {

	private static final String CRLF= "\r\n";
	
	ApplicationContext ctx;

	List<String> roles = new ArrayList<String>();
	
	private static List<String> unAuthorizeRole = new ArrayList<String>();
	static{
		unAuthorizeRole.add("orguser");
		unAuthorizeRole.add("user");
	}


	@PostConstruct
	public void afterPropertiesSet() throws Exception {;
		ShiroFilterFactoryBean bean = (ShiroFilterFactoryBean) ctx
				.getBean("&shiroFilter");
		Map<String, String> filters = bean.getFilterChainDefinitionMap();
		for (Iterator<String> it = filters.keySet().iterator(); it.hasNext();) {
			String key = it.next();
			String value = filters.get(key);
			if (value.contains("roles") || value.contains("rolesOrFilter")) {
				String[] filterTokens = splitChainDefinition(value);

		        //each token is specific to each filter.
		        //strip the name and extract any filter-specific config between brackets [ ]
		        for (String token : filterTokens) {
		            String[] nameConfigPair = toNameConfigPair(token);

		            //now we have the filter name, path and (possibly null) path-specific config.  Let's apply them:
		            if(nameConfigPair[0].equals("roles") || nameConfigPair[0].equals("rolesOrFilter")){
		            	for(int i=1;i<nameConfigPair.length;i++){
		            		String[] theRoles = nameConfigPair[i].split(",");
		            		roles.addAll(Arrays.asList(theRoles));
		            		
		            	}
		            }
		        }
				
			}
		}
		removeDuplicate(roles);

	}
	
	/** List order not maintained **/

	  public static void removeDuplicate(List<String> arlList)
	  {
	   HashSet<String> h = new HashSet<String>(arlList);
	   
	   for(Iterator<String> it = h.iterator();it.hasNext();){
		   String role = it.next();
		   if(unAuthorizeRole.contains(role)){
			   it.remove();
		   }
	   }
	   arlList.clear();
	   arlList.addAll(h);
	  
	  }



    protected String[] toNameConfigPair(String token) throws ConfigurationException {

        try {
            String[] pair = token.split("\\[", 2);
            String name = StringUtils.clean(pair[0]);

            if (name == null) {
                throw new IllegalArgumentException("Filter name not found for filter chain definition token: " + token);
            }
            String config = null;

            if (pair.length == 2) {
                config = StringUtils.clean(pair[1]);
                //if there was an open bracket, it assumed there is a closing bracket, so strip it too:
                config = config.substring(0, config.length() - 1);

                //backwards compatibility prior to implmenting SHIRO-205:
                //prior to SHIRO-205 being implemented, it was common for end-users to quote the config inside brackets
                //if that config required commas.  We need to strip those quotes to get to the interior quoted definition
                //to ensure any existing quoted definitions still function for end users:
                if (config.startsWith("\"") && config.endsWith("\"")) {
                    config = config.substring(1, config.length() - 1);
                }
                
                config = StringUtils.clean(config);
            }
            
            return new String[]{name, config};

        } catch (Exception e) {
            String msg = "Unable to parse filter chain definition token: " + token;
            throw new ConfigurationException(msg, e);
        }
    }
    /**
     * Splits the comma-delimited filter chain definition line into individual filter definition tokens.
     * <p/>
     * Example Input:
     * <pre>
     *     foo, bar[baz], blah[x, y]
     * </pre>
     * Resulting Output:
     * <pre>
     *     output[0] == foo
     *     output[1] == bar[baz]
     *     output[2] == blah[x, y]
     * </pre>
     * @param chainDefinition the comma-delimited filter chain definition.
     * @return an array of filter definition tokens
     * @since 1.2
     * @see <a href="https://issues.apache.org/jira/browse/SHIRO-205">SHIRO-205</a>
     */
    protected String[] splitChainDefinition(String chainDefinition) {
        return StringUtils.split(chainDefinition, StringUtils.DEFAULT_DELIMITER_CHAR, '[', ']', true, true);
    }

	@Override
	public void setApplicationContext(ApplicationContext ctx)
			throws BeansException {
		this.ctx = ctx;
		
	}

	public List<String> findRoles() {
		List<String> allRoles = new ArrayList<String>();
		allRoles.addAll(roles);
		return allRoles;
	}
	
    public String loadFilterChainDefinitions() {
        StringBuffer sb = new StringBuffer("");
        ClassPathResource cp = new ClassPathResource("filter-chain-definitions.properties");
        Properties properties = new OrderedProperties();
        try{
            properties.load(cp.getInputStream());
        } catch(IOException e) {
            throw new RuntimeException("load filter-chain-definitions.properties error!");
        }

        for(Iterator its = properties.keySet().iterator();its.hasNext();) {
            String key = (String)its.next();
            sb.append(key).append(" = ").append(properties.getProperty(key).trim()).append(CRLF);
        }
        return sb.toString();
     }
}
