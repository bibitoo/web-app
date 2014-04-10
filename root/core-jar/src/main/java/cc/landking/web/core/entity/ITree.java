package cc.landking.web.core.entity;

import java.util.Set;

public interface ITree<T> {
	public static String SPLITER = "/";

	public abstract Set<T> getChildren();

	public abstract boolean getIsParent();

	public abstract void setHierarchyId(String hierachyId);

	public abstract String getHierarchyId();

	public T getParent();

}