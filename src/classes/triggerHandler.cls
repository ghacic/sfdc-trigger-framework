/*
	Created by: Kevin O'Hara (kevinohara80@gmail.com)
	Original Code: https://github.com/kevinohara80/sfdc-trigger-framework
	Last Update: 26 June 2018 by Greg Hacic
	Questions?: greg@ities.co
	
	Notes:
		- this trigger framework bundles a single triggerHandler base class that you can inherit from in all of your trigger handlers. The base class includes context-specific methods that are automatically called when a trigger is executed.
		- the base class also provides a secondary role as a supervisor for Trigger execution. It acts like a watchdog, monitoring trigger activity and providing an api for controlling certain aspects of execution and control flow.
		- but the most important part of this framework is that it's minimal and simple to use.
	
	Tests
		- triggerHandlerTest.class (100.00% coverage)
*/
public virtual class triggerHandler {
	
	//static map of handlername, times run() was invoked
	private static Map<String, LoopCount> loopCountMap;
	private static Set<String> bypassedHandlers;
	@TestVisible private TriggerContext context; //the current context of the trigger, overridable in tests 
	@TestVisible private Boolean isTriggerExecuting; //current context of the trigger, overridable in tests
	
	//static initialization
	static {
		loopCountMap = new Map<String, LoopCount>();
		bypassedHandlers = new Set<String>();
	}
	
	//constructor
	public triggerHandler() {
		this.setTriggerContext();
	}
	
	/***************************************
	* public instance methods
	***************************************/
	
	//main method that will be called during execution
	public void run() {
		if (!validateRun()) { //if the trigger should NOT continue to run
			return; //stop
		} else { //otherwise
			addToLoopCount(); //increments the counter
			//dispatch to the correct handler method
			if (this.context == TriggerContext.BEFORE_INSERT) {
				this.beforeInsert();
			} else if (this.context == TriggerContext.BEFORE_UPDATE) {
				this.beforeUpdate();
			} else if (this.context == TriggerContext.BEFORE_DELETE) {
				this.beforeDelete();
			} else if (this.context == TriggerContext.AFTER_INSERT) {
				this.afterInsert();
			} else if (this.context == TriggerContext.AFTER_UPDATE) {
				this.afterUpdate();
			} else if (this.context == TriggerContext.AFTER_DELETE) {
				this.afterDelete();
			} else if (this.context == TriggerContext.AFTER_UNDELETE) {
				this.afterUndelete();
			}
		}
	}
	
	public void setMaxLoopCount(Integer max) {
		String handlerName = getHandlerName();
		if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
			TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
		} else {
			TriggerHandler.loopCountMap.get(handlerName).setMax(max);
		}
	}
	
	public void clearMaxLoopCount() {
		this.setMaxLoopCount(-1);
	}
	
	/***************************************
	* public static methods
	***************************************/
	
	//add the handler to the bypassedHandlers set
	public static void bypass(String handlerName) {
		triggerHandler.bypassedHandlers.add(handlerName);
	}
	
	//removes the handler from the bypassedHandlers set
	public static void clearBypass(String handlerName) {
		triggerHandler.bypassedHandlers.remove(handlerName);
	}
	
	//designates whether the handler should be bypassed
	public static Boolean isBypassed(String handlerName) {
		return triggerHandler.bypassedHandlers.contains(handlerName);
	}
	
	//removes all elements from the bypassedHandlers set
	public static void clearAllBypasses() {
		triggerHandler.bypassedHandlers.clear();
	}
	
	//determines whether or not the trigger logic is okay to run
	public static Boolean isTriggerOkayToRun(String handlerName) {
		List<Trigger_Status__c> newRecords = new List<Trigger_Status__c>(); //list for any new Trigger_Status__c records
		Boolean returnBoolean = true; //default the boolean to true
		Trigger_Status__c t = Trigger_Status__c.getInstance(handlerName); //grab the Trigger_Status__c custom setting object record named handlerName
		if (t != null) { //if the result is not null
			returnBoolean = t.Status__c; //set the returnBoolean value to the Status__c Boolean value for the found record
		} else { //otherwise, there was NO record corresponding to the handlerName
			//create a record for this trigger so we know about it in the future
			newRecords.add(new Trigger_Status__c(Name = handlerName, Status__c = true));
			List<Database.SaveResult> insertResults = Database.insert(newRecords, false); //insert the record and allow for some failures
		}
		return returnBoolean; //return returnBoolean
	}
	
	/***************************************
	* private instance methods
	***************************************/
	
	@TestVisible
	private void setTriggerContext() {
		this.setTriggerContext(null, false);
	}
	
	@TestVisible
	private void setTriggerContext(String ctx, Boolean testMode) {
		if(!Trigger.isExecuting && !testMode) {
			this.isTriggerExecuting = false;
			return;
		} else {
			this.isTriggerExecuting = true;
		}
		
		if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) || (ctx != null && ctx == 'before insert')) {
			this.context = TriggerContext.BEFORE_INSERT;
		} else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) || (ctx != null && ctx == 'before update')) {
			this.context = TriggerContext.BEFORE_UPDATE;
		} else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) || (ctx != null && ctx == 'before delete')) {
			this.context = TriggerContext.BEFORE_DELETE;
		} else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) || (ctx != null && ctx == 'after insert')) {
			this.context = TriggerContext.AFTER_INSERT;
		} else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) || (ctx != null && ctx == 'after update')) {
			this.context = TriggerContext.AFTER_UPDATE;
		} else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) || (ctx != null && ctx == 'after delete')) {
			this.context = TriggerContext.AFTER_DELETE;
		} else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) || (ctx != null && ctx == 'after undelete')) {
			this.context = TriggerContext.AFTER_UNDELETE;
		}
	}
	
	// increment the loop count
	@TestVisible
	private void addToLoopCount() {
		String handlerName = getHandlerName();
		if (triggerHandler.loopCountMap.containsKey(handlerName)) {
			Boolean exceeded = triggerHandler.loopCountMap.get(handlerName).increment();
			if (exceeded) {
				Integer max = triggerHandler.loopCountMap.get(handlerName).max;
				throw new triggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
			}
		}
	}
	
	//make sure this trigger should continue to run
	@TestVisible
	private Boolean validateRun() {
		String handlerName = getHandlerName();
		if (!this.isTriggerExecuting || this.context == null) { //if the trigger is not executing or there is no trigger context
			throw new triggerHandlerException('Trigger handler called outside of Trigger execution'); //throw an exception
		}
		if (triggerHandler.bypassedHandlers.contains(getHandlerName()) || !triggerHandler.isTriggerOkayToRun(handlerName)) { //if the trigger should be bypassed or if the trigger setting is to not fire
			return false; //return false
		}
		return true; //return true
	}
	
	@TestVisible
	private String getHandlerName() {
		return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
	}
	
	/***************************************
	* context methods
	***************************************/
	
	// context-specific methods for override
	@TestVisible
	protected virtual void beforeInsert(){}
	@TestVisible
	protected virtual void beforeUpdate(){}
	@TestVisible
	protected virtual void beforeDelete(){}
	@TestVisible
	protected virtual void afterInsert(){}
	@TestVisible
	protected virtual void afterUpdate(){}
	@TestVisible
	protected virtual void afterDelete(){}
	@TestVisible
	protected virtual void afterUndelete(){}
	
	/***************************************
	* inner classes
	***************************************/
	
	//inner class for managing the loop count per handler
	@TestVisible
	private class LoopCount {
		private Integer max;
		private Integer count;
		
		public LoopCount() {
			this.max = 5;
			this.count = 0;
		}
		
		public LoopCount(Integer max) {
			this.max = max;
			this.count = 0;
		}
		
		public Boolean increment() {
			this.count++;
			return this.exceeded();
		}
		
		public Boolean exceeded() {
			if(this.max < 0) return false;
			if(this.count > this.max) {
				return true;
			}
			return false;
		}
		
		public Integer getMax() {
			return this.max;
		}
		
		public Integer getCount() {
			return this.count;
		}
		
		public void setMax(Integer max) {
			this.max = max;
		}
	}
	
	//define the class TriggerContext as an enum and provide all the possible TriggerContext values
	@TestVisible
	private enum TriggerContext {
		BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE, AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE, AFTER_UNDELETE
	}
	
	//exception class
	public class triggerHandlerException extends Exception {
		//
	}

}