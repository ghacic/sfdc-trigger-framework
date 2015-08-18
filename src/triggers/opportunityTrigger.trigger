/*
	Created by: Greg Hacic
	Last Update: 18 August 2015 by Greg Hacic
	Questions?: greg@interactiveties.com
	Copyright 2015 Interactive Ties LLC
	
	Notes:
		- tests at opportunityTriggerHandlerTest.class
*/
trigger opportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	
	new opportunityTriggerHandler().run(); //construct an instance of opportunityTriggerHandler.class and call the run() method

}
