------Create tables


CREATE TABLE members(
mID int IDENTITY(1,1) PRIMARY KEY,
addressID int NOT NULL FOREIGN KEY(addressID) REFERENCES address(addressID),
first_name nvarchar(200) NOT NULL,
last_name nvarchar(200) NOT NULL,
middle_name nvarchar(200),
date_of_birth date NOT NULL,
email nvarchar(100) NOT NULL,
tel_contact nvarchar(100) NOT NULL
)

CREATE TABLE address(
addressID int IDENTITY(1,1) PRIMARY KEY,
address1 nvarchar(200) NOT NULL,
address2 nvarchar(200) NULL,
postcode nvarchar(50) NOT NULL)


CREATE TABLE city(
cityID int IDENTITY(1,1) PRIMARY KEY,
city nvarchar(200) NOT NULL,
addressID int NOT NULL FOREIGN KEY(addressID) REFERENCES address(addressID),
mID int NOT NULL FOREIGN KEY (mID) REFERENCES members(mID)
)

CREATE TABLE member_status(
mstatusID int IDENTITY(1,1) PRIMARY KEY,
Membership_start_date date NOT NULL,
Membership_end_date date NOT NULL,
mID int NOT NULL FOREIGN KEY (mID) REFERENCES members(mID)
)


CREATE TABLE login(
loginID int IDENTITY(1,1) PRIMARY KEY,
mID int NOT NULL FOREIGN KEY (mID) REFERENCES members(mID),
username nvarchar(200) UNIQUE NOT NULL,
password nvarchar(50) NOT NULL CHECK(password like '%[0-9]%' and password like '%[A-Z]%' and password like '%[!@#$%a^&*()-_+=.,;:"`~]%' and len(password) >= 8)
)

CREATE TABLE item(
itemID int IDENTITY(1,1) PRIMARY KEY,
item_title nvarchar(200) NOT NULL,
author nvarchar(200) NOT NULL,
publication_year date NOT NULL,
date_added date NOT NULL,
current_item_status nvarchar(200) NOT NULL,
mID int NOT NULL FOREIGN KEY (mID) REFERENCES members(mID)
)


CREATE TABLE LoanPayment(
paymentID int IDENTITY(1,1) PRIMARY KEY,
payment_date date NULL,
payment_time time Null,
payment_method nvarchar(200) Null
)


CREATE TABLE Loan(
loanID int IDENTITY(1,1) PRIMARY KEY,
date_collected date NULL,
item_dueDate date Null,
date_returned date Null,
itemID int NOT NULL FOREIGN KEY (itemID) REFERENCES item(itemID)
)


CREATE TABLE itemLoan(
itemLoanID int IDENTITY(1,1) PRIMARY KEY,
mID int NOT NULL FOREIGN KEY (mID) REFERENCES members(mID),
loanID int NOT NULL FOREIGN KEY (loanID) REFERENCES Loan(loanID),
itemID int NOT NULL FOREIGN KEY (itemID) REFERENCES item(itemID),
paymentsID int NOT NULL FOREIGN KEY (paymentsID) REFERENCES LoanPayment(paymentID)
)

CREATE TABLE itemType(
itemTypeID int IDENTITY(1,1) PRIMARY KEY,
itemID int NOT NULL FOREIGN KEY (itemID) REFERENCES item(itemID),
item_type nvarchar(200) NOT NULL,
item_lib_location nvarchar(200) NOT NULL,
ISBN nvarchar(200) NOT NULL,
item_genre nvarchar(200) NOT NULL
)


CREATE TABLE fines(
fineID int IDENTITY(1,1) PRIMARY KEY,
itemLoanID int NOT NULL FOREIGN KEY (itemLoanID) REFERENCES itemLoan(itemLoanID),
fine_type nvarchar(200) NOT NULL,
fine_totalAmount money Null,
paid_fine money NULL,
date_fined date Null,
fine_status nvarchar(200) NULL
)


