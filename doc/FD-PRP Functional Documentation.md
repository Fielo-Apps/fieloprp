# PRP Functional Documentation
## 1. Creating the Invoice
Depending on how the Program is configured, there can be two types of Invoices:  

:black_medium_small_square: **Invoice with products** - This option needs to be applied when the Administrator wants the members to inform the products that they are buying. In this case, the Program field *Request invoice products* must be set as "true".  
:black_medium_small_square: **Invoice without products** - When the member doesn't need to inform the products he bought because what matters in this case is the Amount value. For this option, the Program field *Request invoice products* must be set as "false".

### 1.1. **Invoice with products**
For a Program where the *Request invoice products* was set to "true", when the Administrator goes to the Invoices Landing Page and clicks the *New* button, s/he will find 3 (three) sessions, containing the fields below:

#### *Invoice Information* - general information regarding the invoice
 - **Member** - For this field, the Administrator must select the invoice owner Member. He can type part of the member's name. The whole name of the member will be displayed as one of the results in the list below the field. The Administrator selects the member by clicking its name.
 - **Invoice Number** - This is the identification number of the invoice. This field has a maximum limit of 80 characters.
 - **Date** - This is the date of the invoice and is a required field. It cannot contain a date in the future.
 - **Description** - This field has a maximum limit of 255 characters.
 - **Distributor** - For this field, the Administrator selects the Distributor by typing part of the its name. The whole name of the Distributor will be displayed as one of the results in the list below the field. The Administrator selects the Distributor by clicking its name.  

:point_right: The upload of duplicate invoices for the same distributor (same combination of Distributor + Invoice Number) is allowed. However, once the first invoice is approved, it will not be possible to approve the second one.

#### *Product Items* - details of items in the invoice  
At this point, there are two ways of including the invoice items:  

:black_medium_small_square: *Add products one at a time* - If the Administrator has few items to include and knows how to easily find them by typing their names, s/he can do it directly from the product items area;  
:black_medium_small_square: *Add a set of products* - When the Administrator needs to add a big quantity of products, s/he has the possibility to make an advanced search using the *Add Products* page.
 
##### Adding products one at a time
When including the products directly from the items area, the Administrator must fill in the following fields:
- **Quantity** - This field represents the product items quantity. This is a required field and must be greater than zero.
- **Product** - Here the Administrator can type part of the product name. The product whole name will be displayed as one of the results in the list and s/he selects the product by clicking its name.
- **Unit Price** - The value of one product item. If left blank, will be determined by the division of Total Price by the Quantity.
- **Total Price** - This field is automatically calculated based on quantity multiplied by unit price.
- **Amount** - Total invoice value. This field is automatically filled by the system.

:point_right: To add new products, just press the *New* button. A new line will be created where the fields above need to be filled as well.  
:point_right: If a line needs to be deleted, just press the *remove* icon (:heavy_multiplication_x:) in its right side.

##### Adding a set of products
To include a set of products, press the *Add Products* button. When including the products from the *Add Products* page, the Administrator has many possibilities:  
- ###### **Filter by Product Name**
The Administrator types any part of the product name and presses the *Search* button. In the results area, there will be displayed all the products which have the given text as part os their names.  
Then, by marking the checkbox beside each desired product, they are ready to compose the product items list. To do this, simply press the *Add* button.  
The next step is to provide quantities and prices, as explained when adding products one at a time.

- ###### **Filter by Product Family**
Filter the products by selecting a Family, so only the products belonging to the selected family are displayed in the results list.  
The same way as previously mentioned, press the *Search* button, mark the checkbox beside each desired product and they will be ready to compose the product items list. Press the Add button.  
The next step is to provide quantities and prices.

- ###### **Filter by Product Code**
The Administrator types any part of the product code and presses the *Search* button. In the results area, there will be displayed all the products which have the given text as part of their codes.
Once more, mark the checkbox beside each desired product, press the *Add* button and provide quantities and prices.

It's possible to combine all the filters above in order to have an even more refined search.

#### *Upload Files* - invoice images  
The Administrator may need to validate the invoice info. Therefore, it should be nice to have the invoice image.  
It can be uploaded as a single image or, if it's very long, split into more than one image. For each piece of image to be uploaded, the Administrator presses the *New* button.  
Possible extension files are: gif, jpg and png.

