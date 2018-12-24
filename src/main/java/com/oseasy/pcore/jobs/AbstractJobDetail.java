package com.oseasy.pcore.jobs;


public abstract class AbstractJobDetail implements JobDetail {

	@Override
	public void execute() {
		doWork();
	}
	public abstract void doWork();

}
