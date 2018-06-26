# Salesforce Trigger Framework

This trigger framework bundles a single **triggerHandler** base class that you inherit within all of your trigger handlers. The base class includes context-specific methods that are automatically called when a trigger is executed.

The base class also provides a secondary role as a supervisor for Trigger execution. It acts like a watchdog, monitoring trigger activity and providing an API for controlling certain aspects of execution and control flow.

But the most important part of this framework is that it's minimal and simple to use. 

## Usage ##

To create a trigger handler, you simply need to create a class that inherits from **triggerHandler.cls**. Here is an example for creating an Account trigger handler.

```java
public class accountTriggerHandler extends triggerHandler {
```

Now add logic to any of the trigger contexts by overriding them in the handler. Here is how we would add logic to a `beforeUpdate` trigger.

```java
public class accountTriggerHandler extends triggerHandler {
	
	//override for beforeUpdate
	public override void beforeUpdate() {
		for (Account a : (List<Account>)Trigger.new) {
			// do something
		}
	}
	
	//add overrides for other contexts like afterInsert

}
```

**Note:** When referencing the Trigger statics within a class, SObjects are returned instead of SObject subclasses like Opportunity, Contact, etc. This means that you must cast each object when you reference them in your trigger handler. This can be done in the constructor. 

```java
public class accountTriggerHandler extends triggerHandler {
	
	private Map<Id, Account> newAccountMap; //map of Account.Id -> Account
	
	//constructor
	public accountTriggerHandler() {
		this.newAccountMap = (Map<Id, Account>)Trigger.newMap; //cast the Map from the the Trigger context variable Trigger.newMap, which is a map of Ids to the new versions of the sObject records
	}
	
	//Trigger.isAfter AND Trigger.isUpdate contexts
	public override void afterUpdate() {
		//
	}

}
```

To use the trigger handler, simply construct an instance of it within the trigger and call the `run()` method. Here is an example of the Account trigger.

```java
trigger accountTrigger on Account (before insert, before update) {
	new accountTriggerHandler().run();
}
```

## Overridable Methods ##

Here are all of the methods that can be overriden. All of the context possibilities are supported.

* `beforeInsert()` //Trigger.isBefore AND Trigger.isInsert contexts
* `beforeUpdate()` //Trigger.isBefore AND Trigger.isUpdate contexts
* `beforeDelete()` //Trigger.isBefore AND Trigger.isDelete contexts
* `afterInsert()` //Trigger.isAfter AND Trigger.isInsert contexts
* `afterUpdate()` //Trigger.isAfter AND Trigger.isUpdate contexts
* `afterDelete()` //Trigger.isAfter AND Trigger.isDelete contexts
* `afterUndelete()` //Trigger.isAfter AND Trigger.isUndelete contexts

## Extras ##

### Max Loop Count ###

To prevent recursion, you can set a max loop count. If this max is exceeded, and exception will be thrown. A great use case is when you want to ensure that your trigger runs once and only once within a single execution. Example:

```java
public class accountTriggerHandler extends triggerHandler {
	
	//constructor
	public accountTriggerHandler() {
		this.setMaxLoopCount(1); //loop only once
	}
	
	//Trigger.isAfter AND Trigger.isUpdate contexts
	public override void afterUpdate() {
		List<Account> acts = [SELECT Id FROM Account WHERE Id IN :Trigger.newMap.keySet()];
		update acts; //will throw exception after this update
	}

}
```

### Bypass API ###

Need to inform other trigger handlers to halt execution? Use the bypass API. Example:

```java
public class opportunityTriggerHandler extends triggerHandler {
	
	//Trigger.isAfter AND Trigger.isUpdate contexts
	public override void afterUpdate() {
		List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE Id IN :Trigger.newMap.keySet()];
		
		Account acc = [SELECT Id, Name FROM Account WHERE Id = :opps.get(0).AccountId];
		
		triggerHandler.bypass('accountTriggerHandler');
		
		acc.Name = 'No Trigger';
		update acc; //won't invoke the accountTriggerHandler
		
		triggerHandler.clearBypass('accountTriggerHandler');
		
		acc.Name = 'With Trigger';
		update acc; //will invoke the accountTriggerHandler
	}

}
```

### Trigger Status ###

The Trigger_Status__c Custom Setting provides the option of turning a trigger on or off without having to deploy any code.

1. Navigate to **Setup** > **Develop** > **Custom Settings**.
2. Click the **Manage** link located on the left-hand side of the Custom Setting reading **Trigger Status**.
3. Rows correspond to the Apex Class that is designated as the handler for a given trigger.
4. Click **Edit** to turn on/off the handler (as needed).