### 1.2. **Invoice without products**  
For a Program where the *Request invoice products* was set to "false", when the Administrator goes to the Invoices Landing Page and clicks the *New* button, s/he will find 2 (two) sessions, containing the fields below:

#### *Invoice Information* - general information regarding the invoice
 - **Member** - For this field, the Administrator must select the invoice owner Member. He can type part of the member's name. The whole name of the member will be displayed as one of the results in the list below the field. The Administrator selects the member by clicking its name.
 - **Invoice Number** - This is the identification number of the invoice. This field has a maximum limit of 80 characters.
 - **Amount** - The total value of the invoice. Since in this Program configuration the list of products is not required, the invoice total value is not automatically calculated, so this field must be filled in.
 - **Date** - This is the date of the invoice and is a required field. It cannot contain a date in the future.
 - **Description** - This field has a maximum limit of 255 characters.
 - **Distributor** - For this field, the Administrator selects the Distributor by typing part of the its name. The whole name of the Distributor will be displayed as one of the results in the list below the field. The Administrator selects the Distributor by clicking its name.    
 
:point_right: The upload of duplicate invoices for the same distributor (same combination of Distributor + Invoice Number) is allowed, but once the first invoice is approved, it will not be possible to approve the second one.
 
#### *Upload Files* - invoice images  
The Administrator may need to validate the invoice info. Therefore, it should be nice to have the invoice image.  
It can be uploaded as a single image or, if it's very long, split into more than one image. For each piece of image to be uploaded, the Administrator presses the *New* button.  
Possible extension files are: gif, jpg and png.

> The invoice can be created from both the back end, which creation process was described in this item or the front end. When using the CMS in order to create the invoice from the front end, the creation process is very similar having the Member field automatically set to the member that is logged in.

## 2. Changing the Invoice Status
The invoice status flow diagram is shown below:  
![image](https://user-images.githubusercontent.com/26011197/29170990-41efae76-7db1-11e7-922c-314313eac673.png)  
First of all, it's important to understand how the program is configured. Depending on its configuration, the invoice status can follow different ways.  

:black_medium_small_square: **Approval process is mandatory** - This means that, to be approved, it will be automatically sent to an approval process defined for it. In this case, the Program field *Request invoice authorization* must be set as "true".  
:black_medium_small_square: **Approval process is optional** - In this case, the invoice approval may happen immediately on a first stage. For this option, the Program field *Request invoice authorization* must be set to "false".  

Let's go to each status and see how they can be changed.  
- **Open** - It's the invoice first status when adopting the back end creation. When in this status, the invoice can follow two possible ways.  
\- If the Program configuration has the *Request invoice authorization* set to "true", the *Close* action will send the invoice to the established approval process where it will be analyzed by the person or the group of persons defined by the approval process. The invoice status changes to *Pending for Approval*, while waiting for the approvers to analyze it.   
\- If the Program configuration has the *Request invoice authorization* set to "false", the *Close* action allows the Program Administrator to immediately approve the Invoice, changing its status to *Approved*.  

:point_right: In this last case, even if the Administrator can promptly approve the invoice, doubts may arise regarding the veracity of its information. To solve this, the administrator still has the option of sending the invoice to an approval process, provided there is one configured for the program, executing the "Submit for approval" action.  

- **Pending for Approval** - This is the invoice status while waiting for the approver analysis. The approver may approve it, which cahnges the invoice status to *Approved* or reject it, which changes the invoice status to *Rejected*.  

- **Aproved** - It means that the invoice didn't present any inconsistency when analyzed either by the Administrator or the approver and was validated.  
:point_right: If, for any reason, the invoice was improperly approved, it can have its status changed to *Canceled* by taken the *Revert* action.

- **Rejected** - When analyzed by the approver, any inconsistency were found, preventing the invoice from being validated.  
:point_right: It's possible to restart the process as soon as the inconsistencies are eliminated by taking the *Reopen* action. After this, the invoice status returns to *Open*.

- **Canceled** - The invoice status after the reversion of its *Approved* status.  
:point_right: If improperly reverted, the invoice can return to its *Approved* status by taking the *Reprocess* action.  
:point_right: In case the invoice have the possibility to be reanalyzed, it can have its process restarted by taking the *Reopen* action, which takes the invoice back to *Open* status.

- **New** - It's the invoice first status when employing the front end creation. When members upload their invoices on the portal, ...

