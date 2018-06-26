/*
	Created by: Greg Hacic
	Last Update: 26 June 2018 by Greg Hacic
	Questions?: greg@ities.co
	
	Notes:
		- tests accountTrigger.trigger (100.00% coverage)
		- tests accountTriggerHandler.class (100.00% coverage)
*/
@isTest
private class accountTriggerHandlerTest {
	
	//tests accountTrigger.trigger & accountTriggerHandler.class
	@isTest //defines method for use during testing only
	static void triggerLogic() {
		Test.startTest(); //denote testing context
		//insert a account
		List<Account> accounts = new List<Account>();
		accounts.add(new Account(Name = 'Tess Financial Corp'));
		insert accounts;
		//update an account
		List<Account> accountUpdates = new List<Account>(); //Account list
		accountUpdates.add(new Account(Id = accounts[0].Id, Site = 'Buffalo, NY'));
		update accountUpdates;
		//delete an account
		delete accounts;
		//undelete
		undelete accounts;
		Test.stopTest(); //revert from testing context
	}

}