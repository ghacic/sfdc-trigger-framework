/*
	Created by: Greg Hacic
	Last Update: 17 July 2019 by Greg Hacic
	Questions?: greg@ities.co
	
	Notes:
		- tests accountTrigger.trigger (100.00% coverage)
		- tests accountTriggerHandler.cls (100.00% coverage)
*/
@isTest
private class accountTriggerHandlerTest {
	
	//tests accountTrigger.trigger & accountTriggerHandler.cls
	@isTest //defines method for use during testing only
	static void triggerLogic() {
		Test.startTest(); //denote testing context
		//insert a account
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(Name = 'Tess Financial Corp'));
		insert accounts;
		//handle any validation specific to the trigger execution
		//update an account
		List<Account> accountUpdates = new List<Account>(); //Account list
		accountUpdates.add(new Account(Id = accounts[0].Id, Site = 'Buffalo, NY'));
		update accountUpdates;
		//handle any validation specific to the trigger execution
		//delete an account
		delete accounts;
		//handle any validation specific to the trigger execution
		//undelete
		undelete accounts;
		//handle any validation specific to the trigger execution
		Test.stopTest(); //revert from testing context
	}

}
