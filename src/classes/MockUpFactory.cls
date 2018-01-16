@isTest
public class MockUpFactory {

    private static Map<String, Id> rtMember;

    public static List<FieloPLT__Program__c> createPrograms(String basename, Integer count) {
        List<FieloPLT__Program__c> results = new List<FieloPLT__Program__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Program__c p = new FieloPLT__Program__c();
            p.Name = basename + String.valueOf(x);
            p.FieloPLT__OnlineTransactionProcessing__c = true;
            results.add(p);
        }
        return results;
    }

    //Created for FieloPRP
    public static List<FieloPLT__Member__c> createMembers(String programId, Integer count){
        List<FieloPLT__Member__c> membersToCreate = new List<FieloPLT__Member__c>();
        for(Integer x = 0; x < count; x++){
            membersToCreate.add(new FieloPLT__Member__c(
                    Name='Member '+String.valueOf(x),
                    FieloPLT__Email__c='email'+String.valueOf(x)+'l@example.com',
                    FieloPLT__Type__c='Individual Account',
                    FieloPLT__Program__c=programId
                )
            );
        }
        return membersToCreate;
    }

    //Created for FieloPRP
    public static List<FieloPRP__Invoice__c> createInvoices(String memberId, Integer count){
        List<FieloPRP__Invoice__c> invoicesToCreate = new List<FieloPRP__Invoice__c>();
        for(Integer x = 0; x < count; x++){
            invoicesToCreate.add(new FieloPRP__Invoice__c(
                    FieloPRP__Member__c = memberId,
                    FieloPRP__Date__c = System.today()
                )
            );
        }
        return invoicesToCreate;
    }
}