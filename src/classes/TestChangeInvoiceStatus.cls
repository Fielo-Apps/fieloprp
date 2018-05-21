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
        – Approve a Pending for Approval Invoice from a program where Request Invoice Authorization is TRUE and there is an ACTIVE Approval Process (OK)   
    */
    @isTest static void PRP_0004_FA8(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';
        Date dt = (System.now()).date();

        update invoices;

        invoices[0] = (Invoice__c)[SELECT Id, Status__c, ApprovedDate__c FROM Invoice__c];
        system.assertEquals('Approved', invoices[0].Status__c);
        system.assertEquals(dt,(invoices[0].ApprovedDate__c).date());

        Test.stopTest();
    }

    /*  TEST-1595
        Change Invoice Status
        – Reject a pending for approval invoice from a program where Request Invoice Authorization is TRUE and there is an ACTIVE Approval Process (OK)
    */
    @isTest static void PRP_0004_FA7(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

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
        - Reject an open invoice from a program where Request Invoice Authorization is FALSE and there is NO active Approval Process (OK)
    */
    @isTest static void PRP_0004_FB(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c, Comments__c, RejectReason__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        system.assertEquals('Rejected', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);
        
        invoices[0].Status__c = 'Open';

        update invoices;

        system.assertEquals('Open', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);

        invoices[0].Status__c = 'Rejected';
        invoices[0].Comments__c = 'Comment Test';
        invoices[0].RejectReason__c = 'Invalid Image';

        update invoices;

        system.assertEquals('Rejected', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);
        system.assertEquals('Comment Test', ((Invoice__c)[SELECT Id, Comments__c FROM Invoice__c]).Comments__c);
        system.assertEquals('Invalid Image', ((Invoice__c)[SELECT Id, RejectReason__c FROM Invoice__c]).RejectReason__c);

        Test.stopTest();
    }

    /*  TEST-1597
        Change Invoice Status
        - Revert an Approved Invoice from a program where Request Invoice Authorization is FALSE (OK)
    */
    @isTest static void PRP_0004_FA15(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        invoices[0].Status__c = 'Canceled';

        update invoices;

        invoices[0] = [SELECT Id, Status__c,ApprovedDate__c FROM Invoice__c LIMIT 1];

        system.assertEquals(true,[Select Id, Name, FieloPLT__IsReverted__c From FieloPLT__Transaction__c WHERE Invoice__c =: invoices[0].Id ].FieloPLT__IsReverted__c);
        system.assertEquals('Canceled',invoices[0].Status__c);
        system.assertEquals(null,invoices[0].ApprovedDate__c);

        Test.stopTest();
    }

    /*  TEST-1598
        Change Invoice Status
        -  Reprocess an Approved Invoice from a program where Request Invoice Authorization is TRUE (OK)
    */
    @isTest static void PRP_0004_FA16(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;
        invoices[0] = (Invoice__c)[SELECT Id, ApprovedDate__c FROM Invoice__c LIMIT 1];
        Datetime dtm = invoices[0].ApprovedDate__c;

        InvoiceService.reprocessInvoice(new Set<Id>{invoices[0].Id});

        invoices[0] = [SELECT Id, Status__c, ApprovedDate__c FROM Invoice__c LIMIT 1];

        system.assertEquals('Approved',invoices[0].Status__c);
        system.assertEquals(dtm,invoices[0].ApprovedDate__c);

        Test.stopTest();
    }

    /*  TEST-1599
        Change Invoice Status
        – Validations
        – Reject an Approved Invoice (NOK)
    */
    @isTest static void PRP_0004_FA14_1(){
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
        - Reopen a Rejected Invoice from a program where Request Invoice Authorization is TRUE (OK)
    */

    @isTest static void PRP_0004_FA18(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

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
        – Close an open invoice from a program where Request Invoice Authorization is FALSE and there is an ACTIVE Approval Process (OK)
    */
    @isTest static void PRP_0004_FA3(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c, Comments__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);        

        invoices[0].Status__c = 'Open';

        update invoices;

        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';

        invoices[0].Comments__c = 'Comment Test';

        Date dt = (System.now()).date();

        update invoices;

        invoices[0] = (Invoice__c)[SELECT Id, Status__c, Comments__c, ApprovedDate__c FROM Invoice__c];
        
        system.assertEquals('Approved',invoices[0].Status__c);

        system.assertEquals('Comment Test',invoices[0].Comments__c);

        system.assertEquals(dt,(invoices[0].ApprovedDate__c).date());


        Test.stopTest();
    }

    /*  TEST-1602
        Change Invoice Status
        – Validations
        - Reject a Pending for Approval Invoice from a program where Request Invoice Authorization is FALSE and there is an ACTIVE Approval Process (OK)    */
    @isTest static void PRP_0004_FA11(){
        
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c, Comments__c, RejectReason__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        invoices[0].Comments__c = 'Comment Test';

        invoices[0].RejectReason__c = 'Invalid Image';

        update invoices;

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        system.assertEquals('Comment Test',[SELECT Id, Comments__c FROM Invoice__c LIMIT 1].Comments__c);

        system.assertEquals('Invalid Image',[SELECT Id, RejectReason__c FROM Invoice__c LIMIT 1].RejectReason__c);


        Test.stopTest();
    }

    /*  TEST-1603
        Change Invoice Status
        -Reopen a Canceled Invoice from a program where Request Invoice Authorization is TRUE (OK)
    */
    @isTest static void PRP_0004_FA20(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

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
        – Reject a Canceled Invoice (NOK)
    */
    @isTest static void PRP_0004_FA20_1(){
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
        – Submit for Approval a Canceled Invoice (NOK)
    */
    @isTest static void PRP_0004_FA20_2(){
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

    /*  TEST-1629 - Not Tested Need Reject Reason Trigger Update
        Change Invoice Status
        – Validations
        - The back office user gives no reason for the rejection (NOK)
    */
    @isTest static void PRP_0004_FA1(){
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
        - Close an open invoice from a program where Request Invoice Authorization is FALSE and there is NO active Approval Process (OK)
    */
    @isTest static void PRP_0004_FA2(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c, Comments__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Open';

        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
        
        invoices[0].Comments__c = 'Commenting Test';
        
        invoices[0].Status__c = 'Approved';

        Date dt = (System.now()).date();
                
        update invoices;
        invoices[0] = (Invoice__c)[SELECT Id, Status__c, Comments__c, ApprovedDate__c FROM Invoice__c LIMIT 1];

        system.assertEquals('Approved',invoices[0].Status__c);

        system.assertEquals('Commenting Test',invoices[0].Comments__c);
        
        system.assertEquals(dt,(invoices[0].ApprovedDate__c).date());
        Test.stopTest();
    }

    /*  TEST-1631
        Change Invoice Status
        – Validations
        - Submit for Approval an Approved Invoice(NOK)
    */
    @isTest static void PRP_0004_FA14_2(){
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
        - Reopen an Approved Invoice
    */
    @isTest static void PRP_0004_FA14_3(){
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
        - Approve a Pending for Approval Invoice from a program where Request Invoice Authorization is FALSE and there is an ACTIVE Approval Process (OK)    */
    @isTest static void PRP_0004_FA12(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c, Comments__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');
        InvoiceService.submitForApproval(new Set<Id>{invoices[0].Id});

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.startTest();

        invoices[0].Status__c = 'Approved';
        invoices[0].Comments__c = 'Approved Test';
        Date dt = (System.now()).date();


        update invoices;

        invoices[0] = (Invoice__c)[SELECT Id, Status__c, Comments__c, ApprovedDate__c FROM Invoice__c];

        system.assertEquals('Approved',invoices[0].Status__c);        
                
        system.assertEquals('Approved Test',invoices[0].Comments__c);

        system.assertEquals(dt,(invoices[0].ApprovedDate__c).date());
        Test.stopTest();
    }

    /*  TEST-1634 - ToUpdate
        Change Invoice Status
        – Submit for Approval an Open Invoice from a program where Request Invoice Authorization is FALSE and there is an ACTIVE Approval Process (OK)
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
        – Close an open invoice from a program where Request Invoice Authorization is TRUE and there is NO active Approval Process (OK)    */
    
    @isTest static void PRP_0004_FA5(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Open');
        
        system.assertEquals('Open',[SELECT Id, Status__c From Invoice__c LIMIT 1].Status__c);

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();

    }

    /*  TEST-1636
        Can't create the user for test

    /*  TEST-1637
        Change Invoice Status
        –  Reprocess a Canceled Invoice from a program where Request Invoice Authorization is TRUE (OK)
    */
    @isTest static void PRP_0004_FA22(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

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

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Approved');
        Date dt = (System.now()).date();
        invoices[0] = (Invoice__c)[SELECT Id, Status__c, ApprovedDate__c FROM Invoice__c LIMIT 1];

        system.assertEquals('Approved',invoices[0].Status__c);
        system.assertEquals(dt,(invoices[0].ApprovedDate__c).date());

        Test.stopTest();
    }

    /*  TEST-1645
        Change Invoice Status
        – Close an open invoice from a program where Request Invoice Authorization is TRUE and there is an ACTIVE Approval Process (OK)
    */
    @isTest static void PRP_0004_FA6(){
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        InvoiceService.closeInvoice(invoices[0].Id);

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }


    /*  TEST-1647
        Change Invoice Status
        – Validations
        – Revert an Open Invoice (NOK)
    */
    @isTest static void PRP_0004_FB_1() {
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Canceled';

        try{
            update invoices;
        } catch(Exception e) {}

        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1648
        Change Invoice Status
        – Approve a Pending for Approval Invoice from a program where Request Invoice Authorization is TRUE and there is NO active Approval Process (OK)    */
    @isTest static void PRP_0004_FA10() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c, Comments__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';
        invoices[0].Comments__c = 'Approved Test';
        Date dt = (System.now()).date();
        
        update invoices;

        invoices[0] = (Invoice__c)[SELECT Id, Status__c, Comments__c, ApprovedDate__c FROM Invoice__c LIMIT 1];

        system.assertEquals('Approved',invoices[0].Status__c);
    
        system.assertEquals('Approved Test',invoices[0].Comments__c);
        system.assertEquals(dt,(invoices[0].ApprovedDate__c).date());
    }

    /*  TEST-1649
        Change Invoice Status
        – Validations
        - Revert a Pending for Approval Invoice (NOK)
    */
    @isTest static void PRP_0004_FA7_2() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Canceled';

        try{
            update invoices;
        } catch (Exception e) {}

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
    }

    /*  TEST-1650
        Change Invoice Status
        – Validations
        – Reopen a Pending for Approval Invoice (NOK)
    */
    @isTest static void PRP_0004_FA7_1() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Open';

        try{
            update invoices;
        } catch (Exception e) {}

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
    }

    /*  TEST-1651
        Change Invoice Status
        – Reject a Pending for Approval Invoice from a program where Request Invoice Authorization is TRUE and there is NO active Approval Process (OK)
    */
    @isTest static void PRP_0004_FA9() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

        invoices = [SELECT Id, Name, Status__c, Comments__c, RejectReason__c FROM Invoice__c];


        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Rejected';
        invoices[0].Comments__c = 'Rejected Test';
        invoices[0].RejectReason__c = 'Invalid Image';
        
        update invoices;

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
        
        system.assertEquals('Rejected Test',[SELECT Id, Comments__c FROM Invoice__c LIMIT 1].Comments__c);
        
        system.assertEquals('Invalid Image',[SELECT Id, RejectReason__c FROM Invoice__c LIMIT 1].RejectReason__c);
    }

    /*  TEST-1652
2        Change Invoice Status
        – Validations
        – Approve a Rejected Invoice (NOK)
    */
    @isTest static void PRP_0004_FA18_1() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Rejected';

        update invoices;

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';

        try{
            update invoices;
        } catch (Exception e) {}

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
    }

    /*  TEST-1653
        Change Invoice Status
        – Validations
        – Submit for Approval a Rejected Invoice (NOK)
    */
    @isTest static void PRP_0004_FA18_2() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Rejected';

        update invoices;

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Pending for Approval';

        try{
            update invoices;
        } catch (Exception e) {}

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
    }

    /*  TEST-1654
        Change Invoice Status
        – Validations
        – Revert a Rejected Invoice (NOK)
    */
    @isTest static void PRP_0004_FA18_3() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Rejected';

        update invoices;

        invoices[0].Status__c = 'Canceled';

        try{
            update invoices;
        } 
        catch (Exception e) {}

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
    }

    /*  TEST-1655
        Change Invoice Status
        - Revert an Approved Invoice from a program where Request Invoice Authorization is TRUE (OK)
    */
    @isTest static void PRP_0004_FA14() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Canceled';

        update invoices;

        invoices[0] = (Invoice__c)[SELECT Id, Status__c, Comments__c, RejectReason__c, ApprovedDate__c FROM Invoice__c];
        system.assertEquals('Canceled',invoices[0].Status__c);
        
        system.assertEquals(null,invoices[0].Comments__c);
        
        system.assertEquals(null,invoices[0].RejectReason__c);

        system.assertEquals(null,invoices[0].ApprovedDate__c);

    }

    
    /*  TEST-1657
        Change Invoice Status
        – Validations
        – Reopen an Approved Invoice from a program without App Process (NOK)
    */
    @isTest static void PRP_0004_FA8_2() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Open';

        try{
            update invoices;
        } catch(Exception e) {}

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
    }

    /*  TEST-1658
        Change Invoice Status
        - Reprocess an Approved Invoice from a program where Request Invoice Authorization is FALSE (OK)
    */
    @isTest static void PRP_0004_FA17() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';

        update invoices;
        invoices[0] = (Invoice__c)[SELECT Id, ApprovedDate__c FROM Invoice__c LIMIT 1];
        Datetime dtm = invoices[0].ApprovedDate__c;

        InvoiceService.reprocessInvoice(new Set<Id>{invoices[0].Id});
        invoices[0] = (Invoice__c)[SELECT Id, Status__c, ApprovedDate__c FROM Invoice__c LIMIT 1];
        system.assertEquals('Approved',invoices[0].Status__c);
        system.assertEquals(dtm,invoices[0].ApprovedDate__c);
    }

    /*  TEST-1659
        Change Invoice Status
        - Reopen a Rejected Invoice from a program where Request Invoice Authorization is FALSE (OK)
    */
    @isTest static void PRP_0004_FA19() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Rejected';

        update invoices;

        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Open';

        update invoices;
        
        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);
    }

    /*  TEST-1660
        Change Invoice Status
        - Reopen a Canceled Invoice from a program where Request Invoice Authorization is FALSE (OK)
    */
    @isTest static void PRP_0004_FA21() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Canceled';

        update invoices;
        
        system.assertEquals('Canceled',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Open';

        update invoices;
        
        system.assertEquals('Open',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        system.assertEquals(null, [SELECT Id, Comments__c FROM Invoice__c LIMIT 1].Comments__c);

        system.assertEquals(null, [SELECT Id, RejectReason__c FROM Invoice__c LIMIT 1].RejectReason__c);
    }

    /*  TEST-1661
        Change Invoice Status
        – Reprocess a Canceled Invoice from a program where Request Invoice Authorization is FALSE (OK)
    */
    @isTest static void PRP_0004_FA23() {
        programs = [SELECT Id FROM FieloPLT__Program__c];

        programs[0].FieloPRP__RequestInvoiceAuthorization__c = false;

        update programs;

        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Pending for Approval');

        system.assertEquals('Pending for Approval',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Canceled';

        update invoices;
        
        system.assertEquals('Canceled',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        invoices[0].Status__c = 'Approved';
        Date dt = (System.now()).date();

        update invoices;
        invoices[0] = (Invoice__c)[SELECT Id, Status__c, Comments__c, ApprovedDate__c FROM Invoice__c LIMIT 1];
        
        system.assertEquals('Approved',invoices[0].Status__c);
        system.assertEquals(dt,(invoices[0].ApprovedDate__c).date());

    }
}