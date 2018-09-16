@isTest(SeeAllData=true)
private class caseRelationshipFutureMethods_UT{

    
    static testMethod void test() {
    
        caseRelationshipFutureMethods crMeths = new caseRelationshipFutureMethods();
        crMeths.massUpdateCRs(500);
    }
    
}