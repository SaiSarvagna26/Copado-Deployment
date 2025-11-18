public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, FirstName, LastName, Email, Phone FROM Contact ORDER BY CreatedDate DESC LIMIT 100];
    }
    
    @AuraEnabled
    public static Contact createContact(Contact contact) {
        try {
            insert contact;
            return contact;
        } 
        catch(Exception e) {
            throw new AuraHandledException('Error creating contact: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Contact updateContact(Contact contact) {
        try {
            update contact;
            return contact;
        } 
        catch(Exception e) {
            throw new AuraHandledException('Error updating contact: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteContact(Id contactId) {
        try {
            Contact contactToDelete = [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
            delete contactToDelete;
        
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting contact: ' + e.getMessage());
        }
    }
    
}