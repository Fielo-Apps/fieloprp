## Change Invoice Status

### Objectives
This use case describes the possible statuses for the Invoice

### Preconditions
The administrator must be logged in  
There must be an Invoice in “Draft” status  
There must be an approval process configured which updates the status of the invoice

### Postconditions
The Invoice has its status changed

### Flow of Events

### Basic Flow

1. The administrator goes to the Detail page of an Invoice which status is “Draft”
2. The system displays the Invoice Details
3. The system displays the buttons "Edit", “Approve” and “Submit for Approval”
4. The administrator presses the “Submit for Approval” button
5. The system refreshes the Invoice Detail page
6. The system changes the Invoice status to “Pending”
7. The system submits the invoice to the configured approval process
8. The system hides the “Submit for Approval” button
9. The system displays the “Reopen” button
10. The system displays the actions to “Approve” and “Reject” the invoice in the Approval Process area
11. End of flow

### Alternative Flows

##### 1. The administrator approves a draft invoice (step 3 of basic flow)
   1. The administrator presses the “Approve” button
   2. The system changes the Invoice status to “Approved”
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Approve” and “Submit for Approval” buttons
   5. The system displays the “Reprocess” and “Cancel” buttons
   6. End of flow

##### 2. The administrator approves the pending Invoice (step 10 of basic flow)
   1. The administrator presses the action to “Approve/Reject”
   2. The system goes to the configured approval process
   3. The administrator approves the invoice
   4. The system changes the Invoice status to “Approved” (configured in the approval process)
   5. The system refreshes the Invoice Detail page
   6. The system hides the "Reopen" button
   7. The system displays the “Reprocess” and “Cancel” buttons
   8. End of flow

##### 3. The administrator rejects the pending Invoice (step 10 of basic flow)
   1. The administrator presses the action to “Approve/Reject”
   2. The system goes to the configured approval process
   3. The administrator rejects the invoice
   4. The system changes the Invoice status to “Rejected” (configured in the approval process)
   5. The system refreshes the Invoice Detail page
   6. The system maintains the “Reopen” button
   7. End of flow

##### 4. The administrator reopens the pending Invoice (step 9 of basic flow)
   1. The administrator presses the “Reopen” button
   2. The system changes the Invoice status to “Draft”
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Reopen” button
   5. The system displays the “Approve” and “Submit for Approval” buttons
   6. End of flow

##### 5. The administrator cancels an approved Invoice (step 5 of the alternative flow 1 or step 7 of the alternative flow 2)
   1. The administrator presses the “Cancel” button
   2. The system changes the Invoice status to “Canceled”
   3. The system removes the points previously given to the related member
   4. The system refreshes the Invoice Detail page
   5. The system hides the “Cancel” button
   6. The system displays the “Reopen” button and maintains the “Reprocess” button
   7. End of flow

##### 6. The administrator reprocesses an approved Invoice (step 5 of the alternative flow 1 or step 7 of the alternative flow 2)
   1. The administrator presses the “Reprocess” button
   2. The system maintains the Invoice status in “Approved”
   3. The system reprocesses the invoice
   4. The system refreshes the Invoice Detail page
   5. The system maintains the “Cancel” and “Reprocess” buttons
   6. End of flow
   
##### 7. The administrator reopens a rejected Invoice (step 6 of the alternative flow 3)
   1. The administrator presses the “Reopen” button
   2. The system changes the Invoice status to “Draft” 
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Reopen” button
   5. The system displays the “Approve” and “Submit for Approval” buttons
   6. End of flow

##### 8. The administrator reopens a canceled Invoice (step 6 of the alternative flow 5)
   1. The administrator presses the “Reopen” button
   2. The system changes the Invoice status to “Draft”
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Reopen” button
   5. The system displays the “Approve” and “Submit for Approval” buttons
   6. End of flow
   
##### 9. The administrator reprocesses a canceled Invoice (step 6 of the alternative flow 5)
   1. The administrator presses the “Reprocess” button
   2. The system changes the Invoice status to “Approved”
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Reprocess” button
   5. The system displays the “Cancel” and “Reprocess” buttons
   6. End of flow