@isTest
public class TestChangeInvoiceStatus {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
    private static FieloPLT__PointType__c pointType;
    private static FieloPLT__ProgramPointType__c programPointType;

    @testSetup static void createData(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        //cannot insert member with points, member applydefaults ignores the points value upon insert
        members[0].FieloPLT__Points__c = 100;
        members[1].FieloPLT__Points__c = 100;
        update members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Status__c = 'Open';
        insert invoices;

        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            TotalPrice__c = 70.0
        );
        
        insert item;

        FieloPLT__Transaction__c transaccion = new FieloPLT__Transaction__c(
            FieloPLT__Member__c = members.get(0).Id
            , FieloPRP__Invoice__c = invoices[0].Id
            , FieloPLT__Points__c = 100
            , FieloPLT__IsOffline__c = false
            , FieloPLT__IsProcessed__c = true
            , FieloPLT__SkipEngine__c = true
        );

        insert transaccion;
    }

    /*  TEST-1594
        Change Invoice Status
        – Approve a Pending for Approval Invoice from a program with App Process (OK)   
    */
    @isTest static void PRP_0004_FB(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);

        Test.stopTest();
    }

    /*  TEST-1595
        Change Invoice Status
        – Reject a Pending for Approval Invoice from a program with App Process (OK)
    */
    @isTest static void PRP_0004_FA2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        system.assertEquals('Rejected', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);

        Test.stopTest();
    }

    /*  TEST-1596
        Change Invoice Status
        – Validations
        - Revert a Pending for Approval Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA1_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Canceled';

        try{
            update invoices;
        }
        catch(Exception e){
            //do nothing, expected validation
        }   

        system.assertEquals('Pending for Approval', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);

        Test.stopTest();
    }

    /*  TEST-1597
        Change Invoice Status
        - Revert an Approved Invoice from a program with App Process (OK)
    */
    @isTest static void PRP_0004_FA7(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        invoices[0].Status__c = 'Canceled';

        update invoices;

        system.assertEquals(true,[Select Id, Name, FieloPLT__IsReverted__c From FieloPLT__Transaction__c WHERE Invoice__c =: invoices[0].Id ].FieloPLT__IsReverted__c);
        system.assertEquals('Canceled',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1598
        Change Invoice Status
        -  Reprocess an Approved Invoice from a program with App Process (OK)
    */
    @isTest static void PRP_0004_FA3_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        InvoiceService.reprocessInvoice(new Set<Id>{invoices[0].Id});

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1599
        Change Invoice Status
        – Validations
        – Reject an Approved Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA3_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        invoices[0].Status__c = 'Rejected';

        try{
            update invoices;
        }
        catch(Exception e){}

        system.assertEquals(false,[Select Id, Name, FieloPLT__IsReverted__c From FieloPLT__Transaction__c WHERE Invoice__c =: invoices[0].Id ].FieloPLT__IsReverted__c);
        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1600
        Change Invoice Status
        - Reopen a Rejected Invoice from a program with App Process (OK)
    */
    @isTest static void PRP_0004_FA4_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        invoices[0].Status__c = 'Open';

        update invoices;
        
        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1601
        Change Invoice Status
        – Validations
        – Approve a Rejected Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA4_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        invoices[0].Status__c = 'Approved';

        try{
            update invoices;
        }
        catch(Exception e){}
        
        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1602
        Change Invoice Status
        – Validations
        - Revert a Rejected Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA4_3(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        invoices[0].Status__c = 'Canceled';

        try{
            update invoices;
        }
        catch(Exception e){}
        
        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1603
        Change Invoice Status
        - Reopen a Canceled Invoice from a program with App Process (OK)
    */
    @isTest static void PRP_0004_FA5_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        invoices[0].Status__c = 'Approved';

        update invoices;

        Test.startTest();

        invoices[0].Status__c = 'Canceled';

        update invoices;

        invoices[0].Status__c = 'Open';

        update invoices;
                
        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1604
        Change Invoice Status
        – Validations
        – Reject a Canceled Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA5_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        invoices[0].Status__c = 'Approved';

        update invoices;

        Test.startTest();

        invoices[0].Status__c = 'Canceled';

        update invoices;

        invoices[0].Status__c = 'Rejected';

        try{
            update invoices;
        }
        catch(Exception e){}
                
        system.assertEquals('Canceled',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1605
        Change Invoice Status
        – Validations
        – Submit for Approval a Canceled Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA5_3(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        invoices[0].Status__c = 'Approved';

        update invoices;

        Test.startTest();

        invoices[0].Status__c = 'Canceled';

        update invoices;

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
            InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});
        }
        catch(Exception e){}
                
        system.assertEquals('Canceled',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1629
        Change Invoice Status
        – Validations
        - Reject an Open Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FB_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Reject';

        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        try{
            update invoices;
        }
        catch(Exception e){}
                
        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1630
        Change Invoice Status
        – Validations
        - Revert an Open Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FB_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Canceled';

        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        try{
            update invoices;
        }
        catch(Exception e){}
                
        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1631
        Change Invoice Status
        – Validations
        - Submit for Approval an Approved Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA7_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
            InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});
        }
        catch(Exception e){}
                
        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1632
        Change Invoice Status
        – Validations
        - Reopen an Approved Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA7_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Open';

        try{
            update invoices;
        }
        catch(Exception e){}
                
        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1633
        Change Invoice Status
        – Validations
        - Submit for Approval a Rejected Invoice from a program with App Process (NOK)
    */
    @isTest static void PRP_0004_FA2_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Open';

        try{
            update invoices;
        }
        catch(Exception e){}
                
        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1634
        Change Invoice Status
        – Submit for Approval an Open Invoice from a program without App Process (OK)
    */
    @isTest static void PRP_0004_FA4(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1635
        Change Invoice Status
        – Close an Open Invoice from a program without App Process (OK)
    */
    @isTest static void PRP_0004_FA3(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        Invoice__c invoice = InvoiceService.closeInvoice(invoices[0].Id);

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1636
        Change Invoice Status
        – Validations
        - Reopen a Pending for Approval Invoice from a program without App Process (NOK)
    */
    @isTest static void PRP_0004_FA1_2(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        Invoice__c invoice = InvoiceService.closeInvoice(invoices[0].Id);

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }
}