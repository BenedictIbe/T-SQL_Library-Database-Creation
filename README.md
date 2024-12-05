# T-SQL_Library-Database-Creation
The file below contains codes used in building a fully automated and functional library database system in T-SQL, with complex steps towards ensurinng data integrity (through triggers, check constraints, stored funnctions, stored procedures, mainntenannce wizard set ups) and data security (password hashinng, Grant access, Views, revoked access etc)
The codes also contain select queries as well as complex join queries used in testing the dataset as well as update queries used in testinng triggers


Features
Database Schema Creation

Tables for books, authors, library users, and transactions.
Primary and foreign key constraints for relational data integrity.
Core Functionalities

Book lending and return management.
Author and book relationships.
User registration and role management.
SQL Scripts

Fully commented T-SQL scripts for database setup and operations.
Procedures, triggers, and views to enhance database usability.
Getting Started
Prerequisites
Ensure the following are installed on your system:

Microsoft SQL Server (2016 or later recommended).
SQL Server Management Studio (SSMS) or any compatible T-SQL client tool.
Installation Steps
Clone the Repository

bash
git clone https://github.com/BenedictIbe/T-SQL_Library-Database-Creation.git  
cd T-SQL_Library-Database-Creation  
Setup the Database

Open the Library_Database_Creation.sql script in SQL Server Management Studio.
Execute the script to create the database schema.
Populate the Database

Use the Sample_Data_Insert.sql file to populate the database with sample data for testing.
Run Operations

Utilize the Procedures_And_Functions.sql file to perform operations such as book borrowing, returns, or searching for books.
Database Design
Tables
Books: Stores information about the library's books.

Columns: BookID, Title, AuthorID, PublishedDate, etc.
Authors: Maintains details about authors.

Columns: AuthorID, Name, Biography, etc.
LibraryUsers: Contains user information.

Columns: UserID, FirstName, LastName, Role, etc.
Transactions: Tracks book lending and returns.

Columns: TransactionID, BookID, UserID, TransactionDate, ReturnDate.
Scripts Overview
Database Creation Script

Defines the database schema, including tables, relationships, and constraints.
Data Insertion Script

Populates the tables with initial data for testing and development.
Stored Procedures and Functions

Includes reusable code for common tasks such as borrowing books or retrieving user data.
Triggers and Views

Implements automated database logic and pre-defined data views for reporting.
Usage Examples
Borrow a Book

sql code
EXEC BorrowBook @UserID = 1, @BookID = 101;  
Return a Book

sql code
EXEC ReturnBook @TransactionID = 1001;  
Search for Books by Author

sql code
SELECT * FROM Books  
WHERE AuthorID = 10;  
Contributing
Contributions are welcome! Feel free to submit issues or pull requests to improve the database design, scripts, or documentation.

License
This project is licensed under the MIT License. See the LICENSE file for details.

Contact
If you have any questions or feedback, please reach out:

Author: Benedict Ibe
GitHub Profile: BenedictIbe
By following this README, you should be able to set up, understand, and utilize the T-SQL Library Database for learning or production purposes.
