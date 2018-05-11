## Change Invoice Status

### Objectives
This use case describes the possible status for the Invoice

### Preconditions
The back office user must be logged in   
The approver must be logged in  
There must be at least one Invoice in "Open" status
There must be an approval process configured to Invoices

### Postconditions
The Invoice has its status changed

### Flow of Events

### Basic Flow
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Open" from a program where the option "Request Invoice Authorization" is set to FALSE and there is NO active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays the "Edit" button
   4. The system displays the "Close" button
   5. The system displays the "Reject" button
   6. The back office user presses the "Reject" button
   7. The system opens a modal with the fields: "Reject Reason" and "Comments"
   8. The back office user selects one of the available options for the "Reject Reason" field
   9. The back office user fills in the "Comments" field 
   10. The back office user presses the "Save" button
   11. The system saves the "Reject Reason" option in the corresponding invoice field
   12. The system saves the "Comments" info in the corresponding invoice field
   13. The system changes the Invoice status to "Rejected"
   14. The system refreshes the Invoice details page
   15. The system hides the "Edit", "Close" and "Reject" buttons
   16. The system displays the "Reopen" button
   17. End of flow


### Alternative Flows

##### 1. The back office user gives no reason for the rejection (step 8 of basic flow)
   1. The back office user doesn't select any of the available options for the "Reason" field
   2. The back office user fills in the "Comments" field 
   3. The back office user presses the "Save" button
   4. The system displays an error message
   5. Back to step 8 of basic flow

##### 2. The back office user closes an open invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE and there is NO active Approval Process for Invoices (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Open" from a program where the option "Request Invoice Authorization" is set to false and there is no active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays the "Edit" button
   4. The system displays the "Close" button
   5. The system displays the "Reject" button
   6. The back office user presses the "Close" button
   7. The system opens a modal with the field "Comments"
   8. The back office user fills in the "Comments" field
   9. The back office user presses the "Save" button
   10. The system saves the "Comments" info in the corresponding invoice field
   11. The system changes the Invoice status to "Approved"
   12. The system updates the “Approved Date” Field with the date/time of approval
   13. The system refreshes the Invoice details page
   14. The system hides the "Edit, "Close" and "Reject" buttons
   15. The system displays the "Revert" and "Reprocess" buttons
   16. End of flow

##### 3. The back office user closes an open invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE and there is an ACTIVE Approval Process for Invoices (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Open" from a program where the option "Request Invoice Authorization" is set to false and there is an active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays the "Edit" button
   4. The system displays the "Close" button
   5. The system displays the "Submit for Approval" button
   6. The back office user presses the "Close" button
   7. The system opens a modal with the field "Comments"
   8. The back office user fills in the "Comments" field
   9. The back office user presses the "Save" button
   10. The system saves the "Comments" info in the corresponding invoice field
   11. The system changes the Invoice status to "Approved"
   12. The system updates the “Approved Date” Field with the date/time of approval
   13. The system refreshes the Invoice details page
   14. The system hides the "Edit, "Close" and "Submit for Approval" buttons
   15. The system displays the "Revert" and "Reprocess" buttons
   16. End of flow

##### 4. The back office user submits for approval an open invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE and there is an ACTIVE Approval Process for Invoices (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Open" from a program where the option "Request Invoice Authorization" is set to false and there is an active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays the "Edit" button
   4. The system displays the "Close" button
   5. The system displays the "Submit for Approval" button
   6. The back office user presses the "Submit for Approval" button
   7. The system submits the invoice to the configured approval process
   8. The system changes the Invoice status to "Pending for Approval"
   9. The system refreshes the Invoice details page
   10. The system hides the "Edit, "Close" and "Submit for Approval" buttons
   11. The system displays the "Approve" and "Reject" buttons to the approver(s) set in the approval process
   12. End of flow

##### 5. The back office user closes an open invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE and there is NO active approval process for Invoices (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Open" from a program where the option "Request Invoice Authorization" is set to true and there is no active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays the "Edit" button
   4. The system displays the "Close" button
   5. The back office user presses the "Close" button
   6. The system opens no modal 
   7. The system changes the Invoice status to "Pending for Approval"
   8. The system refreshes the Invoice details page
   9. The system hides the "Edit" and "Close" buttons
   10. The system displays the "Approve" and "Reject" buttons to the back office user, since there is no active approval process for invoices
   11. End of flow

