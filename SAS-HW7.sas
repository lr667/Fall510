*3.3 hapter3.2Levels1,2,andChallenge;;
%let path=/folders/myfolders/Data_One;
libname orion "/folders/myfolders/Data_One";



*Ch3.2;

*4-a;
*Read country data set from orion library;
*And then find the answer directly from the data set;
proc print data=orion.country;
run;
*There were 7 observations read from the data set ORION.COUNTRY.;
*There were 6 variables read from the data set ORION.COUNTRY.;
*South Africa;


*4-b;
proc contents data=orion._all_ nods;
run;
*What is the name of the last member listed?
*US_SUPPLIERS;


*5-a;
proc contents data=orion.staff;
run;
*5-b
/*What sort information is stored for this data set? The General 
Information section indicates that the data set is sorted. The 
Variable section indicates that it is sorted by Employee_ID using 
the ANSI character set, and has been validated.

6. SAS Autoexec File
What is the name of the file? autoexec.sas
What is its purpose? It contains SAS statements that are executed immediately after SAS initializes. These SAS statements can be used to invoke SAS programs automatically, set up certain variables for use during your SAS session, or set system options.
How is it created? With any text editor, but the recommended method is to use a SAS text editor (such as the Enhanced Editor window) and save it using the Save As dialog box.
How could this be useful in a SAS session? It can be used to set the path macro variable and to automatically submit a LIBNAME statement.
*/;

*Ch4;
*1;
*a;
proc print data=orion.order_fact noobs;

*d If the Obs column is suppressed, how can you verify the number of observations in the results?
Check the log;
*b;	sum Total_Retail_Price;
*c; where Total_Retail_Price>500;
*the number are not sequential. The origin observation numbers are displayed.;
*e; id Customer_ID;
*When the ID statement was added, how did the output change? 
Customer_ID is the leftmost column and is displayed on each 
line for an observation.;
*f,g; var Order_ID Order_Type Quantity Total_Retail_Price;
*There are two Customer_ID columns. The first column is the ID field, 
and a second one is included because Customer_ID is listed in the VAR statement.;
*g Remove the duplicate column by removing Customer_ID from the VAR statement.;


run;


*2;
proc print data=orion.customer_dim noobs;*b;
   where Customer_Age between 30 and 40;
   var Customer_Name Customer_Age Customer_Type;
   
*c;id Customer_ID;
run;


*5;
*a;
proc sort data = orion.employee_payroll
			out= work.sort_salary;
		by Salary;
run;
*b;
proc print data=work.sort_salary;
run;


*6;
*a;
proc sort data = orion.employee_payroll
			out= work.sort_salary2;
		by Employee_Gender descending Salary;
run;
*b;
proc print data=work.sort_salary2;
   by Employee_Gender;
run;




*7;
proc sort data=orion.employee_payroll 
			out=work.sort_sal;
   by Employee_Gender descending Salary;
run;
proc print data=work.sort_sal noobs;
   by Employee_Gender;
   sum Salary;
   where Employee_Term_Date is missing and Salary>65000;
   var Employee_ID Salary Marital_Status;
run;


*9;
*c; title1 'Australian Sales Employees';
	title2 'Senior Sales Representatives';
	footnote1 'Job_Title: Sales Rep. IV';
proc print data=orion.sales noobs;
   where Country='AU' and Job_Title contains 'Rep. IV';
*b;   var Employee_ID First_Name Last_Name Gender Salary;
run;
*e; title;
	footnote;


*10;
*a;
title 'Entry-level Sales Representatives';
footnote 'Job_Title: Sales Rep. I';
proc print data=orion.sales noobs label;
   where Country='US' and Job_Title='Sales Rep. I';
   var Employee_ID First_Name Last_Name Gender Salary;
   label Employee_ID="Employee ID"
         First_Name="First Name"
         Last_Name="Last Name"
         Salary="Annual Salary";
run;
title;
footnote;
*b;
title 'Entry-level Sales Representatives';
footnote 'Job_Title: Sales Rep. I';
proc print data=orion.sales noobs split=' ';
   where Country='US' and Job_Title='Sales Rep. I';
   var Employee_ID First_Name Last_Name Gender Salary;
   label Employee_ID="Employee ID"
         First_Name="First Name"
         Last_Name="Last Name"
         Salary="Annual Salary";
run;
title;
footnote;



*11;
proc sort data=orion.employee_addresses out=work.address;
   where Country='US';
   by State City Employee_Name;
run;
title "US Employees by State";
proc print data=work.address noobs split=' ';
   var Employee_ID Employee_Name City Postal_Code;
   label Employee_ID='Employee ID'
         Employee_Name='Name'
         Postal_Code='Zip Code';
   by State;
run;



*Ch5;
*1;
proc print data=orion.employee_payroll;
*b;   var Employee_ID Salary Birth_Date Employee_Hire_Date;
*c;   format Salary dollar11.2 Birth_Date mmddyy10.
          Employee_Hire_Date date9.;
run;
*2;
title1 'US Sales Employees';
title2 'Earning Under $26,000';
proc print data=orion.sales label noobs;
   where Country='US' and Salary<26000;
   var Employee_ID First_Name Last_Name Job_Title Salary Hire_Date;
   label First_Name='First Name'
         Last_Name='Last Name'
         Job_Title='Title'
         Hire_Date='Date Hired';
   format Salary dollar10. Hire_Date monyy7.;
