@isTest
public class TestCreateInvoiceItem {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    private static void createPrograms() {
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;
    }

    private static void createMembers(){
        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;
    }

    private static void createInvoice(){
        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;
    }

    /* TEST-1555
       Create an Invoice Item 
       - Total Price Calculation 
       - Quantity and Unit Price fields are filled
    */
    @isTest static void PRP_0001_FB() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        List<InvoiceItem__c> items = new List<InvoiceItem__c>();

        items.add( new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            )
        );

        items.add( new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        );

        
        Test.startTest();

        insert items;

        Test.stopTest();        

        //Then
        System.assertEquals(2, [Select Id From InvoiceItem__c].size());
        System.assertEquals(750.0, ((List<InvoiceItem__c>)[Select Id, TotalPrice__c From InvoiceItem__c])[0].TotalPrice__c.setScale(1));
    }

    /*  TEST-1556
        Create an Invoice Item 
        - Unit Price Calculation
        - Quantity and Total Price fields are filled
    */
    @isTest static void PRP_0001_FA1() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            TotalPrice__c = 70.0
        );

        
        Test.startTest();

        insert item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(7.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c.setScale(1));
    }

    /*  TEST-1557
        Create an Invoice Item 
        - Quantity Calculation
        - Unit Price and Total Price fields are filled
    */
    @isTest static void PRP_0001_FA2() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            UnitPrice__c = 10.0,
            TotalPrice__c = 100.0
        );

        
        Test.startTest();

        insert item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
    }

    /*  TEST-1558
        Create an Invoice Item 
        - Total Price Recalculation
        - Quantity, Unit Price and Total Price fields are filled
    */
    @isTest static void PRP_0001_FA3() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 15.0,
            UnitPrice__c = 50.0,
            TotalPrice__c = 1000.0
        );

        
        Test.startTest();

        insert item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(750.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1559
        Create an Invoice Item
        - Total Price kept
        - Only Total Price field is filled
    */
    @isTest static void PRP_0001_FA4() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            TotalPrice__c = 1000.0
        );

        
        Test.startTest();

        insert item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(1000.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1560
        Create an Invoice Item
        - Only Quantity field is filled
    */
    @isTest static void PRP_0001_FA5(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 100.0
        );

        
        Test.startTest();

        insert item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(100.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
        System.assertEquals(0.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1561
        Create an Invoice Item 
        - Validations 
        - Creation with only Unit Price field received
    */
    @isTest static void PRP_0001_FA6(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            UnitPrice__c = 100.0
        );

        
        Test.startTest();
        try{
            insert item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(0, [Select Id From InvoiceItem__c].size());
        }

        Test.stopTest();
    }

    /*  TEST-1562
        Create an Invoice Item
        - Validations 
        - Creation with none of the fields Quantity, Unit Price and Total Price received
    */
    @isTest static void PRP_0001_FA7(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id
        );

        
        Test.startTest();
        try{
            insert item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(0, [Select Id From InvoiceItem__c].size());
        }

        Test.stopTest();
    }

    /*  TEST-1564
        Create an Invoice Item 
        – Validations 
        - Creation when Quantity field is a negative value
    */
    @isTest static void PRP_0001_FA8_2(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = -10.0
        );

        
        Test.startTest();
        try{
            insert item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(0, [Select Id From InvoiceItem__c].size());
        }

        Test.stopTest();
    }

    /*  TEST-1565
        Create an Invoice Item 
        – Edit Invoice Item 
        – Only Total Price field is edited
    */
    @isTest static void PRP_0001_FA9(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            TotalPrice__c = 1000.0
        );

        insert item;

        Test.startTest();

        item.TotalPrice__c = 500.0;

        update item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(500.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1566
        Create an Invoice Item
        – Edit Invoice Item
        – Only Quantity field is edited
    */
    @isTest static void PRP_0001_FA10(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.Quantity__c = 100.0;

        update item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(100.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
        System.assertEquals(5000.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1567
        Create an Invoice Item
        – Edit Invoice Item
        – Quantity and Total Price fields are edited
    */
    @isTest static void PRP_0001_FA11(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.Quantity__c = 100.0;
        item.TotalPrice__c = 1000.0;

        update item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c.setScale(1));
        System.assertEquals(1000.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1568
        Create an Invoice Item
        – Edit Invoice Item
        – Only Unit Price field is edited
    */
    @isTest static void PRP_0001_FA12(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.UnitPrice__c = 60.0;

        update item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(60.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c.setScale(1));
        System.assertEquals(600.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1569
        Create an Invoice Item
        – Edit Invoice Item
        – Unit Price and Total Price fields are edited 
    */
    @isTest static void PRP_0001_FA13(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.UnitPrice__c = 60.0;
        item.TotalPrice__c = 600.0;

        update item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
        System.assertEquals(600.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1570
        Create an Invoice Item
        – Edit Invoice Item
        – Unit Price and Quantity fields are edited
    */
    @isTest static void PRP_0001_FA14(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.UnitPrice__c = 60.0;
        item.Quantity__c = 10.0;

        update item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(600.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1571
        Create an Invoice Item 
        – Edit Invoice Item 
        – Unit Price, Quantity and Total Price fields are edited
    */
    @isTest static void PRP_0001_FA15(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.UnitPrice__c = 60.0;
        item.Quantity__c = 15.0;
        item.TotalPrice__c = 1000.0;

        update item;

        Test.stopTest();        

        //Then
        System.assertEquals(1, [Select Id From InvoiceItem__c].size());
        System.assertEquals(900.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c.setScale(1));
    }

    /*  TEST-1572
        Create an Invoice Item
        – Validations
        - Edition when status of the related invoice is Approved 
    */
    @isTest static void PRP_0001_FA16_1(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        invoices[0].Status__c = 'Approved';

        update invoices;

        Test.startTest();

        item.Quantity__c = 15.0;

        try{
            update item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
        }

        Test.stopTest();
    }

    /*  TEST-1573
        Create an Invoice Item
        – Validations
        – Edition when status of the related invoice is Rejected
    */
    @isTest static void PRP_0001_FA16_2(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        invoices[0].Status__c = 'Pending for Approval';

        update invoices;

        invoices[0].Status__c = 'Rejected';

        update invoices;

        Test.startTest();

        item.Quantity__c = 15.0;

        try{
            update item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
        }

        Test.stopTest();
    }

    /*  TEST-1574
        Create an Invoice Item
        – Validations
        – Edition when Quantity field or Unit Price is zero
    */
    @isTest static void PRP_0001_FA17_1(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.Quantity__c = 0.0;
        item.TotalPrice__c = 50.0;

        try{
            update item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
            System.assertEquals(50.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c.setScale(1));
        }

        item.UnitPrice__c = 0.0;
        item.TotalPrice__c = 50.0;

        try{
            update item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
            System.assertEquals(50.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c.setScale(1));
        }

        Test.stopTest();
    }

    /*  TEST-1575
        Create an Invoice Item
        – Validations
        – Edition when Quantity field is negative
    */
    @isTest static void PRP_0001_FA17_2(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.Quantity__c = -10.0;
        
        try{
            update item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
            System.assertEquals(50.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c.setScale(1));
        }

        Test.stopTest();
    }

    /*  TEST-1576
        Create an Invoice Item
        – Delete an Invoice Item
    */
    @isTest static void PRP_0001_FA18(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        delete item;
        
        System.assertEquals(0, [Select Id From InvoiceItem__c].size());
        System.assertEquals(0.0, ((Invoice__c)[Select Id, Amount__c From Invoice__c]).Amount__c.setScale(1));

        Test.stopTest();
    }

    /*  TEST-1577
        Create an Invoice Item
        – Validations
        – Edit the Invoice lookup
     */
    @isTest static void PRP_0001_FA19() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.Invoice__c = invoices[1].Id;

        try{
            update item;
        }
        catch(Exception e){
            System.assertEquals(invoices[0].Id, ((InvoiceItem__c)[Select Id, Invoice__c From InvoiceItem__c]).Invoice__c);
        }

        Test.stopTest();
    }

    /*  TEST-1587
        Create an Invoice Item
        – Validations
        – Edition when Unit Price, Quantity and Total Price fields are null or zero
    */
    @isTest static void temp_test_001(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        Test.startTest();

        item.TotalPrice__c = null;
        item.UnitPrice__c = null;
        item.Quantity__c = null;

        try{
            update item;
        }
        catch(Exception e){
            System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c);
            System.assertEquals(50.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c);
            System.assertEquals(500.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c);
        }

        Test.stopTest();
    }

     /* TEST-1588
        Create an Invoice Item
        - Validations
        - Creation with invalid Unit Price field received
     */
    @isTest static void PRP_0001_FA21(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = -50.0
        );

        Test.startTest();

        //Then
        try{
            insert item;
        }
        catch(Exception e){
            System.assertEquals(0, [Select Id From InvoiceItem__c].size());
        }

        Test.stopTest();
    }

     /* TEST-1589
        Create an Invoice Item
        – Validations
        – Edition when Unit Price is invalid
     */
    @isTest static void PRP_0001_FA22(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        item.UnitPrice__c = -50.0;

        Test.startTest();

        //Then
        try{
            update item;
        }
        catch(Exception e){
            System.assertEquals(50.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c);
        }

        Test.stopTest();
    }

     /* TEST-1590
        Create an Invoice Item
        – Validations
        – Edition when both Quantity and Total Price fields are null or zero
     */
    @isTest static void PRP_0001_FA23(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        item.Quantity__c = 0.0;
        item.TotalPrice__c = 0.0;

        Test.startTest();

        //Then
        try{
            update item;
        }
        catch(Exception e){
            System.assertEquals(50.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c);
        }

        Test.stopTest();
    }

     /* TEST-1591
        Create an Invoice Item
        - Validations
        – Edition when both Unit Price and Total Price fields are edited, but Unit Price is null or zero
     */
    @isTest static void PRP_0001_FA24(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        item.UnitPrice__c = 0.0;
        item.TotalPrice__c = 100.0;

        Test.startTest();

        //Then
        try{
            update item;
        }
        catch(Exception e){
            System.assertEquals(50.0, ((InvoiceItem__c)[Select Id, UnitPrice__c From InvoiceItem__c]).UnitPrice__c);
        }

        Test.stopTest();
    }

    /* TEST-1592
        Create an Invoice Item
        – Edit Invoice Item
        – Only Total Price field is edited when Quantity and Unit Price fields are not zero
    */
    @isTest static void PRP_0001_FA25(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        item.TotalPrice__c = 100.0;

        Test.startTest();

        //Then
        update item;

        System.assertEquals(500.0, ((InvoiceItem__c)[Select Id, TotalPrice__c From InvoiceItem__c]).TotalPrice__c);

        Test.stopTest();
    }

    /*  TEST-1894
        Create an Invoice Item
        – Validations
        – Edition when status of the related invoice is Pending for Approval (NOK)
    */
    @isTest static void PRP_0001_FA16_3() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        invoices[0].Status__c = 'Pending for Approval';

        update invoices;

        Test.startTest();

        item.Quantity__c = 15.0;

        try{
            update item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
        }

        Test.stopTest();
    }

    /*  TEST-1895
        Create an Invoice Item
        – Validations
        - Edition when status of the related invoice is Canceled (NOK)
    */
    @isTest static void PRP_0001_FA16_4() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        //When
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        invoices[0].Status__c = 'Pending for Approval';

        update invoices;

        invoices[0].Status__c = 'Approved';

        update invoices;

        invoices[0].Status__c = 'Canceled';

        update invoices;

        Test.startTest();

        item.Quantity__c = 15.0;

        try{
            update item;
        }
        catch(Exception e){
            //Then
            System.assertEquals(10.0, ((InvoiceItem__c)[Select Id, Quantity__c From InvoiceItem__c]).Quantity__c.setScale(1));
        }

        Test.stopTest();
    }
}