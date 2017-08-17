## Display Invoices Landing Page

### Objectives
The present use case describes the display of the Invoices landing page

### Preconditions
The administrator must be logged in

### Postconditions
Invoices for the selected Program and View were displayed

### Flow of Events

### Basic Flow
1. The administrator accesses the Invoices tab 
2. The system displays the Invoices landing page containing the following items:
   - Recent View (with the option to select the All view)
   - Program selector
   - New button
   - Tools button (with the options Settings and Products)
   - Invoices list
3. The system displays in the picklist for Programs all the existing Programs for selection
4. The system displays for the Invoice list the columns according to the fieldset set for the landing page
5. End of flow

### Alternative Flows

##### 1. The administrator selects the option Products in the Tools button (step 2 of the basic flow)
   1. The administrator clicks the Tools button and selects the option Products
   2. The system displays the Products page in the classic view
   3. End of flow 
   
##### 2. There is only one Program available (step 2 of the basic flow)
   1. The system does not display the picklist for Program selection
   2. End of flow
   
##### 3. The administrator changes the Program (step 3 of the basic flow)
   1. The administrator changes the Program in the picklist
   2. The system displays the list of the Invoices of the selected Program
   3. End of flow
   
##### 4. The administrator selects an Invoice of the list (step 5 of the basic flow)
   1. The administrator selects an Invoice
   2. The system calls the Use Case [*Display Invoice Details*](https://github.com/FieloIncentiveAutomation/fieloprp/blob/develop/doc/UC-PRP-0005-Display%20Invoice%20Details%20Page.md)
   3. End of flow