ALTER TABLE members
ADD CONSTRAINT chkemail CHECK(email LIKE '%_@_%._%')







  INSERT INTO city(DepartmentEmail, DepartmentTelephone,
  DepartmentName)
  VALUES ('operations@salfordbuildingprojects.co.uk', '0161 1234590','Operations'),
  ('sales@salfordbuildingprojects.co.uk', '0161 1234591','Sales')

  --Insert data into our data base from an another table containing all our input data

INSERT INTO [dbo].[address]([address1], [address2], [postcode])
SELECT DISTINCT m.Address1, m.Address2, m.Postcode
FROM [dbo].[Main-Input-Data] m;

use library
GO

INSERT INTO [dbo].[members]([addressID],[first_name],[last_name],[middle_name],[date_of_birth],[email],[tel_contact])
SELECT DISTINCT m.[addressID],m.[first_name],m.[last_name],m.[middle_name],m.[date_of_birth],m.[email],m.[tel_contact]
FROM [dbo].[Main-Input-Data] m;


INSERT INTO city ([city], [addressID], [mID])
SELECT DISTINCT m.[City], m.[addressID], m.[mID]
FROM [dbo].[Main-Input-Data] m;


INSERT INTO login([mID], [username],[password])
SELECT DISTINCT m.[mID], m.[username], m.[password]
FROM [dbo].[Main-Input-Data] m;

INSERT INTO [dbo].[LoanPayment]([payment_date], [payment_time],[payment_method])
SELECT DISTINCT m.[payment_date], m.[payment_time], m.[payment_method]
FROM [dbo].[Main-Input-Data] m;

INSERT INTO [dbo].[Loan]([date_collected], [item_dueDate],[date_returned],[paymentID])
SELECT DISTINCT m.[date_collected], m.[item_dueDate] , m.[date_returned], m.[paymentID]
FROM [dbo].[Main-Input-Data] m;

  
INSERT INTO [dbo].[item]([item_title], [author],[publication_year],[date_added], [current_item_status], [mID])
SELECT DISTINCT m.[Item_title], m.[Author], m.[Publication_year], m.[date_added], m.[current_item_status], m.[mID]
FROM [dbo].[Main-Input-Data] m;

INSERT INTO [dbo].[itemLoan]([mID], [loanID], [itemID], paymentsID)
SELECT DISTINCT m.[mID], m.[loanID], m.[itemID], m.paymentID
FROM [dbo].[Main-Input-Data] m;

INSERT INTO [dbo].[itemType]([itemID], [item_type], [item_lib_location], [ISBN], [item_genre])
SELECT DISTINCT m.[itemID], m.[Item_type],m.[item_lib_location], m.[ISBN],  m.[item_genre]
FROM [dbo].[Main-Input-Data] m;


INSERT INTO [dbo].[fines]([itemLoanID], [fine_type], [fine_totalAmount], [paid_fine], [date_fined])
SELECT DISTINCT m.[itemLoanID], m.[fine_type], m.[fine_totalAmount], m.[paid_fine], m.[date_fined]
FROM [dbo].[Main-Input-Data] m;

INSERT INTO [dbo].[member_status]([Membership_start_date], [Membership_end_date], [mID])
SELECT DISTINCT m.[Membership_start_date], [Membership_end_date], m.[mID]
FROM [dbo].[Main-Input-Data] m;


---Inspect my input data
select * from address

select * from city

select * from fines

select * from item

select * from itemLoan

select * from itemType

use library
---Test my join
select date_collected, item_dueDate, date_returned, fine_status, current_item_status from Loan l
inner join [dbo].[itemLoan] il on
il.loanID = l.loanID
inner join [dbo].[fines] f on
f.itemLoanID = il.itemLoanID
inner join item i on
i.itemID = il.itemID

select * from LoanPayment

select * from login

select * from member_status

select * from members

select * from [dbo].[Loan_Input]

