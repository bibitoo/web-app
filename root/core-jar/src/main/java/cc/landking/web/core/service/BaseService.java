package cc.landking.web.core.service;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.dao.DynamicSpecifications;
import cc.landking.web.core.dao.SearchFilter;
import cc.landking.web.core.utils.Reflections;

@Transactional(readOnly = false)
public abstract class BaseService<T> {
	
	@PersistenceContext 
	private EntityManager entityManger;
	
	public void setEntityManger(EntityManager entityManger) {
		this.entityManger = entityManger;
	}
	private static Logger logger = LoggerFactory.getLogger(BaseService.class);
	public abstract BaseDao<T> getDao();
	
	public List<T> findAll() {
		return (List<T>) getDao().findAll();
	}
	public Page<T> findPage( Map<String, Object> searchParams, int pageNumber, int pageSize,
			String sortType, int sortOrder) {
		if(pageNumber < 1){
			pageNumber = 1;
		}
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize, sortType,  sortOrder);
		Specification<T> spec = buildSpecification(searchParams);
		return getDao().findAll(spec, pageRequest);
	}
	
	public Page<T> findPageJson( Map<String, Object> searchParams, int pageNumber, int pageSize,
			String sortType, int sortOrder) {
		if(pageNumber < 1){
			pageNumber = 1;
		}

		Page<T> page = 		findPage(searchParams, pageNumber,  pageSize,
				 sortType,  sortOrder);	
		List<T> rows = page.getContent();
		detach(rows);
		return page;
	}
	
	/**
	 * 创建分页请求.
	 */
	protected PageRequest buildPageRequest(int pageNumber, int pageSize, String sortType, int sortOrder) {
		Sort sort = null;
		if ("auto".equals(sortType)) {
			return new PageRequest(pageNumber - 1, pageSize);
		} else  {
			sort = new Sort(sortOrder == 0?Direction.ASC:Direction.DESC, sortType);
		}

		return new PageRequest(pageNumber - 1, pageSize, sort);
	}
	/**
	 * 创建动态查询条件组合.
	 */
	protected Specification<T> buildSpecification( Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		Specification<T> spec = DynamicSpecifications.bySearchFilter(filters.values(),getInterfaceClass());
		return spec;
	}


	public T get(String id) {
		return getDao().findOne(id);
	}

	@Transactional(readOnly = false)
	public void save(T entity) {
		getDao().save(entity);
	}

	@Transactional(readOnly = false)
	public void delete(String id) {
		getDao().delete(id);

	}

	@SuppressWarnings("unchecked")
	public Class<T> getInterfaceClass() {
	    return (Class<T>) Reflections.getClassGenricType(this.getClass(), 0);
	}
	
	public  void detach(T a){
		entityManger.detach(a);
	}
	public  void detach(Collection<T> a){
		if(a != null){
			for(Iterator<T> it = a.iterator();it.hasNext();){
				T obj = it.next();
				 detach(obj);
			}
		}
	}
}
