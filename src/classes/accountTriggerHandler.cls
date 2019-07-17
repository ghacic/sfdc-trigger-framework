/*
	Created by: Greg Hacic
	Last Update: 17 July 2019 by Greg Hacic
	Questions?: greg@ities.co
	
	Notes:
		- this class inherits from triggerHandler.cls
		- tests located at accountTriggerHandlerTest.cls
*/
public class accountTriggerHandler extends triggerHandler {
	
	private Map<Id, Account> newRecordMap; //map of new records > after context values
	private Map<Id, Account> oldRecordMap; //map of old records > before context values
	private List<Account> newRecords; //list of new records > after context values
	private List<Account> oldRecords; //list of old records > before context values
	
	//constructor
	public accountTriggerHandler() {
		newRecordMap = (Map<Id, Account>)Trigger.newMap; //cast the map of new records
		newRecords = (List<Account>)Trigger.new;  //cast the list of new records
		oldRecordMap = (Map<Id, Account>)Trigger.oldMap; //cast the map of old records
		oldRecords = (List<Account>)Trigger.old; //cast the list of old records
	}
	
	//override the beforeInsert trigger context > Trigger.isBefore && Trigger.isInsert
	public override void beforeInsert() {
		//not yet implemented
	}
	
	//override the beforeUpdate trigger context > Trigger.isBefore && Trigger.isUpdate
	public override void beforeUpdate() {
		//not yet implemented
	}
	
	//override the beforeDelete trigger context > Trigger.isBefore && Trigger.isDelete
	public override void beforeDelete() {
		//not yet implemented
	}
	
	//override the afterInsert trigger context > Trigger.isAfter && Trigger.isInsert
	public override void afterInsert() {
		//for (Account a : newRecords) { //for each new version Account record
			//
		//}
	}
	
	//override the afterUpdate trigger context > Trigger.isAfter && Trigger.isUpdate
	public override void afterUpdate() {
		//not implemented yet
	}
	
	//override the afterDelete trigger context > Trigger.isAfter && Trigger.isDelete
	public override void afterDelete() {
		//not yet implemented
	}
	
	//override the afterUndelete trigger context > Trigger.isAfter && Trigger.isUndelete
	public override void afterUndelete() {
		//not yet implemented
	}

}
