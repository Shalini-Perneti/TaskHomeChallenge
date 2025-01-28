/***
The TaskSequenceHandler creates the next task based on the predefined sequence for 
the completed task's process and opportunity
Author: Shalini Perneti
Date :27/01/2025
****/
public class TaskSequenceHandler {

    // Method to create the next tasks in sequence
    public static void createTaskSequences(List<Task__c> completedTasks) {
        Set<String> processSet = new Set<String>();
        Set<Id> opportunitySet = new Set<Id>();
        Map<Id, Task__c> taskByOpportunity = new Map<Id, Task__c>();

        for (Task__c task : completedTasks) {
            processSet.add(task.Process__c);
            opportunitySet.add(task.Opportunity__c);
            taskByOpportunity.put(task.Opportunity__c, task);
        }

        List<AutomatedTaskCreation__c> automatedTaskList = [
            SELECT Id, Order__c, Process__c, Task_Name__c 
            FROM AutomatedTaskCreation__c 
            WHERE Process__c IN :processSet 
            ORDER BY Order__c ASC
        ];

        Map<String, List<AutomatedTaskCreation__c>> tasksByProcess = new Map<String, List<AutomatedTaskCreation__c>>();
        for (AutomatedTaskCreation__c task : automatedTaskList) {
            if (!tasksByProcess.containsKey(task.Process__c)) {
                tasksByProcess.put(task.Process__c, new List<AutomatedTaskCreation__c>());
            }
            tasksByProcess.get(task.Process__c).add(task);
        }

        List<Task__c> tasksToInsert = new List<Task__c>();
        for (Task__c completedTask : completedTasks) {
            if (tasksByProcess.containsKey(completedTask.Process__c)) {
                for (AutomatedTaskCreation__c taskTemplate : tasksByProcess.get(completedTask.Process__c)) {
                    if (taskTemplate.Order__c > completedTask.Sequence_Number__c) {
                        Task__c newTask = new Task__c(
                            Name = taskTemplate.Task_Name__c,
                            Sequence_Number__c = taskTemplate.Order__c,
                            Opportunity__c = completedTask.Opportunity__c,
                            Process__c = taskTemplate.Process__c
                        );
                        tasksToInsert.add(newTask);
                        break;
                    }
                }
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}