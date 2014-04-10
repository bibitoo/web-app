package cc.landking.web.core.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;

public abstract class BaseValidService<T> extends BaseService<T> {
	@Override
	public Page<T> findPage( Map<String, Object> searchParams, int pageNumber, int pageSize,
			String sortType, int sortOrder) {
		
		if(!searchParams.containsKey("valid")){
			Map<String, Object> searchParams1 = new HashMap<String, Object>();
			searchParams1.putAll(searchParams);
			searchParams = searchParams1;
			searchParams.put("valid", "true");
		}
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, sortType,  sortOrder);
		Specification<T> spec = buildSpecification(searchParams);
		return getDao().findAll(spec, pageRequest);
	}

}
