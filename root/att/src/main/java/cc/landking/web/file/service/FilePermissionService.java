package cc.landking.web.file.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.entity.AbstractIdEntity;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.OrganizationData;
import cc.landking.web.core.service.OrganizationSpiService;
import cc.landking.web.core.utils.Exceptions;
import cc.landking.web.core.utils.UserUtils;
import cc.landking.web.file.dao.FilePermissionDao;
import cc.landking.web.file.entity.FileBase;
import cc.landking.web.file.entity.FilePermission;

@Component
@Transactional(readOnly = true)
public class FilePermissionService extends BaseService<FilePermission>
		implements ApplicationContextAware {

	private FilePermissionDao filePermissionDao;
	@Autowired
	FileBaseService fileBaseService;

	@Override
	public BaseDao<FilePermission> getDao() {
		return filePermissionDao;
	}

	@Autowired
	@Qualifier("filePermissionDao")
	public void setFilePermissionDao(FilePermissionDao filePermissionDao) {
		this.filePermissionDao = filePermissionDao;
	}

	@Transactional(readOnly = false)
	public void deleteByObjectId(String objectId) {
		filePermissionDao.deleteByObjectId(objectId);

	}

	public List<FilePermission> findByObjectId(String objectId) {
		return filePermissionDao.findByObjectId(objectId);
	}

	@Transactional(readOnly = true)
	public void saveReaders(String objectId, String roles) {
		if (StringUtils.isNotEmpty(roles)) {
			String[] readers = roles.split(AbstractIdEntity.LIST_SPLITER);
			for (String reader : readers) {
				if (StringUtils.isNotEmpty(reader)) {
					FilePermission fp = new FilePermission(objectId, reader,
							FilePermission.READER);
					save(fp);
				}
			}
		}
	}

	@Transactional(readOnly = true)
	public void saveEditors(String objectId, String roles) {
		if (StringUtils.isNotEmpty(roles)) {
			String[] editors = roles.split(AbstractIdEntity.LIST_SPLITER);

			for (String editor : editors) {
				if (StringUtils.isNotEmpty(editor)) {
					FilePermission fp = new FilePermission(objectId, editor,
							FilePermission.EDITOR);
					save(fp);
				}
			}
		}
	}

	public void copyPermission(String from, String to) {
		List<FilePermission> fromPermissions = filePermissionDao
				.findByObjectId(from);
		for (Iterator<FilePermission> it = fromPermissions.iterator(); it
				.hasNext();) {
			FilePermission fromPermission = it.next();
			FilePermission toPermission = new FilePermission(
					fromPermission.getObjectId(), fromPermission.getRole(),
					fromPermission.getPermission());
			save(toPermission);
		}
	}

	public Map<String, Object> findPermissionByObjectId(String ObjectId) {
		Map<String, Object> retval = new HashMap<String, Object>();
		List<FilePermission> perms = findByObjectId(ObjectId);
		Map<String, String> reader = new HashMap<String, String>();
		Map<String, String> editor = new HashMap<String, String>();
		retval.put(FilePermission.EDITOR, editor);
		retval.put(FilePermission.READER, reader);
		for (FilePermission perm : perms) {
			if (perm.getPermission() != null
					&& perm.getPermission().equals(FilePermission.EDITOR)) {
				String editorids = editor.get("ids");
				if (editorids == null) {
					editorids = perm.getRole();
				} else {
					editorids += AbstractIdEntity.LIST_SPLITER + perm.getRole();
				}
				editor.put("ids", editorids);
				String editorNames = editor.get("names");
				OrganizationData org = getOrganizationSpiService().getById(
						perm.getRole());
				if (org != null) {
					if (editorNames == null) {
						editorNames = org == null ? "" : org.getName();
					} else {
						editorNames += AbstractIdEntity.LIST_SPLITER
								+ (org == null ? "" : org.getName());
					}
					editor.put("names", editorNames);
				}
			} else {
				String readerids = reader.get("ids");
				if (readerids == null) {
					readerids = perm.getRole();
				} else {
					readerids += AbstractIdEntity.LIST_SPLITER + perm.getRole();
				}
				reader.put("ids", readerids);
				String readerNames = reader.get("names");
				OrganizationData org = getOrganizationSpiService().getById(
						perm.getRole());
				if (org != null) {
					if (readerNames == null) {
						readerNames = org == null ? "" : org.getName();
					} else {
						readerNames += AbstractIdEntity.LIST_SPLITER
								+ (org == null ? "" : org.getName());
					}
					reader.put("names", readerNames);
				}
			}
		}
		return retval;
	}

	public List<FilePermission> findObjectReader(String objectId) {
		return filePermissionDao.findByObjectIdAndPermission(objectId,
				FilePermission.READER);
	}

	public List<FilePermission> findObjectEditor(String objectId) {
		return filePermissionDao.findByObjectIdAndPermission(objectId,
				FilePermission.EDITOR);
	}

	public boolean hasPermission(FileBase object, String permission) {
		try {
			if (UserUtils.hasRole("fileadmin") || UserUtils.isAdmin()) {
				return true;
			}
		} catch (Exception ex) {
			throw Exceptions.unchecked(ex);
		}
		FileBase fb = fileBaseService.get(object.getId());
		if (fb != null) {
			return hasPermissionInternal(object.getId(), permission);
		} else if (object.getParent() != null) {
			return hasPermissionInternal(object.getParent().getId(), permission);

		} else {
			return false;
		}
	}

	private boolean hasPermissionInternal(String objectId, String permission) {

		PageRequest pageRequest = new PageRequest(0, 1);
		List<FilePermission> perms = filePermissionDao
				.findByObjectIdAndPermissionAndRoles(objectId, permission,
						UserUtils.getCurrentUserOrganizations(), pageRequest);
		if (perms.size() > 0) {
			return true;
		} else if (permission.equals(FilePermission.READER)) {
			perms = filePermissionDao.findByObjectIdAndPermissionAndRoles(
					objectId, FilePermission.EDITOR,
					UserUtils.getCurrentUserOrganizations(), pageRequest);
			if (perms.size() > 0) {
				return true;
			}
		}
		return false;
	}

	private OrganizationSpiService getOrganizationSpiService() {
		return ctx.getBean(OrganizationSpiService.class);
	}

	ApplicationContext ctx;

	@Override
	public void setApplicationContext(ApplicationContext ctx)
			throws BeansException {
		this.ctx = ctx;

	}

}
