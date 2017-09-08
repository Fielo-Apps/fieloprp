# Fielo Proof of Purchase Feature: _Product Flexibility_
## Intro
The Fielo's Proof of Purchase (**FieloPRP**) has a functionality called _Product Flexibility_ that enables developers, consultants or administrators to change the Product object used by the Proof of Purchase App.
By default the object used by the Proof of Purchase App is the **Product2** object that comes with Salesforce. If the customer wants to use another object just follow the following Tutorial. This procedure must be done in both _Backend_ and _Frontend_.

This Tutorial will use as example one object called ExternalProduct__c to be used as the new Proof of Purchase product object.

## 1. First Step
Both _Backend_ and _Frontend_ are using the same Custom Settings to discover which product object is being used. To change that just go to:

> **Setup** > **Develop** > **Custom Settings** > **Custom Settings:** Public Settings (FieloPLT Namespace)

Then click on the "**Manage**" button.

In the section "**Default Organization Level Value**" click Edit or New if there is nothing defined.

Edit the field "**Product Lookup Field**" and put as its value the ApiName of the Field in the Invoice Items Object (FieloPRP__InvoiceItem__c) that points to the custom product object.

> ![Public Settings Edit](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/ScreenHunter_01%20Aug.%2030%2011.45.gif?raw=true)

Hit Save.

With this the First Step is completed.

## 2. Backend
2.1. The field being used by the Invoice Item to reference the product and the fieldsets of the product advanced search are controlled by Page Settings.
The Standard Page Settings Section Field for the Invoice Edit/New looks like the following:

> [Invoice Edit Page Settings](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/PageSettings.json)

There you will find 3 sections:

- **FieloPRP_Product** : Controls the fields displayed in the advanced search section

> ![FieloPRP_Product](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/product.gif?raw=true)

Controls:
> ![Advanced Product Search Section](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/advanced_search_section.gif?raw=true)

- **FieloPRP_ProductRecent** : Controls the fields displayed in the recent records results of the advanced search

> ![FieloPRP_ProductRecent](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/product_recent.gif?raw=true)

Controls:
> ![Advanced Search Recent](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/advanced_search_recent.gif?raw=true)

- **FieloPRP_InvoiceItems** : Controls the fields displayed in the Items section of the Invoice Form

> ![FieloPRP_InvoiceItems](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/items.gif?raw=true)

Controls:
> ![Invoice Items](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/items_section.gif?raw=true)

We recomend using some advanced text editor tool to change the JSON. In order to put the new object we can do the following:

From:
> ![FieloPRP_Product](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/product.gif?raw=true)

to:
> ![FieloPRP_Product](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/external_prod.gif?raw=true)

Where **Family__c** and **Description__c** are fields from the new product object.

From:
> ![FieloPRP_ProductRecent](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/product_recent.gif?raw=true)

to:
> ![FieloPRP_ProductRecent](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/external_prod_recent.gif?raw=true)

Where **Family__c** and **Description__c** are fields from the new product object.

From:
> ![FieloPRP_InvoiceItems](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/items.gif?raw=true)

to:
> ![FieloPRP_InvoiceItems](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/external_prod_item.gif?raw=true)

Where **External_Product__c** is the field from **Invoice Items** that is a Lookup for the new product object.

Now we should save the new JSON somewhere in our PC and we go to:

> **Fielo Platform** App > **Libraries** Tab > **FieloPRP** Library > "**Invoice > New**" and "**Invoice > Edi**t" page settings

In these two page settings paste the content of the new JSON in the field Sections like this:

> ![Edit Section Field](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/edit_section.gif?raw=true)

Save the changes in both Page Settings.

Now you should be able to see and create new invoices with the new product object! :smile:

**Example**:

Items:

> ![Items](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/external_prod_items.gif?raw=true)

Product search:

> ![Product search](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/external_prod_serarch.gif?raw=true)

Product results:

> ![Product results](https://github.com/tibeal/Fielo-Tutorials/blob/master/FieloPRP/Source/external_prod_results.gif?raw=true)

Change page settings for all pages that display product items!

2.2 On the Invoices landing Page, it is necessary to change the *Products* link (Tools > Products).  
In the *Invoice > Landing* page settings, look for the field named *Tools*  
![image](https://user-images.githubusercontent.com/26011197/30133186-4f5ad0a8-9329-11e7-8819-4a92b11e1ab1.png)  
Change the Action url string to the one corresponding to the new product list. See the example below:  

![image](https://user-images.githubusercontent.com/26011197/30133818-8c1e33a2-932b-11e7-93ae-4bf04ebf30c7.png)  


![image](https://user-images.githubusercontent.com/26011197/30133439-4263e320-932a-11e7-8452-81229fa660f1.png)  
After clicking the new Products link, you'll be able to see the custom product list.  


## 3. Frontend
In order to use the custom Product object in Frontend, make the following settings:

### 3.1 Site Permissions
1. From Setup, go to Build -> Develop -> Sites
2. Click on the Site label then click the *Public Access Settings* button
3. Go to *Field-Level Security* -> *Custom Field-Level Security* and click the *View* link beside your custom product object
4. Clink the *Edit* button
5. Give *Read Access* permission to all fields and *Edit Access* permission to the allowed fields. Save the settings.

### 3.2 Fielo Member Permissions
1. From Setup, go to *Manage Users* -> *Profiles* and click on *Fielo Member Site* profile
2. Go to *Field-Level Security* -> *Custom Field-Level Security* and click the *View* link beside your custom product object
3. Clink the *Edit* button
4. Give *Read Access* permission to all fields. Save the settings.
5. Go back to *Fielo Member Site* profile
6. Go to *Custom Object Permissions* and give *Read* access to the custom product object

### 3.3 Avoiding Products to be shown as links
Do this to prevent the product from displaying with a link on the invoice detail page.
1. In the *Invoice Item* object, create a new field from type *Formula*
2. Assign it a label and a name, removing all the underline characters from its *Name* field (CamelCase notation)
3. Set the *Formula Return Type* to *Text*
4. In the Formula field (Advanced Formula tab), click the *Insert Field* button, select the field as shown in the example below e clink *Insert*.
![image](https://user-images.githubusercontent.com/26011197/29893757-7eb90be2-8da9-11e7-9db2-e88dd52e0ba0.png)
5. In the next page, make it visible for all profiles
6. Click *Next* then *Save*

### 3.4 New Component for the custom Product 
1. Go to Fielo CMS *Plugins* tab
2. Select the option *Local* on the right up corner
3. Press the *New* button
4. Create the new component with the following settings:

        Component Type = List
        Name = <component name>
        Layout = table
        Object = <the custom object created for the new products>
        Data Class = FieloCMS.StandardAPI
        Components Fields = <add the desired fields>

### 3.5 Site settings 
1. Go to Fielo CMS *Sites* tab
2. Hit the *Invoice Upload Settings* page
3. Add the new list component created in 3.4
4. Change its name as desired, include in the fieldset the fields to be displayed for the products and *Save*
5. Still on the *Invoice Upload Settings page*, edit the *Invoice Items* component by changing the "Product Name" field by the corresponding field of the new object. Save it.
6. On *Invoice Detail* page, replace the *Product Name* field by the Formula field created in 3.3
7. On *Invoice Upload* page, edit the widget component, changing the Product Source Component from the old list to the new one created in 3.4.

Thanks!

**_That's all Folks!_** :rabbit:
