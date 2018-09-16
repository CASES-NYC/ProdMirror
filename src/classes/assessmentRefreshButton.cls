public with sharing class assessmentRefreshButton {

    public String recordId = ApexPages.currentPage().getParameters().get('id');

    
    public PageReference refreshPage() {
        
        List<Assessment__c> thisAssess = [Select Id from Assessment__c where Id = :recordId];
        update thisAssess; 
        
        PageReference newPage = new PageReference('/' + recordId);
        newPage.setRedirect(true);
        return newPage;
    }
    
}