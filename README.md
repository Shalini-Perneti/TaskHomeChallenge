<<<<<<< HEAD
# Task Sequencer

A Salesforce solution designed to automatically create and manage sequential tasks based on selected processes on an Opportunity. This project allows administrators to configure task sequences for different processes, ensuring flexibility and efficiency in task management.

## Features
- Dynamically create tasks when a process is selected on an Opportunity.
- Automatically generate the next task in sequence when the current task is completed.
- Validation to ensure processes cannot be changed if tasks already exist for an Opportunity.
- Administrator-configurable task sequences using custom metadata.

---

## Prerequisites

Before deploying the solution, ensure you have the following:

- **Salesforce Developer Org**
- **Salesforce CLI (SFDX)** installed

---

## Setup Instructions

Follow these steps to deploy and configure the project:

### 1. Authenticate with Salesforce
Run the following command to authenticate your Salesforce org:
```bash
sfdx auth:web:login 
```

### 2. Deploy the Project
Deploy the project metadata to your Salesforce org:
```bash
sfdx force:source:deploy -p force-app
```

### 3. Assign Permission Sets
Assign the required permission set to the current user:
```bash
sfdx force:user:permset:assign -n TaskSequencerPerms
```

### 4. Load Custom Metadata
Load sample custom metadata for processes and task sequences using the following command:
```bash
sfdx force:data:tree:import -p data/AutomatedTaskCreation__c-plan.json
```

---

## Usage

### Step 1: Configure Processes
1. Navigate to the **Automated Task Creation** tab.
2. Define the processes and associated task sequences.

### Step 2: Use on Opportunity
1. Open an Opportunity record.
2. Select a process from the **Process__c** picklist field.
3. View the automatically created tasks under the related list.
4. Mark tasks as **Completed** to generate the next task in sequence.

---

## Data Model

### Custom Objects
1. **AutomatedTaskCreation__c**
   - Stores the definitions of processes and their task sequences.
   - Fields:
     - `Process__c` (Picklist): The process name.
     - `Task_Name__c` (Text): The task name.
     - `Order__c` (Number): Sequence of the task.

2. **Task__c**
   - Represents tasks associated with Opportunities.
   - Fields:
     - `Name` (Text): Task name.
     - `Status__c` (Picklist): Task status (e.g., Not Started, Completed).
     - `Sequence_Number__c` (Number): Task order.
     - `Opportunity__c` (Lookup): Related Opportunity.
     - `Process__c` (Text): Related process.

---

## Testing

Run the following test classes to ensure the solution works as expected:

1. **TaskSequenceHandlerTest**
   - Validates task creation and sequence handling.
2. **OpportunityTriggerTest**
   - Verifies Opportunity-related trigger functionality.

To execute tests, use the Salesforce Developer Console or run:
```bash
sfdx force:apex:test:run -r human
```

---

## Contribution

We welcome contributions! Follow these steps to contribute:
1. Fork the repository.
2. Create a new feature branch.
3. Submit a pull request for review.

---

## License

This project is licensed under the MIT License.
=======
# TaskHomeChallenge
>>>>>>> cf552fa4c3f00f4074abd477c89407b30133a209
