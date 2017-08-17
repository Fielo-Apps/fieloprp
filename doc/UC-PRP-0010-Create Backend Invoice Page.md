## Create Backend Invoice Page

### Objectives
The present use case describes how the system creates an Invoice through the backend page

### Preconditions
The administrator must be logged in

### Postconditions
The Invoice was created

### Flow of Events

### Basic Flow
1. The administrator goes to the Invoices tab
2. The system shows the Invoices landing page
3. The administrator selects a Program that requests invoice products
4. The administrator presses the New button
5. The system displays the New Invoice page
6. The system displays the fieldset defined for the New Invoice page, with its fields blank
7. The system displays the Items area, containing:
   - Add Products button to search products in advanced mode
   - New button to insert a new item line
   - Item lines to insert products information with the fields Quantity, Product, Unit Price and Total price.
   - For each item line, a corresponding Remove icon
   - Amount field that summarizes the Total Price of all inserted products
8. The system displays the option to upload an image for the Invoice
9. The system displays the Save and Cancel buttons 
10. The administrator fills the invoice fields
11. The administrator starts typing in the product field
12. The system displays the products that match the typed text
13. The administrator selects the product
14. The administrator fills the quantity and price fields
15. The administrator presses the New button
16. The system displays a new item line with its corresponding Remove icon
17. The administrator selects the product
18. The administrator fills the quantity and price fields
19. The administrator uploads the image
20. The administrator presses the Save button 
21. The system calls the Use Case [*Create Invoice*](https://github.com/FieloIncentiveAutomation/fieloprp/blob/develop/doc/UC-PRP-0002-Create%20an%20Invoice.md)
22. The system displays the Invoice detail page
23. End of flow

### Alternative Flows

##### 1. The administrator selects a Program that does not request invoice products (step 3 of basic flow)
   1. The administrator presses the New button
   2. The system displays the New Invoice page
   3. The system displays the fieldset defined for the New Invoice page, with its fields blank
   4. The system displays the option to upload an image for the Invoice
   5. The system displays the Save and Cancel buttons
   6. The administrator fills the invoice fields
   7. The administrator uploads the image
   8. The administrator presses the Save button
   9. The system calls the Use Case [*Create Invoice*](https://github.com/FieloIncentiveAutomation/fieloprp/blob/develop/doc/UC-PRP-0002-Create%20an%20Invoice.md)
   10. The system displays the Invoice detail page
   11. End of flow
   
##### 2. The administrator presses the Add Products button (step 7 of basic flow)
   1. The system displays the Add products page
   2. The system displays a filter area where product fields are used to search, according to the defined fieldset
   3. The system displays a Search button
   4. The system displays a results area where the products that fit the search are listed
   5. The system displays the buttons “Cancel” and “Add” 
   6. The administrator fills the filters fields
   7. The administrator presses the Search button
   8. The system lists, in the results area, the products that fit the search
   9. The system shows, for each line of product, its data disposed in columns defined by the fieldset and a checkbox to select the product
  10. The administrator selects one or more products in the results area by marking each of their checkboxes or by marking the checkbox beside the Name column
   11. The administrator presses the Add button
   12. The system returns to New Invoice page where all the products selected are shown in one or more lines
   13. The administrator fills quantities and prices for the selected items
   14. Back to step 19 of basic flow
   
##### 3. The administrator deletes an item (step 16 of basic flow)
   1. The administrator presses the delete button beside an item line
   2. The system removes the line from the list
   3. Back to step 19 of basic flow
   
##### 4. The administrator cancels the invoice creation (step 20 of basic flow)
   1. The administrator presses the Cancel button 
   2. The system ignores all the inputted values and does not create the invoice
   3. The system returns to the Invoices landing page
   4. End of flow

##### 5. The administrator edits an Open Invoice with details (step 22 of basic flow)
   1. The administrator selects an invoice in the landing page which status is "Open"
   2. The system displays the Invoice details page
   3. The administrator presses the Edit button
   4. The system displays the Edit Invoice page
   5. The system displays the fieldset of the Invoice view, with its fields already filled with the invoice saved data
   6. The system displays the list of products for the invoice with their fieldset already filled
   7. The system displays the uploaded image for the Invoice
   8. The system displays the buttons Cancel and Save
   9. The administrator makes the desired changes
   10. The administrator presses the Save button 
   11. The system calls the Use Case [*Create Invoice*](https://github.com/FieloIncentiveAutomation/fieloprp/blob/develop/doc/UC-PRP-0002-Create%20an%20Invoice.md)
   12. The system returns to the Invoice Details Page
   13. End of flow

##### 6. The administrator edits a Open Invoice without details (step 10 of alternative flow 1)
   1. The administrator selects an invoice in the landing page which status is "Open"
   2. The system displays the Invoice details page
   3. The administrator presses the Edit button
   4. The system displays the Edit Invoice page
   5. The system displays the fieldset of the Invoice view, with its fields already filled with the invoice saved data
   6. The system displays the uploaded image for the Invoice
   7. The system displays the buttons Cancel and Save
   8. The administrator makes the desired changes
   9. The administrator presses the Save button 
   10. The system calls the Use Case [*Create Invoice*](https://github.com/FieloIncentiveAutomation/fieloprp/blob/develop/doc/UC-PRP-0002-Create%20an%20Invoice.md)
   11. The system returns to the Invoice Details Page
   12. End of flow
   
##### 7. Member field is null (step 10 of basic flow)
   1. The administrator does not fill the Member field
   2. The administrator correctly fills the remaining fields
   3. The administrator presses the Save button
   4. The system does not create the invoice
   5. The system displays an error message
   6. End of flow
   
##### 8. Date field is null (step 10 of basic flow)
   1. The administrator does not fill the Date field
   2. The administrator correctly fills the remaining fields
   3. The administrator presses the Save button
   4. The system does not create the invoice
   5. The system displays an error message
   6. End of flow
   
##### 9. There is already an invoice with the same combination (Invoice Number + Distributor) in status approved (step 10 of basic flow)
   1. The administrator fills the Invoice Number and Distributor fields with the same values of an already approved invoice
   2. The administrator correctly fills the remaining fields
   3. The administrator presses the Save button
   4. The system does not create the invoice
   5. The system displays an error message
   6. End of flow
 
##### 10. Product field is not filled (step 13 of basic flow)
   1. The administrator does not fill the Product field
   2. The administrator correctly fills the remaining fields
   3. The administrator presses the Save button
   4. The system does not create the invoice
   5. The system displays an error message
   6. End of flow
   
##### 11. Quantity field is not filled (step 14 of basic flow)
   1. The administrator does not fill the Quantity field
   2. The administrator correctly fills the remaining fields
   3. The administrator presses the Save button
   4. The system does not create the invoice
   5. The system displays an error message
   6. End of flow
   