##### 6. The back office user closes an open invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE and there is an ACTIVE approval process for Invoices (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Open" from a program where the option "Request Invoice Authorization" is set to true and there is an active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays the "Edit" button
   4. The system displays the "Close" button
   5. The back office user presses the "Close" button
   6. The system opens no modal
   7. The system submits the invoice to the configured approval process
   8. The system changes the Invoice status to "Pending for Approval"
   9. The system refreshes the Invoice details page
   10. The system hides the "Edit and "Close" buttons
   11. The system displays the "Approve" and "Reject" buttons to the approver(s) set in the approval process
   12. End of flow

##### 7. The approver user rejects a pending for approval invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE and there is an ACTIVE Approval Process for Invoices (step 1 of basic flow)
   1. The approver user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" from a program where the option "Request Invoice Authorization" is set to true and there is an active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system verifies that the logged user is one of the Approvers in the Approval process
   4. The system displays the "Approve" and "Reject" buttons
   5. The approver user presses the "Reject" button
   6. The system opens a modal with the fields: "Reject Reason" and "Comments"
   7. The approver user selects one of the available options for the "Reject Reason" field
   8. The approver user fills in the "Comments" field 
   9. The approver user presses the "Save" button
   10. The system saves the "Reject Reason" option in the corresponding invoice field
   11. The system saves the "Comments" info both in the invoice and in the corresponding field in the Approval Process
   12. The system changes the Invoice status to "Rejected"
   13. The system refreshes the Invoice details page
   14. The system displays the Approval History containing all status changes of the invoice when submitted to the approval process
   15. The system displays for the "Comments" field, the "Reject Reason" and the "Comments" info concatenated
   16. The system hides the "Approve" and "Reject" buttons
   17. The system displays the "Reopen" button
   18. End of flow

##### 8. The approver user approves a pending for approval invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE and there is an ACTIVE Approval Process for Invoices (step 1 of basic flow)
   1. The approver user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" from a program where the option "Request Invoice Authorization" is set to true and there is an active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system verifies that the logged user is one of the Approvers in the Approval process
   4. The system displays the "Approve" and "Reject" buttons
   5. The approver user presses the "Approve" button
   6. The system opens a modal with the field "Comments"
   7. The administrator fills in the "Comments" field
   8. The administrator presses the "Save" button
   9. The system saves the "Comments" info both in the invoice and in the corresponding field in the Approval Process
   10. The system changes the Invoice status to "Approved"
   11. The system updates the “Approved Date” Field with the date/time of approval
   12. The system refreshes the Invoice details page
   13. The system displays the Approval History containing all status changes of the invoice when submitted to the approval process
   14. The system hides the "Approve" and "Reject" buttons
   15. The system displays the "Revert" and "Reprocess" buttons
   16. End of flow

##### 9. The back office user rejects a pending for approval invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE and there is NO active Approval Process for Invoices (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" from a program where the option "Request Invoice Authorization" is set to true and there is no active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays the "Approve" and "Reject" buttons
   4. The back office user presses the "Reject" button
   5. The system opens a modal with the fields: "Reject Reason" and "Comments"
   6. The back office user selects one of the available options for the "Reject Reason" field
   7. The back office user fills in the "Comments" field 
   8. The back office user presses the "Save" button
   9. The system saves the "Reject Reason" option in the corresponding invoice field
   10. The system saves the "Comments" info in the corresponding invoice field
   11. The system changes the Invoice status to "Rejected"
   12. The system refreshes the Invoice details page
   13. The system displays the Approval History containing only the most recent status change (approved or rejected) of the invoice
   14. The system displays for the "Comments" field, the "Reject Reason" and the "Comments" info concatenated
   15. The system hides the "Approve" and "Reject" buttons
   16. The system displays the "Reopen" button
   17. End of flow

##### 10. The back office user approves a pending for approval invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE and there is NO active Approval Process for Invoices (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" from a program where the option "Request Invoice Authorization" is set to true and there is no active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays the "Approve" and "Reject" buttons
   4. The back office user presses the "Approve" button
   5. The system opens a modal with the field "Comments"
   6. The back office user fills in the "Comments" field
   7. The back office user presses the "Save" button
   8. The system saves the "Comments" info in the corresponding invoice field
   9. The system changes the Invoice status to "Approved"
   10. The system updates the “Approved Date” Field with the date/time of approval
   11. The system refreshes the Invoice details page
   12. The system displays the Approval History containing only the most recent status change (approved or rejected) of the invoice
   13. The system hides the "Approve" and "Reject" buttons
   14. The system displays the "Revert" and "Reprocess" buttons
   15. End of flow

