package cc.landking.web.core.dao;

import java.beans.PropertyDescriptor;
import java.util.Collection;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.core.convert.support.DefaultConversionService;
import org.springframework.data.jpa.domain.Specification;

import cc.landking.web.core.utils.Collections3;
import cc.landking.web.core.utils.UserUtils;

import com.google.common.collect.Lists;

public class DynamicSpecifications {
	public static <T> Specification<T> bySearchFilter(final Collection<SearchFilter> filters, final Class<T> clazz) {
		return new Specification<T>() {
			@Override
			public Predicate toPredicate(Root<T> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
				if (Collections3.isNotEmpty(filters)) {

					List<Predicate> predicates = Lists.newArrayList();
					for (SearchFilter filter : filters) {
						// nested path translate, 如Task的名为"user.name"的filedName, 转换为Task.user.name属性
						String[] names = StringUtils.split(filter.fieldName, ".");
						Path expression = root.get(names[0]);
						for (int i = 1; i < names.length; i++) {
							expression = expression.get(names[i]);
						}
						Object value = null;
						if(filter.operator!=SearchFilter.Operator.ISNULL && filter.operator!=SearchFilter.Operator.ISNOTNULL){
							value =transferObjectValue(filter.fieldName,clazz,filter.value);
						}

						// logic operator
						switch (filter.operator ) {
						case EQ:
							predicates.add(builder.equal(expression, value));
							break;
						case LIKE:
							predicates.add(builder.like(expression, "%" + filter.value + "%"));
							break;
						case LLIKE:
							predicates.add(builder.like(expression,  filter.value + "%"));
							break;
						case GT:
							predicates.add(builder.greaterThan(expression, (Comparable) value));
							break;
						case LT:
							predicates.add(builder.lessThan(expression, (Comparable) value));
							break;
						case GTE:
							predicates.add(builder.greaterThanOrEqualTo(expression, (Comparable) value));
							break;
						case LTE:
							predicates.add(builder.lessThanOrEqualTo(expression, (Comparable) value));
							break;
						case ISNULL:
							predicates.add(builder.isNull(expression));
							break;
						case ISNOTNULL:
							predicates.add(builder.isNotNull(expression));
							break;
						}
					}

					// 将所有条件用 and 联合起来
					if (predicates.size() > 0) {
						return builder.and(predicates.toArray(new Predicate[predicates.size()]));
					}
				}

				return builder.conjunction();
			}
		};
	}
	
	public static <T> Specification<T> bySearchAndAuthorizeFilter(final Collection<SearchFilter> filters,  final Class<T> clazz, final IAuthQueryCallback authquery) {
		return new Specification<T>() {
			@Override
			public Predicate toPredicate(Root<T> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
				List<Predicate> predicates = Lists.newArrayList();
				

				if (Collections3.isNotEmpty(filters)) {

					for (SearchFilter filter : filters) {
						// nested path translate, 如Task的名为"user.name"的filedName, 转换为Task.user.name属性
						String[] names = StringUtils.split(filter.fieldName, ".");
						Path expression = root.get(names[0]);
						for (int i = 1; i < names.length; i++) {
							expression = expression.get(names[i]);
						}
						
						Object value = null;
						if(filter.operator!=SearchFilter.Operator.ISNULL && filter.operator!=SearchFilter.Operator.ISNOTNULL){
							value =transferObjectValue(filter.fieldName,clazz,filter.value);
						}

						// logic operator
						switch (filter.operator ) {
						case EQ:
							predicates.add(builder.equal(expression, value));
							break;
						case LIKE:
							predicates.add(builder.like(expression, "%" + filter.value + "%"));
							break;
						case LLIKE:
							predicates.add(builder.like(expression,  filter.value + "%"));
							break;
						case GT:
							predicates.add(builder.greaterThan(expression, (Comparable) value));
							break;
						case LT:
							predicates.add(builder.lessThan(expression, (Comparable) value));
							break;
						case GTE:
							predicates.add(builder.greaterThanOrEqualTo(expression, (Comparable) value));
							break;
						case LTE:
							predicates.add(builder.lessThanOrEqualTo(expression, (Comparable) value));
							break;
						case ISNULL:
							predicates.add(builder.isNull(expression));
							break;
						case ISNOTNULL:
							predicates.add(builder.isNotNull(expression));
							break;
						}
					}

				}
				if(authquery != null){
					authquery.buildAuth( root, query, builder,predicates) ;
				}

				// 将所有条件用 and 联合起来
				if (predicates.size() > 0) {
					Predicate p = builder.and(predicates.toArray(new Predicate[predicates.size()]));
					return p;
				}
				
				return builder.conjunction();
			}
		};
	}
	public static Object transferObjectValue(String name,Class<?> clazz,Object value){
		if(value == null){
			return null;
		}
		DefaultConversionService defaultConversionService = new DefaultConversionService();
		Class cls = getPropertyDescriptor(name,clazz);
		return defaultConversionService.convert(value, cls);
	}
	public static Class getPropertyDescriptor(String name,Class clazz){
		Class cls = clazz;
		String[] propNames = name.split("\\.");
		for(int i=0;i<propNames.length;i++){
			PropertyDescriptor propertyDescriptor = BeanUtils.getPropertyDescriptor(cls, propNames[i]);
			cls = propertyDescriptor.getPropertyType();
		}
		return cls;
	}
}
