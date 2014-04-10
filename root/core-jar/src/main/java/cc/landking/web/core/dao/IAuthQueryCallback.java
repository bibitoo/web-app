package cc.landking.web.core.dao;

import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

public interface IAuthQueryCallback<T> {
	public void buildAuth(Root<T> root, CriteriaQuery<?> query, CriteriaBuilder builder, List<Predicate> predicates);
}
