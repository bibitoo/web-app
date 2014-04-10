package cc.landking.web.core.dao;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.data.repository.PagingAndSortingRepository;

@NoRepositoryBean
public interface BaseDao<T> extends PagingAndSortingRepository<T, String>,JpaSpecificationExecutor<T> {
}