##### 11. The approver user rejects a pending for approval invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE and there is an ACTIVE Approval Process for Invoices (step 1 of basic flow)
   1. The approver user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" from a program where the option "Request Invoice Authorization" is set to false and there is an active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system verifies that the logged user is one of the Approvers in the Approval process
   4. The system displays the "Approve" and "Reject" buttons
   5. The approver user presses the "Reject" button
   6. The system opens a modal with the fields: "Reject Reason" and "Comments"
   7. The approver user selects one of the available options for the "Reject Reason" field
   8. The approver user fills in the "Comments" field 
   9. The approver user presses the "Save" button
   10. The system saves the "Reject Reason" option in the corresponding invoice field
   11. The system saves the "Comments" info both in the invoice and in the corresponding field in the Approval Process
   12. The system changes the Invoice status to "Rejected"
   13. The system refreshes the Invoice details page
   14. The system displays the Approval History containing all status changes of the invoice when submitted to the approval process
   15. The system displays for the "Comments" field, the "Reject Reason" and the "Comments" info concatenated
   16. The system hides the "Approve" and "Reject" buttons
   17. The system displays the "Reopen" button
   18. End of flow

##### 12. The approver user approves a pending for approval invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE and there is an ACTIVE Approval Process for Invoices (step 1 of basic flow)
   1. The approver user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" from a program where the option "Request Invoice Authorization" is set to false and there is an active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system verifies that the logged user is one of the Approvers in the Approval process
   4. The system displays the "Approve" and "Reject" buttons
   5. The approver user presses the "Approve" button
   6. The system opens a modal with the field "Comments"
   7. The approver user fills in the "Comments" field 
   8. The approver user presses the "Save" button
   9. The system saves the Comments info both in the invoice and in the corresponding field in the Approval Process
   10. The system changes the Invoice status to "Approved"
   11. The system updates the “Approved Date” Field with the date/time of approval
   12. The system refreshes the Invoice details page
   13. The system displays the Approval History containing all status changes of the invoice when submitted to the approval process
   14. The system hides the "Approve" and "Reject" buttons
   15. The system displays the "Revert" and "Reprocess" buttons
   16. End of flow

##### 13. The non approver user tries to approve or reject a pending for approval invoice that belongs to a program that has an ACTIVE Approval Process for Invoices (step 1 of basic flow)
   1. The non approver user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" when there is an active Approval Process for Invoices
   2. The system displays the Invoice details page
   3. The system displays no buttons
   4. End of flow  

##### 14. The back office user reverts an approved Invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Approved" from a program where the option "Request Invoice Authorization" is set to true
   2. The system displays the Invoice details page
   3. The system displays the "Revert" and "Reprocess" buttons
   4. The back office user presses the "Revert" button
   5. The system changes the Invoice status to "Canceled"
   6. The system reverts the related approval transaction
   7. The system refreshes the Invoice details page
   8. The system clears the Approval History
   9. The system hides the "Revert" button
   10. The system displays the "Reopen" button and maintains the "Reprocess" button
   11. End of flow

##### 15. The back office user reverts an approved Invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Approved" from a program where the option "Request Invoice Authorization" is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Revert" and "Reprocess" buttons
   4. The back office user presses the "Revert" button
   5. The system changes the Invoice status to "Canceled"
   6. The system reverts the related approval transaction
   7. The system refreshes the Invoice details page
   8. The system clears the Approval History
   9. The system hides the "Revert" button
   10. The system displays the "Reopen" button and maintains the "Reprocess" button
   11. End of flow

##### 16. The back office user reprocesses an approved Invoice that belongs to a program that has the option "Request Invoice Authorization" set to true (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Approved" from a program where the option "Request Invoice Authorization" is set to true
   2. The system displays the Invoice details page
   3. The system displays the "Revert" and "Reprocess" buttons
   4. The back office user presses the "Reprocess" button
   5. The system maintains the Invoice status in "Approved"
   6. The system reprocesses the invoice
   7. The system refreshes the Invoice details page
   8. The system maintains the "Revert" and "Reprocess" buttons
   9. End of flow

##### 17. The back office user reprocesses an approved Invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Approved" from a program where the option "Request Invoice Authorization" is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Revert" and "Reprocess" buttons
   4. The back office user presses the "Reprocess" button
   5. The system maintains the Invoice status in "Approved"
   6. The system reprocesses the invoice
   7. The system refreshes the Invoice details page
   8. The system maintains the "Revert" and "Reprocess" buttons
   9. End of flow

##### 18. The back office user reopens a rejected Invoice that belongs to a program that has the option "Request Invoice Authorization" set to true (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Rejected" from a program where the option "Request Invoice Authorization" is set to true
   2. The system displays the Invoice details page
   3. The system displays the "Reopen" button
   4. The back office user presses the "Reopen" button
   5. The system changes the Invoice status to "Open"
   6. The system refreshes the Invoice details page
   7. The system clears the Approval History
   8. The system hides the "Reopen" button
   9. The system displays the "Edit" and "Close" buttons
   10. End of flow

