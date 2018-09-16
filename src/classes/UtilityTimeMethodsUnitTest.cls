@isTest 
private class UtilityTimeMethodsUnitTest {
    static string ctime;
    static integer iteration;
    static string citem;
    static integer iterations;
    static integer t_end;
    static integer t_beginning;
    static UtilityTimeMethods utm = new UtilityTimeMethods();
    static string ltime;
    static double timework;

    static testMethod void testaddItteration()
    { 
       test.startTest();
        
       ctime = '09:00 AM';
       iteration = 15;
       utm.addItteration(ctime, iteration);
       
       ctime = '09:00 AM';
       iteration = 15;
       utm.addItteration(ctime, iteration);

       ctime = '09:48 AM';
       iteration = 15;
       utm.addItteration(ctime, iteration);


       ctime = '11:48 AM';
       iteration = 15;
       utm.addItteration(ctime, iteration);
   
       ctime = '09:45 AM';
       iteration = 15;
       utm.addItteration(ctime, iteration);
   
       
       ctime = '01:54 PM';
       iteration = 15;
       utm.addItteration(ctime, iteration);
       
       ctime = '11:45 PM';
       iteration = 15;
       utm.addItteration(ctime, iteration);
       
       ctime = '12:45 PM';
       iteration = 15;
       utm.addItteration(ctime, iteration);
       
       ctime = '12:48 PM';
       iteration = 15;
       utm.addItteration(ctime, iteration);
 
 
       test.stopTest(); 

    }

    static testMethod void testLatestTimeForPickListForToday()
   {
    test.startTest();
    for (Integer i = 1; i<=60; i++) {
        utm.LatestTimeForPickListForToday(i);
    }
  //  iteration = 15;    
 //   string retTime = utm.LatestTimeForPickListForToday(iteration);
    test.stopTest();    
   }
 
   static testMethod void LatestTimeForPickList()
   {
   
   iterations = 15;
   t_end = 19;
   t_beginning = 9;

   test.startTest();

   citem = '09:20 PM';
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);

   citem = '09:55 AM';
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);

   citem = '10:00 AM';
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);

   citem = '11:16 AM';
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);
   
   citem = '11:55 AM';
   t_end = 12;
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);

   citem = '12:00 PM';
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);

   citem = '12:55 PM';
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);
   
   
   citem = '01:55 PM';
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);

   citem = '06:15 PM';
   ltime =  utm.LatestTimeForPickList(citem, iterations, t_end, t_beginning);
   
   
   
   test.stopTest();
   }
      static testMethod void  defaultAttendanceTimes()
   {
     datetime dtFrom;
     integer duration;
     boolean timein;
     test.startTest();
     
     dtFrom = datetime.parse('10/12/2012 01:00 PM');
     duration = 240;
     timein = true; 
     citem = utm.defaultAttendanceTimes(dtFrom, duration, timein);

     dtFrom = datetime.parse('10/12/2012 12:00 PM');
     duration = 240;
     timein = true; 
     citem = utm.defaultAttendanceTimes(dtFrom, duration, timein);

    dtFrom = datetime.parse('10/12/2012 10:00 AM');
     duration = 240;
     timein = true; 
     citem = utm.defaultAttendanceTimes(dtFrom, duration, timein);

    dtFrom = datetime.parse('10/12/2012 10:00 AM');
     duration = 240;
     timein = false; 
     citem = utm.defaultAttendanceTimes(dtFrom, duration, timein);


     test.stopTest();
   } 
   
      static testMethod void  testconvertTime()
   {
     test.startTest();
     citem = utm.convertTime(12, true);
     citem = utm.convertTime(1, true);
     citem = utm.convertTime(12, false);



     test.stopTest();
   } 
   
   static testMethod void testCounthours()
   {
       test.startTest();
       timework = utm.Counthours('09:00 AM', '01:00 PM');
       timework = utm.Counthours('02:00 PM', '07:00 PM');
       timework = utm.Counthours('12:00 PM', '07:00 PM');
       
       test.stopTest();
   }
   
   
}