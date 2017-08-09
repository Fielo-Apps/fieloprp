# PRP Functional Documentation
## 1. Creating the Invoice
Depending on how the Program is configured, there can be two types of Invoices:
 - **Invoice with products** - This option needs to be applied when the Administrator wants the members to inform the products that they are buying. In this case, the Program field *Request invoice products* must be set as "true".
 - **Invoice without products** - When the member doesn't need to inform the products he bought because what matters in this case is the Amount value. For this option, the Program field *Request invoice products* must be set as "false".

1.1. **Invoice with products**
For a Program where the *Request invoice products* was set to "true", when the Administrator goes to the Invoices Landing Page and clicks the New button, s/he will find 3 (three) sessions, containing the fields below:

*Invoice Information* - general information regarding the invoice
 - **Member** - For this field, the Administrator must select the invoice owner Member. He can type part of the member's name. The complete name of the member will be displayed in the list. The Administrator selects the member by clicking its name.
 > At CMS, the member is automatically set to the member that is logged in.
 - **Invoice Number** - This is the identification number of the invoice. This field has a maximum limit of 80 characters.
 - **Date** - This is the date of the invoice and is a required field. It cannot contain a date in the future.
 - **Description** - This field has a maximum limit of 255 characters.
 - **Distributor** - For this field, the Administrator selects the Distributor by  typing part of the Distributor's name. The complete name of the Distributor will be displayed in the list. The Administrator selects the Distributor by clicking its name.  

*Product Items* - details of items in the invoice  
At this point, there are two ways of including the invoice items:  
     - Directly on this product items area - if the Administrator has few items to include and knows how to easily find them by typing their names;  
     - Using the Add Products page - where s/he can have the possibility to make an advanced search of products.
 
When including the products directly from the items area, the Administrator must fill in the following fields:
- **Quantity** - This field represents the the product item quantity and is required.
- **Product** - Here the Administrator can type part of the product name. The complete name of the product will be displayed in the list and s/he selects the product by clicking its name.
- **Unit Price** - 
- 
:point_right: To add new products, just press the New button. A new line will be created where the fields above need to be filled as well.  
:point_right: If a line needs to be deleted, just press the *remove* icon (:heavy_multiplication_x:) in its right side.

When including the products directly from the items area, the Administrator must fill in the following fields:  

*Upload Files* - invoice images

1.2. **Invoice without products**  
For a Program where the *Request invoice products* was set to "false", when the Administrator goes to the Invoices Landing Page and clicks the New button, s/he will find 2 (two) sessions, containing the fields below:
