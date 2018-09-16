global class jobUpdateNumberofDaysinCycle {

    global utilityIds clsUtilIds = new utilityIds();

    global void UpdateDayCounts(Integer intLimit, Date dteStart, Date dteEnd) {
        
        // this method can be run 2 ways. 
        // 1. You can update intLimit number of clients that have a blank value for Number of Days in Cycle.
        // 2. You can update the values for clients that had a detained date in the date range
        // or who are currently active/ in detention. This is used for the nightly run
        
        list<Program_Cycle__c> lstCyclesForLoop = new list<Program_Cycle__c>();
        set<Id> setAffectedClientIds = new set<Id>();
        list<Tier__c> lstTierstoClose = new list<Tier__c>();    
        list<Tier__c> lstNew120DayTiers = new list<Tier__c>();  
        
        // if this method is run for a specified date range (nightly update)
        if(dteStart != null && dteEnd != null) {
            
            //find all records modified in the date range, and active clients and clients w/ open detainments
            
            list<Program_Cycle__History> lstCycleHistory = [select ParentId from Program_Cycle__History 
                where Field = 'End_Date__c' and CreatedDate >= :dteStart and CreatedDate <= :dteEnd];
                
            list<Id> lstCycleIdsfromHistory = new list<Id>();
            
            for(Program_Cycle__History h: lstCycleHistory) {
                
                lstCycleIdsfromHistory.add(h.ParentId);
            }
            
            list<Program_Cycle__c> lstCycles = [select Client__c from Program_Cycle__c 
                                                where id in :lstCycleIdsfromHistory and RecordTypeID = :clsUtilIds.progCycleChoices];
                                              
            list<Detained_Dates__c> lstAllDetainedDates = [select Contact_Detained_Dates_Lookup__c
                from Detained_Dates__c
                where LastModifiedDate >= :dteStart and LastModifiedDate <= :dteEnd
                and Contact_Detained_Dates_Lookup__r.RecordtypeId in (:clsUtilIds.conBXChoices, :clsUtilIds.conMNChoices)
                Order By CreatedDate desc Limit 200];       
                                              
            list<Detained_Dates__c> lstOpenDetainedDates = [select Contact_Detained_Dates_Lookup__c
                from Detained_Dates__c
                where Date_Released__c = null 
                and Contact_Detained_Dates_Lookup__r.RecordtypeId in (:clsUtilIds.conMNChoices, :clsUtilIds.conBXChoices)];                                        
                                              
            list<contact> lstActiveClients = [select Id, Client_Status__c, Intake_Date__c from Contact 
                where RecordTypeId in (:clsUtilIds.conBXChoices,  :clsUtilIds.conMNChoices) and Client_Status__c = 'Active'];
            
            //generate lists of clients for scoped loop
            
            for(Program_Cycle__c pc: lstCycles) {
                
                setAffectedClientIds.add(pc.Client__c);
            }
                        
            for(Detained_Dates__c d: lstAllDetainedDates) {
                
                setAffectedClientIds.add(d.Contact_Detained_Dates_Lookup__c);
            }
            
            for(Contact c: lstActiveClients) {
                
                setAffectedClientIds.add(c.Id); 
            }
                
            for(Detained_Dates__c d: lstOpenDetainedDates ) {
    
                setAffectedClientIds.add(d.Contact_Detained_Dates_Lookup__c);
            }
            
            //exit method if there are no clients that need to be updated
            if(setAffectedClientIds.size() == 0) {
                
                system.debug('No clients found, exiting method.');
                system.debug('\n List of clients: ' + setAffectedClientIds);
                return;
            }       
            
            //get contact lists and maps from id sets for loop
            lstCyclesForLoop = [select id, Number_of_Days_in_Program_Cycle__c
                                              from Program_Cycle__c where Client__c in :setAffectedClientIds];      
            
        }           
        
        // if this method is looking for contacts with blank values
        else {              
        //get client lists
            lstCyclesForLoop = [select id, Number_of_Days_in_Program_Cycle__c
                                              from Program_Cycle__c
                                              where RecordTypeId = :clsUtilIds.progCycleChoices
                                              and Number_of_Days_in_Program_Cycle__c = null
                                              limit :intLimit]; 
        }
        
        //get client actions to convert to strings
                                          
        list<Detained_Dates__c> lstDetainedDates = [select id, Contact_Detained_Dates_Lookup__c, Detained_Date__c, 
            Date_Released__c, LastModifiedDate 
            from Detained_Dates__c where Contact_Detained_Dates_Lookup__c in :setAffectedClientIds
            order by Contact_Detained_Dates_Lookup__c asc, Detained_Date__c asc];       
        
        list<Program_Cycle__c> lstAllCycles = [select Id, Client__c, Number_Of_Days_in_Program_Cycle__c, 
            Most_Recent_Program_Cycle_formula__c, Start_Date__c, End_Date__c
            from Program_Cycle__c where Client__c in :setAffectedClientIds];        


        //Get tiers to close if the cycles have hit 120 days. Only get the most recent tier, and ignore
        //tiers that are 120 day tiers, we don't want to close and make new copies of those
        //if a change is made to a cycle that was already calculated as hitting 120 days
        list<Tier__c> lstTiers = [select id, End_Date__c, Tier__c, Program_Cycle__c from Tier__c
            where Most_Recent_Tier_formula__c = true and Reason_for_Tier_Change__c != '120 Days in Cycle'
            and Contact__c in :setAffectedClientIds];           
        
        Date dteStopCounting = date.newInstance(1950,1,1);
        Integer intDaysDetained = 0;
        Integer intDaysActive = 0;
        Date dteLastReleased = date.newInstance(1950,1,1);
        Date dte120DaysinCycle = date.newInstance(1950,1,1);
        Integer i = 0;
        
        //match program cycles to detained dates
        for(Program_Cycle__c pc: lstAllCycles) {
            
            //reset for new cycle
            intDaysDetained = 0;
            intDaysActive = 0;  
            dteLastReleased = pc.Start_Date__c;
            dte120DaysinCycle = date.newInstance(1950,1,1);
            i = 0;                  
            
            for(Detained_Dates__c d: lstDetainedDates) {
                
                //reset
                dteStopCounting = date.newInstance(1950,1,1);
                
                if(d.Contact_Detained_Dates_Lookup__c == pc.Client__c 
                && d.Detained_Date__c >= pc.Start_Date__c 
                && (d.Detained_Date__c <= pc.End_Date__c || pc.End_Date__c == null)) {
                    
                    //use earliest non-null date of the set (detention end date, cycle end date, today)
                    if(d.Date_Released__c == null && pc.End_Date__c == null) {
                        
                        dteStopCounting = system.today();
                    } else if (d.Date_Released__c == null) {
                        
                        dteStopCounting = pc.End_Date__c;
                    } else if (pc.End_Date__c == null) {
                        
                        dteStopCounting = d.Date_Released__c;
                    } else if (d.Date_Released__c < pc.End_Date__c) {
                        
                        dteStopCounting = d.Date_Released__c;
                    } else {
                        
                        dteStopCounting = pc.End_Date__c;
                    }
                    
                    //add to the sum of detained dates
                    intDaysDetained += d.Detained_Date__c.daysBetween(dteStopCounting) + 1;
                    
                    //calculate number of days active (after 120 days in cycle, create a new tier)
                    
                    // if this new "active" period will push the client over 120 days
                    // for the first time, set the 120 day date
                    
                    if((intDaysActive + dteLastReleased.daysBetween(d.Detained_Date__c) + 1) >= 120
                    && dte120DaysinCycle == date.newInstance(1950,1,1)) {
                        
                        dte120DaysinCycle = dteLastReleased.addDays(120 - intDaysActive);
                    }
                    
                    //if this is the first detained date, dteLastReleased starts at the beginning 
                    //of the cycle, otherwise it starts at the last detained date.
                    //Calculate the days between the date released and the start of the new detention                       
                    intDaysActive += dteLastReleased.daysBetween(d.Detained_Date__c) + 1;
                        
                    dteLastReleased = dteStopCounting.addDays(1);
                    
                    system.debug(intDaysActive);
                    system.debug(dteLastReleased);
                    system.debug(dte120DaysinCycle);
                    
                    //tracks which detained date we are on
                    i++;
                }
            }   
            
            //if there were no detained Dates, calculate 120 day date
            if(i == 0) {
                
                dte120DaysinCycle = pc.Start_Date__c.addDays(120);
            }
            
            //set value
            if(pc.End_Date__c != null) {
                pc.Number_of_Days_in_Program_Cycle__c = pc.Start_Date__c.daysBetween(pc.End_Date__c) + 1 - intDaysDetained; 
            } else {
                pc.Number_of_Days_in_Program_Cycle__c = pc.Start_Date__c.daysBetween(system.today()) + 1 - intDaysDetained; 
            }
            
            //only go through loop if this is an active cycle, and at/over the 120 day mark
            if(pc.End_Date__c == null && pc.Number_of_Days_in_Program_Cycle__c >= 120) {
                
                for(Tier__c t: lstTiers) {
                    
                    if(t.Program_Cycle__c == pc.Id) {
                        
                        //close current tier
                        t.End_Date__c = dte120DaysinCycle;
                        lstTierstoClose.add(t);
                        //add new tier
                        Tier__c newTier = new Tier__c();
                        newTier.Program_Cycle__c = pc.id;
                        newTier.Start_Date__c = t.End_Date__c.addDays(1);
                        newTier.Tier__c = t.Tier__c;
                        newTier.Reason_for_Tier_Change__c = '120 Days in Cycle';
                        lstNew120DayTiers.add(newTier);
                    }
                }
            }
        }   
        
        
        // attempt to update contact records and send error email if necessary
        Database.SaveResult[] lstResults = Database.Update(lstAllCycles, false);
        string strErrorListforEmail = 'The following cycles did not update during the Set All method of the jobUpdateNumberofDaysinCycle class. \n \n';
        integer i2 = 0;
        Boolean bolSendEmail = false;
            
        //email handling
        for(Database.SaveResult res: lstResults) {
            
            if(!res.isSuccess()) {  
                for(Database.Error err: res.getErrors()) {
                    strErrorListforEmail = strErrorListforEmail + 'Cycle: ' + lstAllCycles[i2].Id + '\nError: ' + err.getMessage() + '\n \n';
                }
                
                bolSendEmail = true;
            }   
            
            i2++;
        }
        
        if(bolSendEmail) {
            
             Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
             mail.setTargetObjectId('00560000001jFOg'); // Matt Britton
             mail.setSubject('Apex error in jobUpdateNumberofDaysinCycle()');
             mail.setPlainTextBody(strErrorListforEmail);
             mail.saveAsActivity = false;
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }   
        
        update lstTierstoClose;
        insert lstNew120DayTiers;   
        
    }       

}// end of class