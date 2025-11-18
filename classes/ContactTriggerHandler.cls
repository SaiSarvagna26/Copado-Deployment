public class ContactTriggerHandler {
    public static void ContNameUpd(List<Contact>contactList,Map<Id,Contact> contlist){ 
            Set<String>accountIds=new Set<String>(); 
      
        for(Contact thisContact : contactList){
            if(thisContact.LastName != contlist.get(thisContact.Id).LastName){
                accountIds.add(thisContact.AccountId);
            }
        }	
          Map<Id,Account> accountMap =new Map<Id,Account>([SELECT Id,Name FROM Account WHERE Id IN : accountIds]);
        for(contact thisContact : contactList){
            if(accountMap.containsKey(thisContact.AccountId)){
                accountMap.get(thisContact.AccountId).Name=thisContact.LastName;
            }
        }
        update accountMap.values();
            
        }

}