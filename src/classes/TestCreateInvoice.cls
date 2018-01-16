@isTest
private class TestCreateInvoice {
    
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    /*  TEST-1578
        Create an Invoice
        – Program with the option “Request Invoice Products” set to true (OK)
    */
    @isTest static void PRP_0002_FB(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        Account distributor = new Account(name = 'Fielo');
        
        insert distributor;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        
        invoices[0].Distributor__c = distributor.Id;
        invoices[0].InvoiceNumber__c = '123456';

        insert invoices;

        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;
    }

    /*  TEST-1579
        Create an Invoice
        – Program with the option “Request Invoice Products” set to false (OK)
    */
    @isTest static void PRP_0002_FA1(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        //When
        invoices[0].Amount__c = 10;

        //Then
        insert invoices;
    }

    /*  TEST-1580
        Create an Invoice
        – Validations
        – Try to create an invoice item when the option Request Invoice Products is false (NOK)
    */
    @isTest static void PRP_0002_FA1_1(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        //When
        invoices[0].Amount__c = 10;

        //Then
        insert invoices;
        
        invoices[0].Amount__c = null;

        update invoices;

        invoices[0].Amount__c = 10;

        //Then
        update invoices;

        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        try{
            insert item;
        }
        catch(Exception e){
            System.assertEquals(0, [SELECT Id FROM InvoiceItem__c].size());
        }
    }

    /*  TEST-1581
        Create an Invoice
        – Delete Invoice
        - The option to Consider Invoice Detail is true
    */
    @isTest static void PRP_0002_FA2(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;
        
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;


        try{
            //When
            delete invoices;
        }
        catch(Exception e){
            //Then
            System.assertEquals(0, [SELECT Id FROM Invoice__c].size());
            System.assertEquals(0, [SELECT Id FROM InvoiceItem__c].size());
        }
    }

    /*  TEST-1582
        Create an Invoice
        – Validations
        – Edit Amount field when the option Request Invoice Products is true (NOK)
    */
    @isTest static void PRP_0002_FA3_1(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        invoices[0].Amount__c = 10;

        //Then
        try{
            update invoices;
        }
        catch(Exception e){
            System.assertEquals(null, ((Invoice__c)[SELECT Id,Amount__c FROM Invoice__c]).Amount__c);
        }
    }

    /*  TEST-1583
        Create an Invoice
        – Validations
        – Create Invoice with no Member
    */
    @isTest static void PRP_0002_FA4(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);

