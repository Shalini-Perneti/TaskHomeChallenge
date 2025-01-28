/***
"The TaskTrigger detects when a task is marked as 'Completed' and 
calls the handler to create the next task in sequence
Author: Shalini Perneti
Date :27/01/2025
****/

trigger TaskTrigger on Task__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Task__c> completedTasks = new List<Task__c>();

        for (Task__c task : Trigger.new) {
            Task__c oldTask = Trigger.oldMap.get(task.Id);
            if (task.Status__c == 'Completed' && oldTask.Status__c != 'Completed') {
                completedTasks.add(task);
            }
        }

        if (!completedTasks.isEmpty()) {
            TaskSequenceHandler.createTaskSequences(completedTasks);
        }
    }
}