select * from [dbo].[Payment_input]

select * from [dbo].[input_lib_date]



-- Alter a table column to allow null values
ALTER TABLE [dbo].[fines] ALTER COLUMN [fine_type] nvarchar(200) NULL;

ALTER TABLE [dbo].[login] ALTER COLUMN [password] nvarchar(200) NOT NULL;

-- Alter a table column to allow null values
ALTER TABLE [dbo].[member_status] ALTER COLUMN [Membership_end_date] date NULL;

-- Add a new column to the fines table
ALTER TABLE [dbo].[fines]
ADD fine_status nvarchar(200) NULL;

-- Update the new column to input the values
UPDATE [dbo].[fines]
SET fine_status = 'fully paid'
WHERE fine_totalAmount = paid_fine

UPDATE [dbo].[fines]
SET fine_status = 'partly paid'
WHERE fine_totalAmount != paid_fine 

UPDATE [dbo].[Loan]
SET [item_dueDate] = '2023-04-07'
WHERE [item_dueDate] = '2022-03-07'



-- Create titleSearch stored Procedure
CREATE PROCEDURE titleSearch
    @search_string nvarchar(100)
AS
BEGIN
    SELECT item_title, author, itemID, publication_year
    FROM item
    WHERE item_title LIKE '%' + @search_string + '%'
    ORDER BY publication_year DESC;
END


-- (2a)Execute the titleSearch stored Procedure
EXEC titleSearch @search_string='Harry'



----Create a Member Details search Stored Procedure
CREATE PROCEDURE SearchMemberID
    @search_email nvarchar(100)
AS
BEGIN
    SELECT mID
    FROM members
    WHERE email LIKE '%' + @search_email + '%'
    ;
END

---Execute the memberID search procedure
exec SearchMemberID @search_email = 'smary@gmail.com'



--test the code that check the items with a due date of <= 5
select * from loan
where DATEDIFF(day, [item_dueDate], CURRENT_TIMESTAMP) <=5
AND date_returned = NULL



-- (2b)Create the Loan_items function which returns books loaned with due_date less than the current timestamp	
CREATE FUNCTION Loan_items()
RETURNS TABLE
AS
RETURN(  
    select date_collected, item_dueDate, date_returned, fine_status, current_item_status, fine_type, item_title, author from Loan l
	inner join [dbo].[itemLoan] il on
	il.loanID = l.loanID
	inner join [dbo].[fines] f on
	f.itemLoanID = il.itemLoanID
	inner join item i on
	i.itemID = il.itemID    
	where DATEDIFF(day, [item_dueDate], CURRENT_TIMESTAMP) <=5
);
GO

--Execute the Loan_items function
SELECT * FROM Loan_items()

-- Update the rows to get your results
UPDATE [dbo].[Loan]
SET [item_dueDate] = '2023-05-07'
WHERE [item_dueDate] = '2023-04-07'





---(2c) Create the insert new member procedure
CREATE PROCEDURE NewMemberInsert
   @address1 nvarchar(200), @address2 nvarchar(200), @postcode nvarchar(200),
    @first_name nvarchar(200), @last_name nvarchar(200), @date_of_birth date, @email nvarchar(200), @tel_contact nvarchar(200),
	@username nvarchar(200), @password nvarchar(200)
AS
BEGIN
    DECLARE @addressID INT
	DECLARE @mID INT

    -- Insert data into foreign key table
    INSERT INTO dbo.address (address1, address2, postcode)
    VALUES (@address1, @address2, @postcode)
	
	SET @addressID = SCOPE_IDENTITY()

    INSERT INTO members (addressID, first_name, last_name , date_of_birth , email, tel_contact)
    VALUES (@addressID, @first_name, @last_name, @date_of_birth, @email, @tel_contact)

	SET @mID = SCOPE_IDENTITY()

	INSERT INTO login (mID, username, password)
    VALUES (@mID, @username, @password)