        //when
        invoices[0].Member__c = null;
        try{
            insert invoices;
        }
        catch(Exception e){
            //then
            System.assertEquals(0, [SELECT Id FROM Invoice__c].size());
        }
    }

    /*  TEST-1584
        Create an Invoice
        – Validations
        – Edit the Member lookup
    */
    @isTest static void PRP_0002_FA5(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);

        //when
        invoices[0].Member__c = members[1].Id;
        try{
            insert invoices;
        }
        catch(Exception e){
            //then
            System.assertEquals( members[0].Id, ((Invoice__c)[SELECT Id,Member__c FROM Invoice__c]).Member__c );
        }
    }

    /*  TEST-1585
        Create an Invoice
        – Validations
        – Edit Invoice when its status is Approved
    */
    @isTest static void PRP_0002_FA6(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Amount__c = 10;
        invoices[0].Status__c = 'Approved';
        insert invoices;
        
        String oldInvoiceNumber = invoices[0].InvoiceNumber__c;

        invoices[0].InvoiceNumber__c = 'Teste';

        //when
        String errorMsg = '';
        try{
            update invoices;
        }
        catch(Exception e){
            //then
            errorMsg = e.getMessage();
        }

        System.assertEquals( oldInvoiceNumber, ((Invoice__c)[SELECT Id,InvoiceNumber__c FROM Invoice__c]).InvoiceNumber__c );
        System.assert( errorMsg.contains(Label.DraftNotEditable) );
    }

    /*  TEST-1586
        Create an Invoice
        – Validations
        – Edit Invoice when its status is Rejected
    */
    @isTest static void PRP_0002_FA6_1(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Status__c='Rejected';
        insert invoices;
        
        String oldInvoiceNumber = invoices[0].InvoiceNumber__c;

        invoices[0].InvoiceNumber__c = 'Teste';

        //when
        try{
            update invoices;
        }
        catch(Exception e){
            //then
            System.assertEquals( oldInvoiceNumber, ((Invoice__c)[SELECT Id,InvoiceNumber__c FROM Invoice__c]).InvoiceNumber__c );
        }
    }

    /*  TEST-1593
        Create an Invoice
        – Validations
        – Create Invoice with an existing Invoice Number + Distributor (NOK)
    */
    @isTest static void PRP_0002_FA8() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        Account distributor = new Account(name = 'Fielo');
        
        insert distributor;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].InvoiceNumber__c='0001';
        invoices[0].Status__c='Approved';
        insert invoices[0];
        
        invoices[1].InvoiceNumber__c='0001';

        try{
            insert invoices[1];
        } catch(Exception e) {}

        System.assertEquals( 1, [SELECT Id,InvoiceNumber__c FROM Invoice__c].size() );
    }

    /*  TEST-1889
        Create an Invoice
        – Validations
        – Amount field is not null when the option Request Invoice Products is true (NOK)
    */
    @isTest static void PRP_0002_FA3() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        Account distributor = new Account(name = 'Fielo');
        
        insert distributor;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].InvoiceNumber__c='0001';
        invoices[0].Amount__c=10;

        try {
            insert invoices[0];
        } catch(Exception e) {}

        System.assertEquals( 0, [SELECT Id,InvoiceNumber__c FROM Invoice__c].size() );
    }

    /*  TEST-1890
        Create an Invoice
        – Validations
        – Edit Invoice when its status is Pending for Approval (NOK)
    */
    @isTest static void PRP_0002_FA6_2() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].InvoiceNumber__c='0001';
        invoices[0].Status__c='Pending for Approval';
        invoices[0].Amount__c=10;

        insert invoices[0];

        invoices[0].Amount__c=15;

        try {
            update invoices[0];
        } catch(Exception e) {}

        System.assertEquals( 10, ([SELECT Id,Amount__c FROM Invoice__c WHERE Id = :invoices[0].Id LIMIT 1]).Amount__c );
    }

    /*  TEST-1891
        Create an Invoice
        – Validations
        – Edit Invoice when its status is Canceled (NOK)
    */
    @isTest static void PRP_0002_FA6_3() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].InvoiceNumber__c='0001';
        invoices[0].Status__c='Pending for Approval';
        invoices[0].Amount__c=10;

        insert invoices[0];

        invoices[0].Status__c='Approved';

        update invoices[0];

        invoices[0].Status__c='Canceled';

        update invoices[0];

        invoices[0].Amount__c=15;

        try {
            update invoices[0];
        } catch(Exception e) {}

        System.assertEquals( 10, ([SELECT Id,Amount__c FROM Invoice__c WHERE Id = :invoices[0].Id LIMIT 1]).Amount__c );
    }

    /*  TEST-1892
        Create an Invoice
        – Validations
        – Create Invoice with Date null (NOK)
    */
    @isTest static void PRP_0002_FA7() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Date__c=null;

        try {
            insert invoices[0];
        } catch(Exception e) {}

        System.assertEquals( 0, [SELECT Id FROM Invoice__c].size() );
    }

    /*  TEST-1893
        Create an Invoice
        – Validations
        – Create Invoice with Date later than current date (NOK)
    */
    @isTest static void PRP_0002_FA9() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Date__c=System.today().addDays(1);

        try {
            insert invoices[0];
        } catch(Exception e) {}

        System.assertEquals( 0, [SELECT Id FROM Invoice__c].size() );
    }

    @isTest static void validateHasDetailsAccess(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        
        insert invoices;

        //When
        invoices[0].HasDetails__c=false;

        try{
            update invoices;
        }
        catch(Exception e){
            //then
            System.assertEquals( true, ((Invoice__c)[SELECT Id,HasDetails__c From Invoice__c]).HasDetails__c );
        }
    }


    public static testmethod void unitTestTemporal(){
        InvoiceService.testTemporal();
        InvoiceService.testTempora2();
        InvoiceService.testTempora3();
    }
}