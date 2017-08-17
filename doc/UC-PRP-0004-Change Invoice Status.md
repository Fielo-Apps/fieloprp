## Change Invoice Status

### Objectives
This use case describes the possible status for the Invoice

### Preconditions
The administrator must be logged in   
The approver must be logged in  
There must be at least one Invoice in “Open” status  
There must be an approval process configured which updates the status of the invoice

### Postconditions
The Invoice has its status changed

### Flow of Events

### Basic Flow

   1. The administrator selects, in the Invoices landing page, an invoice which status is “Open” from a program where the option “Request Invoice Authorization” is set to true
   2. The system displays the Invoice details page
   3. The system displays the "Edit" and “Close” buttons
   4. The administrator presses the “Close” button
   5. The system refreshes the Invoice details page
   6. The system changes the Invoice status to “Pending for Approval”
   7. The system submits the invoice to the configured approval process
   8. The system hides the “Edit” and “Close” buttons
   9. The system displays the actions to “Approve” or “Reject” the invoice in the Approval Process area
   10. End of flow


### Alternative Flows

##### 1. The approver approves a pending for approval invoice from a program where the option “Request Invoice Authorization” is set to true (step 9 of basic flow)
   1. The approver selects the action to “Approve/Reject” the invoice in the Approval Process area
   2. The system displays the approval process page
   3. The approver approves the invoice
   4. The system changes the Invoice status to “Approved” (action set in the approval process)
   5. The system refreshes the Invoice details page
   6. The system displays the “Revert” and “Reprocess” buttons
   7. End of flow

##### 2. The approver rejects a pending for approval Invoice from a program where the option “Request Invoice Authorization” is set to true (step 9 of basic flow)
   1. The approver selects the action to “Approve/Reject” the invoice in the Approval Process area
   2. The system displays the approval process page
   3. The approver rejects the invoice
   4. The system changes the Invoice status to “Rejected” (action set in the approval process)
   5. The system refreshes the Invoice details page
   6. The system displays the “Reopen” button
   7. End of flow

##### 3. The administrator closes an open invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Open” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Edit", “Close” and “Submit for Approval” buttons
   4. The administrator presses the “Close” button
   5. The system changes the Invoice status to “Approved”
   6. The system refreshes the Invoice details page
   7. The system hides the “Edit, “Close” and “Submit for Approval” buttons
   8. The system displays the “Revert” and “Reprocess” buttons
   9. End of flow

##### 4. The administrator submits for approval an open Invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Open” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Edit", “Close” and “Submit for Approval” buttons
   4. The administrator presses the “Submit for Approval” button
   5. The system refreshes the Invoice details page
   6. The system changes the Invoice status to “Pending for Approval”
   7. The system submits the invoice to the configured approval process
   8. The system hides the “Edit, “Close” and “Submit for Approval” buttons
   9. The system displays the actions to “Approve” or “Reject” the invoice in the Approval Process area
   10. End of flow

##### 5. The approver approves the pending for approval Invoice from a program with no approval process required (step 1 of basic flow)
   1. The approver selects, in the Invoices landing page, an invoice which status is “Pending for Approval” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the actions to “Approve” or “Reject” the invoice in the Approval Process area
   4. The approver selects the action to “Approve/Reject” the invoice
   5. The system displays the approval process page
   6. The approver approves the invoice
   7. The system changes the Invoice status to “Approved” (action set in the approval process)
   8. The system refreshes the Invoice details page
   9. The system displays the “Revert” and “Reprocess” buttons
   10. End of flow

##### 6. The approver rejects the pending for approval Invoice from a program with no approval process required (step 1 of basic flow)
   1. The approver selects, in the Invoices landing page, an invoice which status is “Pending for Approval” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the actions to “Approve” or “Reject” the invoice in the Approval Process area
   4. The approver selects the action to “Approve/Reject” the invoice
   5. The system goes to the configured approval process
   6. The approver rejects the invoice
   7. The system changes the Invoice status to “Rejected” (action set in the approval process)
   8. The system refreshes the Invoice details page
   9. The system displays the “Reopen” button
   10. End of flow
   
##### 7. The administrator reverts an approved Invoice from a program where the option “Request Invoice Authorization” is set to true (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Approved” from a program where the option “Request Invoice Authorization” is set to true
   2. The system displays the Invoice details page
   3. The system displays the “Revert” and “Reprocess” buttons
   4. The administrator presses the “Revert” button
   5. The system changes the Invoice status to “Canceled”
   6. The system reverts the related approval transaction
   7. The system refreshes the Invoice details page
   8. The system hides the “Revert” button
   9. The system displays the “Reopen” button and maintains the “Reprocess” button
   10. End of flow

