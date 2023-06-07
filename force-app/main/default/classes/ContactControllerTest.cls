@isTest
private class ContactControllerTest {
    @testSetup static void setup() {
        List<account> accList = TestClassUtility.createAccounts(4);
        insert accList;

        List<contact> conList = TestClassUtility.createContacts(accList);
        insert conList;
    }

     @isTest static void testGetContacts() {
        List<Contact> lstContact = new List<Contact>(); 
        
        Test.startTest();
            String result = ContactController.getContacts('', 'FirstName', 'desc');
            Object obj = JSON.deserialize(result,ContactWrapper.class);
            system.debug('obj: '+obj);
            ContactWrapper c = (ContactWrapper)obj;
            system.debug('c: '+c);
        Test.stopTest();
        System.assertNotEquals(c.contacts.size(), 0,'Contact should be present');
     }

     @isTest static void testSearchContacts() {
        List<Contact> lstContact = new List<Contact>(); 
        
        Test.startTest();
            String result = ContactController.getContacts('Test', 'FirstName', 'asc');
            Object obj = JSON.deserialize(result,ContactWrapper.class);
            system.debug('obj: '+obj);
            ContactWrapper c = (ContactWrapper)obj;
            system.debug('c: '+c);
        Test.stopTest();
        System.assertNotEquals(c.contacts.size(), 0,'Contact should be present');
    }

    public class ContactWrapper { 
        public String error {get;set;}       
        public List<Contact> contacts {get;set;}
    }
}