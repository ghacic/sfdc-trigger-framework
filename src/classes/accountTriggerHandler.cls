/*
	Created by: Greg Hacic
	Last Update: 26 June 2018 by Greg Hacic
	Questions?: greg@ities.co
	
	Notes:
		- this class inherits from triggerHandler.class
		- tests located at accountTriggerHandlerTest.class
*/
public class accountTriggerHandler extends triggerHandler {
	
	private Map<Id, Account> newRecordMap; //map of new records
	private Map<Id, Account> oldRecordMap; //map of old records
	private List<Account> newRecords; //list of new records
	private List<Account> oldRecords; //list of old records
	
	//constructor
	public accountTriggerHandler() {
		newRecordMap = (Map<Id, Account>)Trigger.newMap; //cast the map of new records
		newRecords = (List<Account>)Trigger.new;  //cast the list of new records
		oldRecordMap = (Map<Id, Account>)Trigger.oldMap; //cast the map of old records
		oldRecords = (List<Account>)Trigger.old; //cast the list of old records
	}
	
	//override the beforeInsert trigger context
	public override void beforeInsert() {
		//not yet implemented
	}
	
	//override the beforeUpdate trigger context
	public override void beforeUpdate() {
		//not yet implemented
	}
	
	//override the beforeDelete trigger context
	public override void beforeDelete() {
		//not yet implemented
	}
	
	//override the afterInsert trigger context
	public override void afterInsert() {
		//for (Account a : newRecords) { //for each new Account record
			//
		//}
	}
	
	//override the afterUpdate trigger context
	public override void afterUpdate() {
		//not implemented yet
	}
	
	//override the afterDelete trigger context
	public override void afterDelete() {
		//not yet implemented
	}
	
	//override the afterUndelete trigger context
	public override void afterUndelete() {
		//not yet implemented
	}

}