##### 8. The administrator reverts an approved Invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Approved” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the “Revert” and “Reprocess” buttons
   4. The administrator presses the “Revert” button
   5. The system changes the Invoice status to “Canceled”
   6. The system reverts the related approval transaction
   7. The system refreshes the Invoice details page
   8. The system hides the “Revert” button
   9. The system displays the “Reopen” button and maintains the “Reprocess” button
   10. End of flow
   
##### 9. The administrator reprocesses an approved Invoice from a program where the option “Request Invoice Authorization” is set to true (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Approved” from a program where the option “Request Invoice Authorization” is set to true
   2. The system displays the Invoice details page
   3. The system displays the “Revert” and “Reprocess” buttons
   4. The administrator presses the “Reprocess” button
   5. The system maintains the Invoice status in “Approved”
   6. The system reprocesses the invoice
   7. The system refreshes the Invoice details page
   8. The system maintains the “Revert” and “Reprocess” buttons
   9. End of flow
   
##### 10. The administrator reprocesses an approved Invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Approved” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the “Revert” and “Reprocess” buttons
   4. The administrator presses the “Reprocess” button
   5. The system maintains the Invoice status in “Approved”
   6. The system reprocesses the invoice
   7. The system refreshes the Invoice details page
   8. The system maintains the “Revert” and “Reprocess” buttons
   9. End of flow
   
##### 11. The administrator reopens a rejected Invoice from a program where the option “Request Invoice Authorization” is set to true (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Rejected” from a program where the option “Request Invoice Authorization” is set to true
   2. The system displays the Invoice details page
   3. The system displays the “Reopen” button
   4. The administrator presses the “Reopen” button
   5. The system changes the Invoice status to “Open”
   6. The system refreshes the Invoice details page
   7. The system hides the “Reopen” button
   8. The system displays the "Edit" and “Close” buttons
   9. End of flow
   
##### 12. The administrator reopens a rejected Invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Rejected” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the “Reopen” button
   4. The administrator presses the “Reopen” button
   5. The system changes the Invoice status to “Open”
   6. The system refreshes the Invoice details page
   7. The system hides the “Reopen” button
   8. The system displays the "Edit", “Close” and “Submit for Approval” buttons
   9. End of flow
   
##### 13. The administrator reopens a canceled Invoice from a program where the option “Request Invoice Authorization” is set to true (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Canceled” from a program where the option “Request Invoice Authorization” is set to true
   2. The system displays the Invoice details page
   3. The system displays the “Reopen” and “Reprocess” buttons
   4. The administrator presses the “Reopen” button
   5. The system changes the Invoice status to “Open”
   6. The system refreshes the Invoice details page
   7. The system hides the “Reopen” button
   8. The system displays the "Edit" and “Close” buttons
   9. End of flow
                            
##### 14. The administrator reopens a canceled Invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Canceled” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the “Reopen” and “Reprocess” buttons
   4. The administrator presses the “Reopen” button
   5. The system changes the Invoice status to “Open”
   6. The system refreshes the Invoice details page
   7. The system hides the “Reopen” button
   8. The system displays the “Edit”, “Close” and “Submit for Approval” buttons
   9. End of flow
   
##### 15. The administrator reprocesses a canceled Invoice from a program where the option “Request Invoice Authorization” is set to true (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Canceled” from a program where the option “Request Invoice Authorization” is set to true
   2. The system displays the Invoice details page
   3. The system displays the “Reopen” and “Reprocess” buttons
   4. The administrator presses the “Reprocess” button
   5. The system reprocesses the invoice
   6. The system changes the Invoice status to “Approved”   
   7. The system refreshes the Invoice details page
   8. The system displays the “Revert” and “Reprocess” buttons
   9. End of flow

##### 16. The administrator reprocesses a canceled Invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Canceled” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the “Reopen” and “Reprocess” buttons
   4. The administrator presses the “Reprocess” button
   5. The system reprocesses the invoice
   6. The system changes the Invoice status to “Approved”
   7. The system refreshes the Invoice details page
   8. The system displays the “Revert” and “Reprocess” buttons
   9. End of flow
