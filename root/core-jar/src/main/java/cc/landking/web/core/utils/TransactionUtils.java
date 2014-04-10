package cc.landking.web.core.utils;

import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

public class TransactionUtils {
	PlatformTransactionManager transactionManager;
	
	public TransactionUtils(PlatformTransactionManager transactionManager) {
		super();
		this.transactionManager = transactionManager;
	}

	public  PlatformTransactionManager getTransactionManager() {
		return transactionManager;
	}

	public  TransactionStatus beginTransaction() {
		DefaultTransactionDefinition td = new DefaultTransactionDefinition(
				TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = getTransactionManager().getTransaction(td);
		return status;
	}

	public  TransactionStatus beginNewTransaction() {
		DefaultTransactionDefinition td = new DefaultTransactionDefinition(
				TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		TransactionStatus status = getTransactionManager().getTransaction(td);
		return status;
	}

	public  TransactionStatus beginNewReadTransaction() {
		DefaultTransactionDefinition td = new DefaultTransactionDefinition(
				TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		td.setReadOnly(true);
		TransactionStatus status = getTransactionManager().getTransaction(td);
		return status;
	}

	public  void commit(TransactionStatus status) {
		getTransactionManager().commit(status);
	}

	public  void rollback(TransactionStatus status) {
		getTransactionManager().rollback(status);
	}
	// 调用示例代码：
	// TransactionUtils transactionUtils = new TransactionUtils(transactionManager);
	// TransactionStatus status = transactionUtils.beginTransaction();
	// try{
	// dosomthing...
	// transactionUtils.commit(status);
	// }
	// catch(youException e){
	// log.error(e);
	// transactionUtils.rollback(status);
	// }
}
