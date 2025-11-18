@isTest
public class ContactControllerTest {
    
    @TestSetup
    static void setupTestData() {
        List<Contact> testContacts = new List<Contact>();
        for(Integer i = 0; i < 5; i++) {
            testContacts.add(new Contact(
                FirstName = 'Test' + i,
                LastName = 'Contact' + i,
                Email = 'test' + i + '@example.com',
                Phone = '555-000-000' + i
            ));
        }
        insert testContacts;
    }
    
    @isTest
    static void testGetContacts() {
        Test.startTest();
        List<Contact> contacts = ContactController.getContacts();
        Test.stopTest();
        
        Assert.isNotNull(contacts, 'Contacts list should not be null');
        Assert.isTrue(contacts.size() > 0, 'Should return at least one contact');
        Assert.isTrue(contacts.size() <= 100, 'Should not return more than 100 contacts');
    }
    
    @isTest
    static void testCreateContact() {
        Contact newContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Phone = '555-0000'
        );
        
        Test.startTest();
        Contact createdContact = ContactController.createContact(newContact);
        Test.stopTest();     
        Assert.isNotNull(createdContact.Id, 'Contact should have been created with an Id');
        
        Contact verifyContact = [SELECT Id, FirstName, LastName, Email, Phone 
                                 FROM Contact 
                                 WHERE Id = :createdContact.Id];
        Assert.areEqual('John', verifyContact.FirstName, 'First name should match');
        Assert.areEqual('Doe', verifyContact.LastName, 'Last name should match');
    }
    
    @isTest
    static void testCreateContactError() {
        Contact invalidContact = new Contact();
        
        Test.startTest();
        try {
            ContactController.createContact(invalidContact);
            Assert.fail('Should have thrown an exception');
        } 
        catch(AuraHandledException e) {
            
            Assert.isFalse(e.getMessage().contains('Error creating contact:'), 
                          'Error message should contain our custom prefix');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateContact() {
        Contact contact = [SELECT Id, FirstName, LastName, Email, Phone 
                           FROM Contact 
                           WHERE FirstName LIKE 'Test%' 
                           LIMIT 1];
        
        contact.FirstName = 'Updated';
        contact.LastName = 'Name';        
        Test.startTest();
        Contact updatedContact = ContactController.updateContact(contact);
        Test.stopTest(); 
        Contact verifyContact = [SELECT Id, FirstName, LastName 
                                 FROM Contact 
                                 WHERE Id = :contact.Id];
        Assert.areEqual('Updated', verifyContact.FirstName, 'First name should be updated');
        Assert.areEqual('Name', verifyContact.LastName, 'Last name should be updated');
    }
    
    @isTest
    static void testUpdateContactError() {
        Contact contact = [SELECT Id FROM Contact WHERE FirstName LIKE 'Test%' LIMIT 1];
        contact.LastName = null; 
        
        Test.startTest();
        try {
            ContactController.updateContact(contact);
            Assert.fail('Should have thrown an exception');
        } catch(AuraHandledException e) {
            Assert.isFalse(e.getMessage().contains('Error updating contact:'), 
                          'Error message should contain our custom prefix');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteContact() {
        Contact contact = [SELECT Id FROM Contact WHERE FirstName LIKE 'Test%' LIMIT 1];        
        Test.startTest();
        ContactController.deleteContact(contact.Id);
        Test.stopTest();
        List<Contact> deletedContact = [SELECT Id FROM Contact WHERE Id = :contact.Id];
        Assert.areEqual(0, deletedContact.size(), 'Contact should have been deleted');
    }
    
    @isTest
    static void testDeleteContactError() {
        Test.startTest();
        try {
            ContactController.deleteContact('003000000000000'); 
            Assert.fail('Should have thrown an exception');
        } 
        catch (AuraHandledException e) {     
            Assert.isFalse(e.getMessage().contains('Error deleting contact: Contact not found.'),
                          'Error message should contain "Contact not found."');
        }
        Test.stopTest();
    }
    
}