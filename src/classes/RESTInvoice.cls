/**
 * @ingroup Invoice
 * \~English
 * @details    This REST Service interacts with the Fielo Invoice Module Services.
 */
//@RestResource(urlMapping='/v1/members/*/invoices/*')
public with sharing class RESTInvoice {

    //@HttpGet
    /**
     * @details     This method retuns invoice information related to a given Id
     * @param       invoiceId           Optional parameter, if it is present the method will return a specific record
     * @param       fieldset            Fields to retrieve
     * @param       fromDate            Initial date to filter the returned records
     * @param       toDate              Last date to filter the returned records
     * @param       quantity            Number of records to return
     * @param       offset              Query offset (rows to skip when paginating the query results.)
     * @param       orderBy             Sort order of the returned data
     * @returns     List of Invoices returned by the criteria sent to the method
     * @retval  Success @verbinclude rewards.xml
     * @retval  Failure @verbinclude failure.xml
     *
     * @code{.sh}
     *          curl -X GET -H "Content-Type:application/json" -k -H 'Authorization: Bearer sessionId' 'https://{instance}.salesforce.com/services/apexrest/FieloEE/RestRedemption'
     * @endcode
     */
    public static void getInvoices(){
        RestAPIResponse response = new RestAPIResponse();
        RestResponse resp = RestContext.response;
        try{
            checkPermissions();
            if( RestContext.request.requestUri.contains('/invoices/') && RestContext.request.requestUri.contains('/invoiceItems') ){
                //Get Related List
                getRelatedList();
            } else if( RestContext.request.requestUri.contains('/invoices/') && !RestContext.request.requestUri.contains('/invoiceItems') ){
                //Get Detail
                getSingleRecord();
            } else {
                //Get List
                getList();
            }
        }catch(Exception e){
            response.message = e.getMessage();
            response.errorcode = 'FORBIDDEN';
            resp.statusCode = 403;
            resp.responseBody = Blob.valueOf( JSON.serialize(response) );
        }        
    }

    //@HttpPatch
    public static void updateInvoice(Invoice__c invoice, List<InvoiceItem__c> items, List<Attachment> attachments){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        RestAPIResponse response = new RestAPIResponse();
        try{
            checkPermissions();
            try{
                //MemberId
                String requestUri = RestContext.request.requestUri;
                String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
                memberId = memberId.replace('/members/', '');
                memberId = memberId.substring( 0  , memberId.indexOf('/') );

                String invoiceId = requestUri.substring( requestUri.indexOf('/invoices/')  , requestUri.length() );
                invoiceId = invoiceId.replace('/invoices/', '');
                
                Boolean isCloseOperation = invoiceId.contains('/close');
                invoiceId = invoiceId.replace('/close', '');

                resp.addHeader('Accept', 'application/json');
                resp.addHeader('Content-Type', 'application/json');
            
                if( MemberService.isMemberBlocked(memberId) == true ){
                    response.message = Label.ErrorFieloAccountBlocked;
                    response.errorcode = 'FIELO_ACCOUNT_BLOCKED';
                    resp.statusCode = 404;
                    resp.responseBody = Blob.valueOf( JSON.serialize(response) );
                    RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
                } else {
                    Invoice__c updatedInvoice;
                    if(isCloseOperation){
                        updatedInvoice = InvoiceService.closeInvoice(invoiceId);
                    }else{
                        updatedInvoice = InvoiceService.submitInvoice(invoice, items, attachments);
                    }

                    resp.statusCode = 201;
                    resp.responseBody = Blob.valueOf( JSON.serialize(updatedInvoice) );
                }
            }
            catch(Exception e){
                response.message = e.getMessage();
                response.errorcode = 'EXCEPTION';
                resp.statusCode = 404;
                resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
        catch(Exception e){
            response.message = e.getMessage();
            response.errorcode = 'FORBIDDEN';
            resp.statusCode = 403;
            resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
        }
    }

    //@HttpPost
    public static void createInvoice(Invoice__c invoice, List<InvoiceItem__c> items, List<Attachment> attachments){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        RestAPIResponse response = new RestAPIResponse();
        try{
            checkPermissions();
            try{
                //MemberId
                String requestUri = RestContext.request.requestUri;
                String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
                memberId = memberId.replace('/members/', '');
                memberId = memberId.replace('/invoices', '');

                resp.addHeader('Accept', 'application/json');
                resp.addHeader('Content-Type', 'application/json');

            
                if( MemberService.isMemberBlocked(memberId) == true ){
                    response.message = Label.ErrorFieloAccountBlocked;
                    response.errorcode = 'FIELO_ACCOUNT_BLOCKED';
                    resp.statusCode = 404;
                    resp.responseBody = Blob.valueOf( JSON.serialize(response) );
                    RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
                } else {
                    Invoice__c createdInvoice = InvoiceService.submitInvoice(invoice, items, attachments);

                    resp.statusCode = 201;
                    resp.responseBody = Blob.valueOf( JSON.serialize(createdInvoice) );
                }
            }
            catch(Exception e){
                response.message = e.getMessage();
                response.errorcode = 'EXCEPTION';
                resp.statusCode = 404;
                resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
        catch(Exception e){
            response.message = e.getMessage();
            response.errorcode = 'FORBIDDEN';
            resp.statusCode = 403;
            resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
        }
    }

    public static void checkPermissions(){
        if( !Invoice__c.sObjectType.getDescribe().isAccessible() )
            throw new SObjectDomain.DomainException(
                'Permission to access ' + Invoice__c.sObjectType.getDescribe().getName() + ' denied.');
    }

    private static void getSingleRecord() {
        //MemberId
        String requestUri = RestContext.request.requestUri;
        String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
        memberId = memberId.replace('/members/', '');
        memberId = memberId.substring( 0, memberId.indexOf('/invoices/') );

        requestUri = RestContext.request.requestUri;
        String invoiceId = requestUri.substring( requestUri.indexOf('/invoices/')  , requestUri.length() );
        invoiceId = invoiceId.replace('/invoices/', '');

        String fieldset = RestContext.request.params.get('fields');
        Set<String> fields = new Set<String>();
        for(String s : fieldset != null ? fieldset.split(',') : new List<String>{'Id', 'Name'} ){
            fields.add((s));
        }

        RestAPIResponse response = new RestAPIResponse();
        RestResponse resp = RestContext.response;
        resp.addHeader('Accept', 'application/json');
        resp.addHeader('Content-Type', 'application/json');

        if( MemberService.isMemberBlocked(memberId) == true ){
            response.message = Label.ErrorFieloAccountBlocked;
            response.errorcode = 'FIELO_ACCOUNT_BLOCKED';
            resp.statusCode = 404;
            resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
        } else {
            InvoicesSelector selector = new InvoicesSelector(fields);

            List<Invoice__c> invoices = selector.selectByMemberIdAndInvoiceIdBetweenDates(
                new Set<Id>{invoiceId},
                memberId,
                null,
                null
            );

            if( !invoices.isEmpty() ){
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( invoices ) );
            } else {
                response.message = 'Record not found';
                response.errorcode = 'RECORD_NOT_FOUND';
                resp.statusCode = 200;
                resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
    }

    private static void getList() {
        //MemberId
        String requestUri = RestContext.request.requestUri;
        String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
        memberId = memberId.replace('/members/', '');
        memberId = memberId.substring( 0, memberId.indexOf('/invoices') );

        requestUri = RestContext.request.requestUri;

        String fieldset = RestContext.request.params.get('fields');
        Set<String> fields = new Set<String>();
        for(String s : fieldset != null ? fieldset.split(',') : new List<String>{'Id', 'Name'} ){
            fields.add((s));
        }

        String offSet = RestContext.request.params.get('offset');
        String queryLimit = RestContext.request.params.get('limit');
        String orderby = RestContext.request.params.get('orderby');
        String fromdate = RestContext.request.params.get('fromdate');
        String todate = RestContext.request.params.get('todate');

        RestAPIResponse response = new RestAPIResponse();
        RestResponse resp = RestContext.response;
        resp.addHeader('Accept', 'application/json');
        resp.addHeader('Content-Type', 'application/json');

        if( MemberService.isMemberBlocked(memberId) == true ){
            response.message = Label.ErrorFieloAccountBlocked;
            response.errorcode = 'FIELO_ACCOUNT_BLOCKED';
            resp.statusCode = 404;
            resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
        } else {
            InvoicesSelector selector = new InvoicesSelector(fields);
            
            if(offset!=null){
                selector.setOffset(Integer.valueOf(offset));
            }
            if(queryLimit!=null){
                selector.setLimit(Integer.valueOf(queryLimit));
            }
            if(orderby!=null){
                selector.setOrderBy(orderby);
            }

            List<Invoice__c> invoices = selector.selectByMemberIdAndInvoiceIdBetweenDates(
                new Set<Id>(),
                memberId,
                fromdate!=null ? getdateFromString(fromdate) : null,
                todate!=null ? getdateFromString(todate) : null
            );

            if( !invoices.isEmpty() ){
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( invoices ) );
            } else {
                response.message = 'No invoice found';
                response.errorcode = 'RECORD_NOT_FOUND';
                resp.statusCode = 200;
                resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
    }

    private static void getRelatedList() {
        //MemberId
        String requestUri = RestContext.request.requestUri;
        String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
        memberId = memberId.replace('/members/', '');
        memberId = memberId.substring( 0, memberId.indexOf('/invoices') );

        requestUri = RestContext.request.requestUri;
        String invoiceId = requestUri.substring( requestUri.indexOf('/invoices/')  , requestUri.length() );
        invoiceId = invoiceId.replace('/invoices/', '');
        invoiceId = invoiceId.replace('/invoiceItems', '');

        String fieldset = RestContext.request.params.get('fields');
        Set<String> fields = new Set<String>();
        for(String s : fieldset != null ? fieldset.split(',') : new List<String>{'Id', 'Name', 'Invoice__r.Id', 'Invoice__r.Name'} ){
            fields.add((s));
        }

        String offSet = RestContext.request.params.get('offset');
        String queryLimit = RestContext.request.params.get('limit');
        String orderby = RestContext.request.params.get('orderby');

        RestAPIResponse response = new RestAPIResponse();
        RestResponse resp = RestContext.response;
        resp.addHeader('Accept', 'application/json');
        resp.addHeader('Content-Type', 'application/json');

        if( MemberService.isMemberBlocked(memberId) == true ){
            response.message = Label.ErrorFieloAccountBlocked;
            response.errorcode = 'FIELO_ACCOUNT_BLOCKED';
            resp.statusCode = 404;
            resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
        } else {
            InvoiceItemsSelector selector = new InvoiceItemsSelector(fields);
            
            if(offset!=null){
                selector.setOffset(Integer.valueOf(offset));
            }
            if(queryLimit!=null){
                selector.setLimit(Integer.valueOf(queryLimit));
            }
            if(orderby!=null){
                selector.setOrderBy(orderby);
            }

            List<InvoiceItem__c> items = selector.selectByMemberIdAndInvoiceId(
                new Set<Id>{invoiceId},
                memberId
            );

            if( !items.isEmpty() ){
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( items ) );
            } else {
                response.message = 'No invoice items found';
                response.errorcode = 'RECORD_NOT_FOUND';
                resp.statusCode = 200;
                resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
    }

    public static Date getdateFromString(String dateString){
        //YYYY-MM-DD format
        if( ((Pattern.compile('\\d{4}\\-(\\d{2}|\\d)\\-(\\d{2}|\\d)')).matcher(dateString)).matches() ){
            List<String> dateList = dateString.split('-');
            return Date.newinstance( Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]), Integer.valueOf(dateList[2]) );
        }
        //MM/DD/YYYY format
        if( ((Pattern.compile('(\\d{2}|\\d)\\/(\\d{2}|\\d)\\/\\d{4}')).matcher(dateString)).matches() ){
            List<String> dateList = dateString.split('/');
            return Date.newinstance( Integer.valueOf(dateList[2]), Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]) );
        }
        return null;
    }
}