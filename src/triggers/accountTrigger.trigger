/*
	Created by: Greg Hacic
	Last Update: 17 July 2019 by Greg Hacic
	Questions?: greg@ities.co
	
	Notes:
		- tests at accountTriggerHandlerTest.cls (100.00% coverage)
*/
trigger accountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	
	new accountTriggerHandler().run(); //construct an instance of accountTriggerHandler.class and call the run() method

}
