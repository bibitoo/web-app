package cc.landking.web.file.service;

import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cc.landking.web.core.entity.ITree;
import cc.landking.web.core.dao.BaseDao;
import cc.landking.web.core.service.BaseService;
import cc.landking.web.core.service.TreeService;
import cc.landking.web.file.dao.ShareDao;
import cc.landking.web.file.entity.Share;

@Component
@Transactional(readOnly = true)
public class ShareService extends BaseService<Share> {

	private ShareDao shareDao;

	@Override
	public BaseDao<Share> getDao() {
		return shareDao;
	}
	
	@Autowired
	@Qualifier("shareDao")
	public void setShareDao(ShareDao shareDao) {
		this.shareDao = shareDao;
	}

}
