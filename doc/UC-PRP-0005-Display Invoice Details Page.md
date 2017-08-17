## Display Invoice Details Page

### Objectives
The present use case describes how the system shows the Invoice details and the action buttons for each invoice status

### Preconditions
- There must be Invoices created for Programs that request invoice authorization and for Programs that do not request invoice authorization
- There must be Invoices created for Programs that request invoice products and for Programs that do not request invoice products
- There must be Invoices in all status (Open, Pending for Approval, Approved, Rejected and Canceled) for each Program
- The administrator must be logged in

### Postconditions
- The system displayed the details of the selected Invoice
- The system displayed the corresponding action buttons for each Invoice Status

### Flow of Events

### Basic Flow
1. The administrator presses the Invoices tab
2. The system shows the Invoices landing page
3. The administrator selects an invoice which status is "Open" belonging to a Program that requests invoice authorization and requests invoice products
4. The system displays the Invoice details page, containing:
   - Edit button
   - Close button
   - Tools button (with the options View and Settings)
   - Fieldset for the Invoice view
   - Related list of invoice items
   - Related list of Transactions
   - Images of the invoice
   - Approval process steps
6. The system displays for each related list its defined fieldset
5. End of flow

### Alternative Flows

##### 1. The administrator selects an Invoice which status is “Pending for Approval” belonging to a Program that requests invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Record locked icon
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps containing link to Approve or Reject the invoice
   2. The system displays for each related list its defined fieldset      
   3. End of flow
   
##### 2. The administrator selects an Invoice which status is "Approved" belonging to a Program that requests invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Revert button
      - Reprocess button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
    2. The system displays for each related list its defined fieldset
    3. End of flow
    
##### 3. The administrator selects an Invoice which status is "Rejected" belonging to a Program that requests invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Reopen button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for each related list its defined fieldset
   3. End of flow

##### 4. The administrator selects an Invoice which status is "Canceled" belonging to a Program that requests invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Reopen button
      - Reprocess button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for each related list its defined fieldset
   3. End of flow
   
##### 5. The administrator selects an Invoice which status is “Open” belonging to a Program that requests invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Edit button
      - Close button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow

##### 6. The administrator selects an Invoice which status is "Pending for Approval" belonging to a Program that requests invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Record locked icon
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps containing link to Approve or Reject the invoice
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow

##### 7. The administrator selects an Invoice which status is "Approved" belonging to a Program that requests invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Revert button
      - Reprocess button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow
   
##### 8. The administrator selects an Invoice which status is "Rejected" belonging to a Program that requests invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Reopen button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow
   
##### 9. The administrator selects an Invoice which status is "Canceled" belonging to a Program that requests invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Reopen button
      - Reprocess button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow
   
##### 10. The administrator selects an Invoice which status is “Open” belonging to a Program that does not request invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Edit button
      - Close button
      - Submit for approval button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for each related list its defined fieldset      
   3. End of flow
   
##### 11. The administrator selects an Invoice which status is "Pending for Approval" belonging to a Program that does not request invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Record locked icon
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps containing link to Approve or Reject the invoice
   2. The system displays for each related list its defined fieldset
   3. End of flow
   
##### 12. The administrator selects an Invoice which status is "Approved" belonging to a Program that does not request invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Revert button
      - Reprocess button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for each related list its defined fieldset
   3. End of flow
   
##### 13. The administrator selects an Invoice which status is "Rejected" belonging to a Program that does not request invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Reopen button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for each related list its defined fieldset
   3. End of flow

##### 14. The administrator selects an Invoice which status is "Canceled" belonging to a Program that does not request invoice authorization and requests invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Reopen button
      - Reprocess button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of invoice items
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for each related list its defined fieldset
   3. End of flow
   
##### 15. The administrator selects an Invoice which status is “Open” belonging to a Program that does not request invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Edit button
      - Close button
      - Submit for approval button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow
   
##### 16. The administrator selects an Invoice which status is "Pending for Approval" belonging to a Program that does not request invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Record locked icon
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps containing link to Approve or Reject the invoice
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow
   
##### 17. The administrator selects an Invoice which status is "Approved" belonging to a Program that does not request invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Revert button
      - Reprocess button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow
   
##### 18. The administrator selects an Invoice which status is "Rejected" belonging to a Program that does not request invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Reopen button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow
   
##### 19. The administrator selects an Invoice which status is "Canceled" belonging to a Program that does not request invoice authorization and does not request invoice products (step 3 of basic flow)
   1. The system displays the Invoice details page, containing:
      - Reopen button
      - Reprocess button
      - Tools button (with the options View and Settings)
      - Fieldset for the Invoice view
      - Related list of Transactions
      - Images of the invoice
      - Approval process steps
   2. The system displays for the Transactions related list its defined fieldset
   3. End of flow
