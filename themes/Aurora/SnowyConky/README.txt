  
###########################
Change the weather location
###########################

1. First you need to obtain your location id i.e. WOEID (Where On Earth Id), 
   visit http://weather.yahoo.com and seach your location.

Example: Search for San Fransisco. Then you will be redirected to this page: 
http://weather.yahoo.com/united-states/california/san-francisco-2487956/ 
The number on the end of the url, i.e. 2487956, is the WOEID of San Fransisco.

2. Copy the id number and open the `snowyrc` in an editor. Search for 2286457 
   and replace it with your WOEID. 
   
3. In case the weather icon doesn't update, kill the running conky process by 
   this command: killall conky
   Now start the conky again by this command:
   conky -c /home/<your_username>/.conky/SnowyConky/snowyrc
   








   
  
