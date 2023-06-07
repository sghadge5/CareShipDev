public class TestClassUtility {

    public static Account createAccount(){
        Account a = new Account(name='Test Acc'+Math.random() ,phone='9494146144');
        return a;
            
    }
    
    public static contact createContact(id accId){
        Contact con = new Contact(accountid=accId,lastname='TestCon'+Math.random() ,FirstName='Test '+Math.random(), email='N24_823@gmail.com');
        return con;
            
    }
    
    public static List<Account> createAccounts(integer n){
        List<Account> newLst = new List<Account>();
        for(integer i = 0; i < n; i++){
            newLst.add(createAccount());
        }
        return newLst;
    }
    
    public static List<Contact> createContacts(List<Account> accLst){
        List<Contact> newLst = new List<Contact>();
        for(account acc: accLst){
            newLst.add(createContact(acc.id));
        }
        return newLst;
    
    }
    
    
}