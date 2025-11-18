trigger ContactTrigger on Contact (after Update) {
    if(Trigger.isUpdate && Trigger.isAfter){
      ContactTriggerHandler.ContNameUpd(Trigger.New,Trigger.oldMap);
        
    }
    

}