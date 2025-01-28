/***
"The trigger prevents process updates on Opportunities with existing tasks and 
automatically creates tasks based on the Opportunity's process after insert or update."
Author: Shalini Perneti
Date :27/01/2025
****/

trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update) {

    Set<Id> oppIds = new Set<Id>();

    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new) {
            if (opp.Process__c != Trigger.oldMap.get(opp.Id).Process__c) {
                oppIds.add(opp.Id);
            }
        }
    }

    if (!oppIds.isEmpty()) {
        List<Task__c> tasklist = [
            SELECT Id, Opportunity__c 
            FROM Task__c 
            WHERE Opportunity__c IN :oppIds
        ];

        Map<Id, Boolean> oppHasTasks = new Map<Id, Boolean>();
        for (Task__c task : tasklist) {
            oppHasTasks.put(task.Opportunity__c, true);
        }

        for (Opportunity opp : Trigger.new) {
            if (oppHasTasks.containsKey(opp.Id)) {
                opp.addError('The process can only be changed if no tasks exist for the opportunity');
            }
        }
    }

    List<String> processList = new List<String>();
    if (Trigger.isAfter) {
        for (Opportunity opp : Trigger.new) {
            if (String.isNotBlank(opp.Process__c)) {
                if (Trigger.isInsert || (Trigger.isUpdate && opp.Process__c != Trigger.oldMap.get(opp.Id).Process__c)) {
                    processList.add(opp.Process__c);
                }
            }
        }
    }

    if (!processList.isEmpty()) {
        List<AutomatedTaskCreation__c> automatedTaskList = [
            SELECT Id, Order__c, Process__c, Task_Name__c 
            FROM AutomatedTaskCreation__c 
            WHERE Process__c IN :processList 
            ORDER BY Order__c ASC
        ];

        Map<String, AutomatedTaskCreation__c> firstTaskByProcess = new Map<String, AutomatedTaskCreation__c>();
        for (AutomatedTaskCreation__c task : automatedTaskList) {
            if (!firstTaskByProcess.containsKey(task.Process__c)) {
                firstTaskByProcess.put(task.Process__c, task);
            }
        }

        List<Task__c> tasksToInsert = new List<Task__c>();
        for (Opportunity opp : Trigger.new) {
            if (firstTaskByProcess.containsKey(opp.Process__c)) {
                AutomatedTaskCreation__c firstTask = firstTaskByProcess.get(opp.Process__c);
                Task__c newTask = new Task__c(
                    Name = firstTask.Task_Name__c,
                    Sequence_Number__c = firstTask.Order__c,
                    Opportunity__c = opp.Id,
                    Process__c = firstTask.Process__c
                );
                tasksToInsert.add(newTask);
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}