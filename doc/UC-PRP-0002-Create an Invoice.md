## Create an Invoice

### Objectives 
This use case describes the creation of an Invoice

### Preconditions
The administrator must be logged in

### Postconditions
An Invoice is created

### Flow of Events

### Basic Flow

1. The system receives the information for the invoice and for the invoice items 
2. The system verifies that Member field is not null
3. The system verifies that the option "Request Invoice Products" of the related member's program is set to true and that the Amount field is null
4. The system verifies that the Date field is not null
5. The system verifies that there is no other invoice with the same combination number (Distributor Id + Invoice Number) in status Approved
6. The system sets the status "Open" for the Invoice
7. The system saves the Invoice
8. The system calls the use case [Create an Invoice Item](https://github.com/FieloIncentiveAutomation/fieloprp/blob/develop/doc/UC-PRP-0001-Create%20an%20Invoice%20Item.md)
9. The system updates the Amount field ot the invoice with the summarize of the Total Price field of the related Invoice Items 
10. The system saves the Invoice
11. The system displays the invoice detail page with the options to Edit or Delete
12. End of flow

### Alternative flows

##### 1. The option "Request Invoice Products" is set to false and the Amount field is not null (step 3 of the basic flow)
   1. The system verifies that the option "Request Invoice Products" of the related member's program is set to false
   2. The system verifies that the Amount field is not null
   3. The system verifies that the Date field is filled with a date equal or prior to the current date
   4. The system verifies that there is no other invoice with the same combination number (Distributor Id + Invoice Number) in status Approved.
   5. The system sets the status "Open" for the Invoice
   6. The system saves the Invoice
   7. The system does not allow the creation of invoice items
   8. End of flow

##### 2. The administrator deletes the invoice (step 11 of the basic flow)
   1. The administrator selects the option to Delete the Invoice
   2. The system deletes the invoice and all its related Invoice items
   3. End of flow

##### 3. The Amount field is not null when the option "Request Invoice Products" is true (step 3 of the basic flow)
   1. The system verifies that the option "Request Invoice Products" is set to true
   2. The system verifies that the Amount field is not null
   3. The system does not create the invoice
   4. The system displays an error message
   5. End of flow
   
##### 4. The Member field is null (step 2 of the basic flow)
   1. The system verifies that the Member field is null
   2. The system does not create the invoice
   3. The system displays an error message
   4. End of flow

##### 5. The administrator tries to edit the Member Lookup (step 11 of the basic flow)
   1. The administrator presses the Edit button in the detail view of the Invoice
   2. The administrator changes the Member of the invoice
   2. The administrator presses the Save button
   3. The system does not update the invoice
   4. The system displays an error message
   5. End of flow

##### 6. The administrator tries to edit the Invoice when its status is not Open or New (step 7 of the basic flow)
   1. The administrator presses the Edit button in the detail view of the Invoice
   2. The administrator tries to edit the Amount or Invoice Number or Date fields
   3. The administrator presses the Save button
   4. The system verifies that the status of the Invoice is not "Open" or "New"
   5. The system does not update the invoice
   6. The system displays an error message
   7. End of flow
   
##### 7. The date field is null (step 4 of basic flow)
   1. The system verifies that the Date field is null
   2. The system does not create the invoice
   3. The system displays an error message
   4. End of flow
   
##### 8. There is already an invoice with the same combination (Invoice Number + Distributor) in status approved (step 5 of basic flow)
   1. The system verifies that there is another invoice with the same combination number (Distributor Id + Invoice Number) in status Approved
   2. The system does not create the invoice
   3. The system displays an error message
   4. End of flow
   
##### 9. Date field is later than the current date (step 4 of basic flow)
   1. The system verifies that the Date field is filled with a date later than the current date
   2. The system does not create the invoice
   3. The system displays an error message
   4. End of flow