END


-- Execute the NewMemberInsert stored procedure
EXEC NewMemberInsert @address1 = '31 Frederick road', @address2 = '35 Frederick road', @postcode = 'M4 4wt',
    @first_name = 'George', @last_name = 'Michael', @date_of_birth = '2000-06-04', @email = 'Gmichael@gmail.com', @tel_contact = '07377579134',
	@username = 'Gmichael@michael4rill', @password = 'michael4George.'




---Updates to get your answers
UPDATE [dbo].[Loan]
SET date_returned = null
WHERE date_returned = '2023-04-08'


UPDATE [dbo].[item]
SET [current_item_status] = 'Loan'
WHERE [itemID] = 20

UPDATE members
SET last_name = 'Emmanuel'
WHERE last_name = 'Chikamso'
AND mID = 22

select * from members

-- (2d)Create update stored procedure(This procedure takes in a first name and last name, matches it with a current user before updating the person's address)
CREATE PROCEDURE Mem_Address_Update
(
	@first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @previous_addess1 NVARCHAR(100),
    @current_address1 NVARCHAR(100)
    )

AS
BEGIN
   
    UPDATE address
    SET address1 = @current_address1
    WHERE address1 = @previous_addess1
        AND EXISTS (
            SELECT *
            FROM members 
            WHERE first_name = @first_name
                AND last_name = @last_name
                AND address.addressID = members.addressID
        );
END;


-- Execute the stored procedure
EXEC Mem_Address_Update 'Helen', 'Gerald', '19 Ackers Lane', '456 Elm St'; 
EXEC Mem_Address_Update 'Prisca', 'Douglas', '51 Meadow street', '10 Meadow street';

select * from members m
INNER JOIN address a on
a.addressID = m.addressID


----Test my database
select date_collected, item_dueDate,
date_returned, fine_status, current_item_status, 
fine_type, fine_totalAmount, paid_fine, fine_totalAmount-paid_fine as remaining_fine, i.itemID from Loan l
inner join [dbo].[itemLoan] il on
il.loanID = l.loanID
inner join [dbo].[fines] f on
f.itemLoanID = il.itemLoanID
inner join item i on
i.itemID = il.itemID
;




-------Query Test 2 find the category of item that generated the most income
select it.item_type, SUM(paid_fine) as total_fine from itemType it
inner join itemLoan il on il.itemID = it.itemID
inner join fines f on f.itemLoanID = il.itemLoanID
group by it.item_type
order by SUM(paid_fine) desc


-------Query Test 3 find the genre that generated the most income
select it.item_genre, SUM(paid_fine) as total_fine from itemType it
inner join itemLoan il on il.itemID = it.itemID
inner join fines f on f.itemLoanID = il.itemLoanID
group by it.item_genre
order by SUM(paid_fine) desc




-----Question 3 Answer(Create a view showing loan history)
CREATE VIEW LoanHistory 
(date_collected, item_dueDate,
date_returned, fine_status, current_item_status, 
fine_type, fine_totalAmount, paid_fine, remaining_fine, itemID, mID, loanID, item_title, author)
AS
SELECT l.date_collected, l.item_dueDate,
l.date_returned, fine_status, current_item_status, 
fine_type, fine_totalAmount, paid_fine, fine_totalAmount-paid_fine as remaining_fine, i.itemID, il.mID, l.loanID, i.item_title, i.author from Loan l
inner join [dbo].[itemLoan] il on
il.loanID = l.loanID
inner join [dbo].[fines] f on
f.itemLoanID = il.itemLoanID
inner join item i on
i.itemID = il.itemID
;


select * from lib.LoanHistory



-----Question 4 Answer(Create my item update trigger)

CREATE TRIGGER trg_UpdateAvailability
ON dbo.loan
AFTER UPDATE
AS
BEGIN
    -- Update the availability column in the items table
    UPDATE dbo.item
    SET current_item_status = 'Available'
    FROM dbo.item
    INNER JOIN inserted ON dbo.item.itemID = inserted.itemID
    WHERE dbo.item.itemID = inserted.itemID
    AND inserted.date_returned IS NOT NULL;

END;





---(Further Analysis)payment update trigger
CREATE TRIGGER trg_UpdateDebtStatus
ON dbo.fines
AFTER UPDATE
AS
BEGIN
    -- Update the fine_status column to 'fully paid'
    UPDATE dbo.fines
    SET fine_status = 'fully paid'
    FROM dbo.fines
    INNER JOIN inserted ON dbo.fines.fineID = inserted.fineID
    WHERE dbo.fines.fine_totalAmount = inserted.paid_fine;

END;




---Used this update to test my trigger
UPDATE [dbo].[Loan]
SET [date_returned] = '2023-05-12'
WHERE [date_collected] = '2023-04-27'


----Test my fine trigger
UPDATE [dbo].[fines]
SET [paid_fine] = 50.00
WHERE [fine_totalAmount] = 50.00

UPDATE item
SET current_item_status = 'Loan'
FROM item
Inner join Loan on
loan.itemID = item.itemID
WHERE date_returned = null



-----Create Delete Trigger
CREATE TRIGGER AddressPreventDelete
ON [dbo].[address]
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Deletion of data from address table is not allowed, because it is linked to another table', 16, 1);
    ROLLBACK TRANSACTION;
END;





---Question 5 Answer(Function to identify total number of loans made on a specific date)
CREATE FUNCTION loan_by_date(@loan_date DATE)

RETURNS @date_loan TABLE
(
    date_collected date, item_title nvarchar(100), author nvarchar(100), publication_year date, current_item_status nvarchar(100)
)
AS
BEGIN
    
    INSERT INTO @date_loan (date_collected, item_title, author, publication_year, current_item_status)
    SELECT date_collected, item_title, author, publication_year, current_item_status
    FROM Loan
	inner join itemLoan on
	itemLoan.loanID = Loan.loanID
	inner join item on
	item.itemID = itemLoan.itemID
	WHERE date_collected = @loan_date;

    RETURN;
END;

-- Call the function and retrieve the result
SELECT COUNT(*) AS number_of_loans
FROM loan_by_date('2018-11-19');







----Create a Member Details search Stored Procedure
CREATE PROCEDURE SearchMemberID
    @search_email nvarchar(100)
AS
BEGIN
    SELECT mID
    FROM members
    WHERE email LIKE '%' + @search_email + '%'
    ;
END

exec SearchMemberID @search_email = 'smary@gmail.com'






------Further Analysis(Create A Loan register input which takes in the details if the book loaned and the email of the member and enters it into the loan history)
CREATE PROCEDURE NewLoan_Register
    @search_string nvarchar(200),
    @search_email nvarchar(200),
    @date_collected date,
    @item_dueDate date,
	@payment_method nvarchar(200)
AS
BEGIN
    DECLARE @itemID INT
    DECLARE @loanID INT
    DECLARE @mID INT
	DECLARE @paymentID INT
	
    SELECT @itemID = itemID
    FROM item
    WHERE item_title = @search_string

    IF @itemID IS NOT NULL
    BEGIN
        -- Insert into the table using the @itemID parameter and other input parameters
        INSERT INTO Loan(itemID, date_collected, item_dueDate)
        VALUES (@itemID, @date_collected, @item_dueDate)

        SET @loanID = SCOPE_IDENTITY()

        SELECT @mID = mID
        FROM members
        WHERE email = @search_email

		INSERT INTO LoanPayment(payment_method)
        VALUES (@payment_method)

		SET @paymentID = SCOPE_IDENTITY()

        IF @mID IS NOT NULL
        BEGIN
            -- Insert into itemLoan table with retrieved values
            INSERT INTO itemLoan(itemID, mID, loanID, paymentsID)
            VALUES (@itemID, @mID, @loanID, @paymentID)
        END
        ELSE
        BEGIN
            -- Raise an error if @mID is null
            RAISERROR('Cannot find the mID', 16, 1)
        END
    END
    ELSE
    BEGIN
        -- Raise an error if @itemID is null
        RAISERROR('Cannot find the itemID', 16, 1)
    END
END



EXEC NewLoan_Register @search_string = 'Stalky & Co.', 
@search_email = 'mpascal@gmail.com', 
@date_collected = '2023-04-27', @item_dueDate = '2023-05-07',
@payment_method = 'Credit Card'



---------inspect the newly added loan registered 
SELECT l.date_collected, l.item_dueDate,
l.date_returned, current_item_status, i.itemID, il.mID, l.loanID, il.itemLoanID, 
DATEDIFF(DAY, l.item_dueDate, l.date_returned) as days_overdue,
10 * DATEDIFF(DAY, l.item_dueDate, l.date_returned) as calculatedFine_overdue from Loan l
inner join [dbo].[itemLoan] il on
il.loanID = l.loanID
inner join item i on
i.itemID = il.itemID





------Create an insertfines
CREATE PROCEDURE InsertFines
    @mID INT,
    @LoanID INT,
    @fine_type nvarchar(100),
    @fine_totalAmount money,
	@paid_fine money,
	@fine_status nvarchar(100)
AS
BEGIN
    DECLARE @itemLoanID INT

    -- Select the foreign key ID based on @mID and @kID
    SELECT @itemLoanID = il.itemLoanID from Loan l
	inner join [dbo].[itemLoan] il on
	il.loanID = l.loanID
	inner join item i on
	i.itemID = il.itemID
	where il.mID = @mID and l.loanID = @LoanID

    -- Insert data into another table using the foreign key ID
    INSERT INTO fines(itemLoanID, fine_type, fine_totalAmount, paid_fine, fine_status)
    VALUES (@itemLoanID, @fine_type, @fine_totalAmount, @paid_fine, @fine_status)
END




------From the query which was used to inspect the newly added loan, we extract the values for the @mID, @LoanID, and the calculated fineTotal amount
------- We will use these values to insert a new fine record related to that loan
EXEC InsertFines @mID = 20,
    @LoanID = 36,
    @fine_type = 'Overdue',
    @fine_totalAmount = 50,
	@paid_fine = 30,
	@fine_status = 'partly paid'






Select * from LoanHistory


---Create Schema
CREATE SCHEMA lib
GO


-----Transfer loan history to the new schema
ALTER SCHEMA lib TRANSFER dbo.LoanHistory

select * from lib.LoanHistory


--- Create a login
CREATE LOGIN BENEDICTIBE 
WITH PASSWORD = 'Onochie4rill';

----Create a user
CREATE USER BENEDICTIBE 
FOR LOGIN BENEDICTIBE;
GO


----Grant Access to the user on address
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON address TO
BENEDICTIBE WITH GRANT OPTION;


----Grant Access to the user on city
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON city TO
BENEDICTIBE WITH GRANT OPTION;

----Grant Access to the user on fines
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON fines TO
BENEDICTIBE WITH GRANT OPTION;


----Grant Access to the user on item
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON item TO
BENEDICTIBE WITH GRANT OPTION;


----Grant Access to the user on item
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON itemLoan TO
BENEDICTIBE WITH GRANT OPTION;


----Grant Access to the user on itemType
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON itemType TO
BENEDICTIBE WITH GRANT OPTION;


----Grant Access to the user on loan
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON Loan TO
BENEDICTIBE WITH GRANT OPTION;


----Grant Access to the user on loanpayment
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON LoanPayment TO
BENEDICTIBE WITH GRANT OPTION;


----Grant Access to the user on login
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON login TO
BENEDICTIBE WITH GRANT OPTION;



-----Revoke access on login table
REVOKE SELECT, INSERT, DELETE, UPDATE, ALTER
ON [login]
FROM [BENEDICTIBE]
CASCADE;




----Grant Access to the user on member_status
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON member_status TO
BENEDICTIBE WITH GRANT OPTION;


----Grant Access to the user on members
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON members TO
BENEDICTIBE WITH GRANT OPTION;

select * from lib.LoanHistory

----Grant Access to the user on lib.LoanHistory
GRANT 
SELECT, INSERT, DELETE, UPDATE, ALTER
ON lib.LoanHistory TO
BENEDICTIBE WITH GRANT OPTION;

select * from login


-- Alter the column to increase its size
ALTER TABLE library.dbo.login
ALTER COLUMN password nvarchar(200);



------Apply Hashing to the Password
UPDATE login
SET username = CONVERT(nvarchar(200), HASHBYTES('SHA2_256', username), 2),
    password = CONVERT(nvarchar(200), HASHBYTES('SHA2_256', password), 2);



use library














---TASK 2
CREATE DATABASE PrescriptionsDB;
use PrescriptionsDB


------Number 2 answer
select * from [dbo].[Drugs]
where [BNF_DESCRIPTION] like '%capsules%' OR
[BNF_DESCRIPTION] like '%tablets%'


select count(*) as count from [dbo].[Drugs]
where [BNF_DESCRIPTION] like '%capsules%' OR
[BNF_DESCRIPTION] like '%tablets%'








----Number 3 answer

select [PRESCRIPTION_CODE], [QUANTITY], [ITEMS], 
ROUND([QUANTITY] * [ITEMS], 0) AS Total_quantity from [dbo].[Prescriptions]


----Number 4 answer
select distinct[CHEMICAL_SUBSTANCE_BNF_DESCR] from [dbo].[Drugs]


----Number 5 answer
SELECT d.[BNF_CHAPTER_PLUS_CODE], 
ROUND(AVG([ACTUAL_COST]), 2) as average_cost, 
ROUND(MIN([ACTUAL_COST]), 2) as minimun_cost, ROUND(MAX([ACTUAL_COST]), 2) as maximum_cost  
FROM [dbo].[Drugs] d
INNER JOIN [dbo].[Prescriptions] p ON
p.[BNF_CODE] = d.[BNF_CODE]
GROUP BY d.[BNF_CHAPTER_PLUS_CODE]
ORDER BY average_cost DESC


----Number 6 answer
SELECT p.[PRACTICE_CODE],
ROUND(MAX([ACTUAL_COST]), 2) as actual_cost, m.[PRACTICE_NAME]
FROM [dbo].[Drugs] d
INNER JOIN [dbo].[Prescriptions] p ON
p.[BNF_CODE] = d.[BNF_CODE]
INNER JOIN [dbo].[Medical_Practice]	m ON
m.[PRACTICE_CODE] = p.[PRACTICE_CODE]
GROUP BY p.[PRACTICE_CODE], m.[PRACTICE_NAME]
HAVING ROUND(MAX([ACTUAL_COST]), 2)  > 4000
ORDER BY ROUND(MAX([ACTUAL_COST]), 2) DESC


----EXTRA QUERIES 1 
----- Use of Nested Queries
------ Suppose we want to get the cost per item of drugs that does not contain the chemical - Bisoprolol fumarate given that the patient is allergic to the chemical using a nested query
select p.[PRACTICE_CODE], p.[PRESCRIPTION_CODE], (ROUND(p.[ACTUAL_COST], 0)/p.[ITEMS]) as cost_per_item
from [dbo].[Prescriptions] p
where exists
(select * from [dbo].[Prescriptions] p
inner join [dbo].[Drugs] d ON
p.[BNF_CODE] = d.[BNF_CODE]
where d.[CHEMICAL_SUBSTANCE_BNF_DESCR] not like '%Bisoprolol fumarate%')


----EXTRA QUERIES 2 
----- Use of joins
------ Suppose we want to get only the drugs that are 100mg tablets containing Allopurinol chemical in them

select d.[BNF_CHAPTER_PLUS_CODE], d.[CHEMICAL_SUBSTANCE_BNF_DESCR], d.[BNF_DESCRIPTION],
d.[BNF_CODE], m.[PRACTICE_NAME] from [dbo].[Prescriptions] p
inner join [dbo].[Drugs] d ON
p.[BNF_CODE] = d.[BNF_CODE]
inner join [dbo].[Medical_Practice] m ON
m.[PRACTICE_CODE] = p.[PRACTICE_CODE]
where d.[BNF_DESCRIPTION] like '%100mg tablets%'
and d.[CHEMICAL_SUBSTANCE_BNF_DESCR] like '%Allopurinol%'




----EXTRA QUERIES 3 
----- system functions
------ Suppose we want to quickly search for drugs depending on the diagnosis of a patient, 
------------------------------here we create a function that accepts the category of disease and returns the list of drugs that can be used to treat it

drop function drug_disease

CREATE FUNCTION drug_disease(@disease_category nvarchar(200))
RETURNS TABLE
AS
RETURN(  
   select d.[BNF_CHAPTER_PLUS_CODE], d.[CHEMICAL_SUBSTANCE_BNF_DESCR], d.[BNF_DESCRIPTION],
	d.[BNF_CODE] from [dbo].[Prescriptions] p
	inner join [dbo].[Drugs] d ON
	p.[BNF_CODE] = d.[BNF_CODE]
	inner join [dbo].[Medical_Practice] m ON
	m.[PRACTICE_CODE] = p.[PRACTICE_CODE]
	where d.[BNF_CHAPTER_PLUS_CODE] like '%' + @disease_category + '%'
);
GO

select * from drug_disease ('Gastro-Intestinal System')
select * from drugs




----EXTRA QUERIES 4 
----- Group by, Having, Order by
------ Suppose we want to get the number of packs(items) of Respiratory System prescriptions available in each practice code

select p.[PRACTICE_CODE], SUM(p.[ITEMS]) as Sum_items, d.[BNF_CHAPTER_PLUS_CODE], 
	d.[BNF_CODE] from [dbo].[Prescriptions] p
	inner join [dbo].[Drugs] d ON
	p.[BNF_CODE] = d.[BNF_CODE]
	inner join [dbo].[Medical_Practice] m ON
	m.[PRACTICE_CODE] = p.[PRACTICE_CODE]
	group by p.[PRACTICE_CODE], d.[BNF_CHAPTER_PLUS_CODE], 
	d.[BNF_CODE]
	having d.[BNF_CHAPTER_PLUS_CODE] like '%Respiratory System%'
	order by SUM(p.[ITEMS]) desc




----EXTRA QUERIES 5 
----- Group by
------ Suppose we want to search for the availability of a drug along with the how many packs of the drug remainin, either for stock taking or checking for a customer
--------We created a stored procedure that takes in the drug we are looking for and returns a table with the detail of how many packs are available 


CREATE PROCEDURE drugSearch
    @search_drug nvarchar(100)
AS
BEGIN
    select d.[BNF_CHAPTER_PLUS_CODE], d.[BNF_DESCRIPTION], SUM(p.[ITEMS]) as Item_quantity from [dbo].[Prescriptions] p
	inner join [dbo].[Drugs] d ON
	p.[BNF_CODE] = d.[BNF_CODE]
	inner join [dbo].[Medical_Practice] m ON
	m.[PRACTICE_CODE] = p.[PRACTICE_CODE]
	group by d.[BNF_CHAPTER_PLUS_CODE], d.[BNF_DESCRIPTION]
	having d.[BNF_DESCRIPTION] like '%' + @search_drug + '%'
	order by SUM(p.[ITEMS]) desc
END

exec drugSearch @search_drug = 'Diazepam'