##### 19. The back office user reopens a rejected Invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Rejected" from a program where the option "Request Invoice Authorization" is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Reopen" button
   4. The back office user presses the "Reopen" button
   5. The system changes the Invoice status to "Open"
   6. The system refreshes the Invoice details page
   7. The system clears the Approval History
   8. The system hides the "Reopen" button
   9. The system displays the "Edit", "Close" and "Submit for Approval" buttons
   10. End of flow

##### 20. The back office user reopens a canceled Invoice that belongs to a program that has the option "Request Invoice Authorization" set to true (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Canceled" from a program where the option "Request Invoice Authorization" is set to true
   2. The system displays the Invoice details page
   3. The system displays the "Reopen" and "Reprocess" buttons
   4. The back office user presses the "Reopen" button
   5. The system changes the Invoice status to "Open"
   6. The system refreshes the Invoice details page
   7. The system clears the Approval History
   8. The system hides the "Reopen" button
   9. The system displays the "Edit" and "Close" buttons
   10. End of flow

##### 21. The back office user reopens a canceled Invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Canceled" from a program where the option "Request Invoice Authorization" is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Reopen" and "Reprocess" buttons
   4. The back office user presses the "Reopen" button
   5. The system changes the Invoice status to "Open"
   6. The system refreshes the Invoice details page
   7. The system clears the Approval History
   8. The system hides the "Reopen" button
   9. The system displays the "Edit", "Close" and "Submit for Approval" buttons
   10. End of flow

##### 22. The back office user reprocesses a canceled Invoice that belongs to a program that has the option "Request Invoice Authorization" set to true (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Canceled" from a program where the option "Request Invoice Authorization" is set to true
   2. The system displays the Invoice details page
   3. The system displays the "Reopen" and "Reprocess" buttons
   4. The back office user presses the "Reprocess" button
   5. The system reprocesses the invoice
   6. The system changes the Invoice status to "Approved"
   7. The system updates the “Approved Date” Field with the date/time of approval   
   8. The system refreshes the Invoice details page
   9. The system displays the "Revert" and "Reprocess" buttons
   10. End of flow

##### 23. The back office user reprocesses a canceled Invoice that belongs to a program that has the option "Request Invoice Authorization" set to FALSE (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Canceled" from a program where the option "Request Invoice Authorization" is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Reopen" and "Reprocess" buttons
   4. The back office user presses the "Reprocess" button
   5. The system reprocesses the invoice
   6. The system changes the Invoice status to "Approved"
   7. The system updates the “Approved Date” Field with the date/time of approval
   8. The system refreshes the Invoice details page
   9. The system displays the "Revert" and "Reprocess" buttons
   10. End of flow

##### 24. The back office user submits for approval a pending for approval invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE and there is an ACTIVE Approval Process for Invoices where a valid approver is manually set (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" from a program where the option "Request Invoice Authorization" is set to true and there is an active Approval Process for Invoices where the approver is set manually
   2. The system displays the Invoice details page
   3. The system displays the "Approve", "Reject" and "Submit for Approval" buttons
   4. The back office user presses the "Submit for Approval" button
   5. The system opens a modal with the field "User"
   6. The back office user selects a valid user from the available options for the "User" field
   7. The back office user presses the "Save" button
   8. The system submits the invoice to the configured approval process
   9. The system maintains the Invoice status in "Pending for Approval"
   10. The system refreshes the Invoice details page
   11. The system hides the "Submit for Approval" button
   12. The system displays the "Approve" and "Reject" buttons to the selected approver
   13. End of flow

##### 25. The back office user submits for approval a pending for approval invoice that belongs to a program that has the option "Request Invoice Authorization" set to TRUE and there is an ACTIVE Approval Process for Invoices where an invalid approver is manually set (step 1 of basic flow)
   1. The back office user selects, in the Invoices landing page, an invoice which status is "Pending for Approval" from a program where the option "Request Invoice Authorization" is set to true and there is an active Approval Process for Invoices where the approver is set manually  
   2. The system displays the Invoice details page  
   3. The system displays the "Approve", "Reject" and "Submit for Approval" buttons  
   4. The back office user presses the "Submit for Approval" button  
   5. The system opens a modal with the field "User"  
   6. The back office user selects no user or an invalid user from the available options for the "User" field  
   7. The back office user presses the "Save" button  
   8. The system displays an error message  
   9. End of flow
