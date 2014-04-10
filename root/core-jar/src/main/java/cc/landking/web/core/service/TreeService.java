package cc.landking.web.core.service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.core.entity.ITree;

public abstract class TreeService<T extends AbstractIdEntity> extends
		BaseService<T> {

	@PersistenceContext
	protected EntityManager em;

	@SuppressWarnings("rawtypes")
	@Override
	public void save(T entity) {
		ITree tree = (ITree) entity;
		String oldhierarchyId = tree.getHierarchyId();
		String hierachyId = null;
		if (tree.getParent() != null) {
			hierachyId = ((ITree) tree.getParent()).getHierarchyId()
					+ ITree.SPLITER + entity.getId();
		} else {
			hierachyId = ITree.SPLITER + entity.getId();
		}
		tree.setHierarchyId(hierachyId);
		// tree.selfSet();
		String newhierarchyId = tree.getHierarchyId();
		if (oldhierarchyId != null && !oldhierarchyId.equals(newhierarchyId)) {
			String hql = "update " + entity.getClass().getName() + " set ";
			hql += "hierarchyId='" + newhierarchyId
					+ "' || substring(hierarchyId, "
					+ (oldhierarchyId.length() + 1) + ", length(hierarchyId)) ";
			hql += "where substring(hierarchyId,1," + oldhierarchyId.length()
					+ ")='" + oldhierarchyId + "'";

			Query q = em.createQuery(hql);

			q.executeUpdate();
		}

		super.save(entity);
	}

}
