public with sharing class UtilityTimeMethods {

//  public integer timepart2integer(string timepart, string partValue)
  //{
  //    integer t_part = 20;
   // return t_part;
 // }

   public string addItteration(string ctime, integer iteration)
  {
      string cNextTime = '';
      string h_part = ctime.substring(0,2);

      string m_part1 = ctime.substring(3,8);
      string m_part = m_part1.substring(0,2);

      string am_part = ctime.substring(6,8);
  
        string strNextMin;
        string strNextHours;
       integer intNextMin = integer.ValueOf(m_part) + iteration;
       if (intNextMin <> 60)
          {
            strNextMin = string.ValueOf(intNextMin);
             strNextHours = h_part;
          }
       else 
             {
                integer intNextHour = integer.ValueOf(h_part) + 1;
                if (intNextHour == 13)
                   strNextHours = '01';
                else
                {     
                   strNextHours = String.ValueOf(intNextHour).Trim();
                   if (strNextHours.length() == 1)
                      strNextHours = '0' + strNextHours;
                }   
                if (intNextHour == 12)
                    am_part = 'PM';    
                strNextMin = '00';
         
             }
             if (strNextMin.length() == 1)
                 strNextMin = '0' + strNextMin;
                 cNextTime =  strNextHours + ':' +  strNextMin + ' ' + am_part;
        return cNextTime;

      }
  
      public string LatestTimeForPickListForToday(integer iteration)
     {
       string timeLatest = '';
    //   date todayDate = date.today();
   //    boolean samedate =  false;
       string tNow = datetime.now().format('hh:mm a'); 
       string h_part = tNow.substring(0,2);
       string am_part = tNow.substring(6,8);
       string m_part1 = tNow.substring(3,8);
       string m_part =   m_part1.substring(0,2);
                
       integer intMin = Integer.ValueOf(m_part);
       integer intHours = Integer.valueOf(h_part);
            
            /*    for TIME testing 
              integer iteration = 10;
               integer intMin = 25;
                double min2add = intMin + iteration;
                double minTop = math.ceil((double)(min2add));
                integer min1 = integer.valueof(mintop) ;
                integer min2 = math.round(min1/iteration);
                integer newMin = min2* iteration;
                    system.debug('!!!!  ' +  minTop + '     min2 ' + min2  + '   new min: ' + newMin);
             */ 

            double min2add = intMin + iteration;             //add iteration to Current minutes
            double minCeil = math.ceil((double)(min2add));   // set to ceil value:   15.3 -> 16 
            integer min1 = integer.valueof(minCeil) ;         // convert to integer
            integer min2 = math.round(min1/iteration);      // count number of interations
            intMin = min2 * iteration;              // set latest TIME for picklist  
             
          if (intMin >= 60)
               {
                    intHours ++;
                   if (intHours >= 12)
                         am_part = 'PM';
                    if (intHours == 13)
                          intHours = 1;
                  
                  intMin = intMin-=60;
                     
            }
         
         timeLatest = h_part + ':' + m_part + ' ' + am_part;
          
         return timeLatest;
     }
      public string LatestTimeForPickList(string citem, integer iterations, integer t_end,
           integer t_beginning)
      {
      string t_timeEnd;
      string am_part = citem.substring(6,8);
       if (am_part == 'PM' && t_beginning < 12) 
         t_beginning += 12;
         integer minbreak = 60/iterations - 1;
         if (t_end > 12)
           {
             integer t2 = t_end - 12;
             if (t2 < 10)
               t_timeEnd =  '0' + string.valueof(t2) + ':00 PM';
             else
               t_timeEnd =  string.valueof(t2) + ':00 PM';
           }
          else
           { 
             if (t_end == 12)
               t_timeEnd =  '12:00 PM';
             else
               t_timeEnd =   string.valueof(t_end).trim() + ':00 AM';
            }
        return  t_timeEnd; 
      }  
      public string FirstTimeForPickList(integer iterations)
      {
         string t_timeBeg = '03:00 PM';   
         //string.valueof(t_end).trim() + ':00 AM';
         return t_timeBeg;
      }
      
      public string convertTime(integer tBegTime, boolean late)
      {
          string ctime;
          string s_timeBeg;
          string am = 'AM';
          s_timeBeg = string.ValueOf(tBegTime);                   
          ctime = s_timeBeg;
          if (tBegTime == 12)
              am = 'PM';
          else
             if (tBegTime > 12)
             {
                 tBegTime -= 12;
                 s_timeBeg = string.ValueOf(tBegTime);
                 am = 'PM';
             }
            if (s_timeBeg.length() == 1)
                ctime = '0' + s_timeBeg;
            else 
                ctime = s_timeBeg;    
            if (late == true)
               s_timeBeg = ctime + ':15 ' + am;
            else 
               s_timeBeg = ctime + ':00 ' + am;
        return s_timeBeg; 
      }
      
      public string defaultAttendanceTimes(datetime dtFrom, integer duration, boolean ltime)
      {
        string ctime;
        string sMinutes;
        string sHours;
        integer hFrom;
        integer mFrom ;
        integer minutesTo;
        integer hTo;
        integer mTo;
        string am_part = ' AM';     
        string timeFrom;  
          
        timeFrom = dtFrom.format('hh:mm a');
        hFrom =dtFrom.hour();
        mFrom =dtFrom.minute();
 
        if (ltime == true)   
         {
           // Generate default TIME IN            
           if (hFrom >= 12 )
               am_part = ' PM';
            If (hFrom > 12)
               hFrom -=12;
            sHours =  String.ValueOf(hFrom).Trim();
            if (sHours.length() == 1)
                sHours = '0' + sHours;   
            sMinutes =  String.ValueOf(mFrom).Trim();
            if (sMinutes.length() == 1)
               sMinutes = '0' + sMinutes;
            ctime = sHours + ':' + sMinutes + am_part; 
      
         }
         else 
         {
            minutesTo = hFrom  * 60 + mFrom +  duration; 
            hTo = minutesTo / 60;
            mTo = minutesTo - hTo*60;  
            if (hTo >= 12)
                am_part = ' PM';
            if (hTo > 12)
                hTo -=12; 
            sMinutes =  String.ValueOf(mTo).Trim();
            if (sMinutes.length() == 1)
                sMinutes = '0' + sMinutes;
            sHours =  String.ValueOf(hTo).Trim();
            if (sHours.length() == 1)
               sHours = '0' + sHours;
              ctime = sHours + ':' + sMinutes + am_part; 
         }
        return ctime;
      }
      public decimal counthours(string timein, string timeout)
      {
        decimal h_worked = 0;
        integer diffHours;
        integer diffMins;
        integer h_partIn = integer.valueOf(timein.substring(0,2));
        string m_part1 = timein.substring(3,8);
        integer m_partIn = integer.valueOf(m_part1.substring(0,2));
        string am_partIn = timein.substring(6,8).trim();
        
        integer h_partOut = integer.valueOf(timeOut.substring(0,2));
        m_part1 = timeOut.substring(3,8);
        integer  m_partOut = integer.valueOf(m_part1.substring(0,2));
        string am_partOut = timeOut.substring(6,8).trim();

        if ((am_partIn == 'AM' && am_partOut == 'AM') || 
            (am_partIn == 'PM' && am_partOut == 'PM') )
         {
            if(am_partIn == 'PM' && h_partIn == 12)
               h_partOut +=12;
            diffHours = h_partOut - h_partIn;     
            if (m_partOut >= m_partIn)
               h_worked = diffHours*60 + m_partOut - m_partIn;
            else
            { 
                diffHours -= 1;
                m_partOut += 60;
                h_worked = diffHours*60 + m_partOut - m_partIn;
            }  
        }    
        else
        {
        if (h_partIn <> 12 && h_partOut <> 12 )
             h_partOut +=12;
              diffHours = h_partOut - h_partIn;     
            if (m_partOut >= m_partIn)
               h_worked = diffHours*60 + m_partOut - m_partIn;
            else
            { 
                diffHours -= 1;
                m_partOut += 60;
                h_worked = diffHours*60 + m_partOut - m_partIn;
            }  
                    
        }

        return h_worked; 
        
      }
  
     public string endtime(string timeIn, integer duration)
      {
       	
//    string timein = '11:00 AM'; 
//integer duration = 90;
string h_part = timeIn.substring(0,2);

string m_part = timeIn.mid(3,2);
system.debug('\n\n XXX m_part: ' + m_part);
     string am_part = ' ' + timeIn.mid(6,2);
       integer  hFrom = integer.valueOf(h_part);
       integer mFrom = 0;
       if (m_part <> '00') 
          mFrom = integer.valueOf(m_part);
       integer minutesTo ;
       minutesTo = hFrom  * 60 + mFrom +  duration; 
       integer hTo = minutesTo / 60;
       integer mTo = minutesTo - hTo*60;  
       if (hTo >= 12)
          am_part = ' PM';
           if (hTo > 12)
                hTo -=12; 
            string sMinutes =  String.ValueOf(mTo).Trim();
            if (sMinutes.length() == 1)
                sMinutes = '0' + sMinutes;
            string sHours =  String.ValueOf(hTo).Trim();
            if (sHours.length() == 1)
               sHours = '0' + sHours;
            string ctime = sHours + ':' + sMinutes +  am_part; 

      return ctime;
      }
      
}