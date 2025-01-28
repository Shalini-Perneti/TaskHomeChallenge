@isTest
public class TaskSequenceHandlerTest {
    @isTest
    static void testCreateTaskSequence() {
        // Step 1: Create test data for AutomatedTaskCreation__c
        List<AutomatedTaskCreation__c> automatedTasks = new List<AutomatedTaskCreation__c>();
        automatedTasks.add(new AutomatedTaskCreation__c(
            Process__c = 'Test Process',
            Order__c = 1,
            Task_Name__c = 'Task One',
            Name='Test Process1'
        ));
        automatedTasks.add(new AutomatedTaskCreation__c(
            Process__c = 'Test Process',
            Order__c = 2,
            Task_Name__c = 'Task Two',
            Name='Test Process2'
        ));
        automatedTasks.add(new AutomatedTaskCreation__c(
            Process__c = 'Test Process',
            Order__c = 3,
            Task_Name__c = 'Task Three',
            Name='Test Process3'
        ));
        insert automatedTasks;
        
        // Step 2: Create a test Opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Process__c = 'Test Process'
        );
        insert testOpportunity;
        
        // Step 3: Create a Task__c
        List<Task__c> TaskList = new List<Task__c>();
        Task__c completedTask = new Task__c(
            Name = 'Task One',
            Sequence_Number__c = 1,
            Opportunity__c = testOpportunity.Id,
            Process__c = 'Test Process'
        );
        TaskList.add(completedTask);
        Task__c completedTask2 = new Task__c(
            Name = 'Task One',
            Sequence_Number__c = 1,
            Opportunity__c = testOpportunity.Id,
            Process__c = 'Test Process'
        );
        TaskList.add(completedTask2);
        insert TaskList;
        
        /****line 53, column 29: Method does not exist or incorrect signature: 
        void createTaskSequence(Task__c) from the type TaskSequenceHandler ***/
        
        // Step 4: Call the method under test
        Test.startTest();
        TaskSequenceHandler.createTaskSequences(TaskList);
        Test.stopTest();
        
        // Step 5: Query and verify the next task
        Task__c nextTask = [
            SELECT Name, Sequence_Number__c, Opportunity__c, Process__c, Status__c
            FROM Task__c
            WHERE Opportunity__c = :testOpportunity.Id AND Sequence_Number__c = 2
            LIMIT 1
        ];
        
        System.assertNotEquals(null, nextTask, 'The next task should be created.');
        System.assertEquals('Task Two', nextTask.Name, 'The name of the next task should be Task Two.');
        System.assertEquals(2, nextTask.Sequence_Number__c, 'The sequence number should be 2.');
        System.assertEquals('Test Process', nextTask.Process__c, 'The process should be Test Process.');
        System.assertEquals('Not Started', nextTask.Status__c, 'The status should be Not Started.');
    }
    @isTest
    static void testCompletedTask() {
        // Step 1: Create test data for AutomatedTaskCreation__c
        List<AutomatedTaskCreation__c> automatedTasks = new List<AutomatedTaskCreation__c>();
        automatedTasks.add(new AutomatedTaskCreation__c(
            Process__c = 'Test Process',
            Order__c = 1,
            Task_Name__c = 'Task One',
            Name='Test Process1'
        ));
        automatedTasks.add(new AutomatedTaskCreation__c(
            Process__c = 'Test Process',
            Order__c = 2,
            Task_Name__c = 'Task Two',
            Name='Test Process2'
        ));
        automatedTasks.add(new AutomatedTaskCreation__c(
            Process__c = 'Test Process',
            Order__c = 3,
            Task_Name__c = 'Task Three',
            Name='Test Process3'
        ));
        insert automatedTasks;
        
        // Step 2: Create a test Opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Process__c = 'Test Process'
        );
        insert testOpportunity;
        
        List<Task__c> taskList = new List<Task__c>();
        // Step 3: Create a completed Task__c
        Task__c firstTask = new Task__c(
            Name = 'Task One',
            Sequence_Number__c = 1,
            Opportunity__c = testOpportunity.Id,
            Process__c = 'Test Process',
            Status__c = 'Not Started'
        );
        taskList.add(firstTask);
        insert taskList;
        
        
        
        
        
        
        // Step 4: Call the method under test
        Test.startTest();
        TaskSequenceHandler.createTaskSequences(taskList);
        Test.stopTest();
        
        // Step 5: Query and verify the next task
        Task__c nextTask = [
            SELECT Name, Sequence_Number__c, Opportunity__c, Process__c, Status__c
            FROM Task__c
            WHERE Opportunity__c = :testOpportunity.Id AND Sequence_Number__c = 2
            LIMIT 1
        ];
        
        System.assertNotEquals(null, nextTask, 'The next task should be created.');
        System.assertEquals('Task Two', nextTask.Name, 'The name of the next task should be Task Two.');
        System.assertEquals(2, nextTask.Sequence_Number__c, 'The sequence number should be 2.');
        System.assertEquals('Test Process', nextTask.Process__c, 'The process should be Test Process.');
        System.assertEquals('Not Started', nextTask.Status__c, 'The status should be Not Started.');
    }
    @isTest
    static void testOpportunityTrigger() {
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert testOpportunity;
        
        Opportunity updateOpportunity = testOpportunity;
        updateOpportunity.Process__c = 'Test Process';
        update updateOpportunity;
        
        List<AutomatedTaskCreation__c> automatedTasks = new List<AutomatedTaskCreation__c>();
        automatedTasks.add(new AutomatedTaskCreation__c(
            Process__c = 'Test Process',
            Order__c = 1,
            Task_Name__c = 'Task One',
            Name='Test Process1'
        ));
        
        // Step 3: Create a completed Task__c
         List<Task__c> TaskList = new List<Task__c>();
        Task__c completedTask = new Task__c(
            Name = 'Task One',
            Sequence_Number__c = 1,
            Opportunity__c = testOpportunity.Id,
            Process__c = 'Test Process',
            Status__c = 'Not Started'
        );
        TaskList.add(completedTask);
        insert TaskList;
        
        TaskList[0].Status__c ='Completed';
        update TaskList;
        
       
    }
}