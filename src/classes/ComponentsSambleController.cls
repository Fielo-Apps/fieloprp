public class ComponentsSambleController{
	@AuraEnabled
    public static String getFieldData(String objectName, String fieldNames) {
        try{
            return AuraService.getFieldData(objectName,fieldNames);
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }
}