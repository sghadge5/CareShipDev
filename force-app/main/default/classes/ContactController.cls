public with sharing class ContactController {
        
    /*
        Method: getContacts
        Parameter: searchKey- to perform search, sortBy- to sort the column, sortDirection- to decide sorting
        Description: This method is used to get/search the contacts
    */
    @AuraEnabled (cacheable=true)
    public static String getContacts(String searchKey, String sortBy,String sortDirection){
        
        List<Contact> contacts = New List<Contact>();
        ContactWrapper conObj =  new ContactWrapper(); 
        
        try{
            String query = 'SELECT FirstName, LastName, Email FROM Contact';
            if ( searchKey != null && searchKey != '' ) { // Search functionality - additional implementation 
                query += ' WHERE Name LIKE :key';
            }
            if ( sortBy != null && sortDirection != null ) { // Sorting colums - additional implementation 
                query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
            }
            query+= ' LIMIT 50000';

            conObj.contacts = Database.query( query ); 
                
        }catch(Exception ex){
            conObj.error = string.valueOf(ex.getMessage());
        }
        
        return JSON.serialize(conObj);
    }

    public class ContactWrapper { 
        public String error {get;set;}       
        public List<Contact> contacts {get;set;}
    }
    
}