run;
title;
footnote;

*4;
*a;
data Q1Birthdays;
   set orion.employee_payroll;
   BirthMonth=month(Birth_Date);
   if BirthMonth le 3;
run;

proc format;
*b;
   value $gender
      'F'='Female'
      'M'='Male';
*c;
   value mname
       1='January'
       2='February'
       3='March';
run;
*d
title 'Employees with Birthdays in Q1';
proc print data=Q1Birthdays;
   var Employee_ID Employee_Gender BirthMonth;
   format Employee_Gender $gender.
          BirthMonth mname.;



*5;
proc format;
*b;

   value $gender
        'F'='Female'
        'M'='Male'
      other='Invalid code';
      
      
*c;
   value salrange  .='Missing salary'
       20000-<100000='Below $100,000'
       100000-500000='$100,000 or more'
               other='Invalid salary';
run;

*d;
title1 'Salary and Gender Values';
title2 'for Non-Sales Employees';
proc print data=orion.nonsales;
   var Employee_ID Job_Title Salary Gender;
   format Salary salrange. Gender $gender.;
run; title;



*Ch6;
*5;
data work.delays;
*a;
   set orion.orders;
*b;
   Order_Month=month(Order_Date);
*c;
   where Order_Date+4<Delivery_Date
         and Employee_ID=99999999;

   if Order_Month=8;
*e;
   label Order_Date='Date Ordered'
         Delivery_Date='Date Delivered'
         Order_Month='Month Ordered';
*f;      
	format Order_Date Delivery_Date mmddyy10.;
*d;
   keep Employee_ID Customer_ID Order_Date Delivery_Date
        Order_Month;
run;
*g;
proc contents data=work.delays;
run;
*h;
proc print data=work.delays;
run;





*Ch9;
*2;
data work.birthday;
*a;
   set orion.customer;
*b1;
   Bday2012=mdy(month(Birth_Date),day(Birth_Date),2012);
*b2;
   BdayDOW2012=weekday(Bday2012);
*b3;
   Age2012=(Bday2012-Birth_Date)/365.25;
*c;
   keep Customer_Name Birth_Date Bday2012 BdayDOW2012 Age2012;
*d;
   format Bday2012 date9. Age2012 3.;
run;
*e;
proc print data=work.birthday;
run;

*6;
data work.season;
*a;
   set orion.customer_dim;
   length Promo2 $ 6;
   Quarter=qtr(Customer_BirthDate);
*b1;
   if Quarter=1 then Promo='Winter';
   else if Quarter=2 then Promo='Spring';
   else if Quarter=3 then Promo='Summer';
   else if Quarter=4 then Promo='Fall';
*b2;
   if Customer_Age>=18 and Customer_Age<=25 then  Promo2='YA';
   else if Customer_Age>=65 then  Promo2='Senior';
*c;
   keep Customer_FirstName Customer_LastName Customer_BirthDate
        Customer_Age Promo Promo2;
run;
*d;
proc print data=work.season;
   var Customer_FirstName Customer_LastName Customer_BirthDate Promo
       Customer_Age Promo2;
run;



*7;
data work.ordertype;
*a;
   set orion.orders;
   length Type $ 13 SaleAds $ 5;
   DayOfWeek=weekday(Order_Date);
   if Order_Type=1 then
      Type='Retail Sale';
   else if Order_Type=2 then do;
      Type='Catalog Sale';
     SaleAds='Mail';
   end;
   else if Order_Type=3 then do;
      Type='Internet Sale';
     SaleAds='Email';
end;
   drop Order_Type Employee_ID Customer_ID;
run;
proc print data=work.ordertype;
run;




*Ch10;
*1;
*a;
proc contents data=orion.charities;
run;
proc contents data=orion.us_suppliers;
run;
proc contents data=orion.consultants;
run;

*b;
data work.contacts;
   set orion.charities orion.us_suppliers;
run;
*c;
proc contents data=work.contacts;
run;
*the first data set in the set statement, orion.charities;


*d;
data work.contacts2;
   set orion.us_suppliers orion.charities;
run;
*e;
proc contents data=work.contacts2;
run;
*the first data set in the set statement, orion.us_suppliers;

*f;
data work.contacts3;
   set  orion.us_suppliers orion.consultants;
run;
*ContactType has been defined as both character and numeric.;





*5;
*a;
proc sort data=orion.product_list
          out=work.product_list;
   by Product_Level;
run;
*b;
data work.listlevel;
   merge orion.product_level work.product_list ;
   by Product_Level;
   keep Product_ID Product_Name Product_Level Product_Level_Name;
run;
*c; 
proc print data=work.listlevel noobs;
   where Product_Level=3;
run;




*8;
proc sort data=orion.customer
          out=work.customer;
   by Country;
run;
data work.allcustomer;
   merge work.customer(in=Cust)
         orion.lookup_country(rename=(Start=Country
                                      Label=Country_Name) in=Ctry);
   by Country;
   keep Customer_ID Country Customer_Name Country_Name;
   if Cust=1 and Ctry=1;
run;
proc print data=work.allcustomer;
run;
















 








