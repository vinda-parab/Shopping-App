Feature: Claim Management

Background:
  Given User is on the site "https://opensource-demo.orangehrmlive.com/web/index.php/auth/login"
  And User logs in with Username "Admin" and Password "admin123"

Scenario: Create A Claim
  Given User is logged in
  When User navigates to "Claim > Assign Claim"
  And User creates a Claim Request with the following data
    | Employee Name | Event           | Currency     |
    | Ranga Akunuri | Travel Allowance | Indian Rupee |
  Then Verify Status is "Initiated"
  And Verify Employee is "Ranga Akunuri"
  And Verify Event is "Travel Allowance"
  And Verify Currency is "Indian Rupee"
  And Verify Reference Id is numeric, not empty and unique
  And Capture the Reference Id

Scenario: Add Expenses to List
  Given User has created a claim
  When User adds an expense to the claim with the following data
    | Expense Type | Date       | Amount |
    | Transport    | 2024-01-04 | 5000   |
  And User adds another expense to the claim with the following data
    | Expense Type | Date       | Amount |
    | Accommodation| 2024-01-04 | 10000  |
  Then Verify text on Assign Claim page is "Total Amount (Indian Rupee) : 15,000.00"
  And Verify "(2) Records Found" is displayed

Scenario: Add Attachment
  Given User has created a claim
  When User adds an Attachment
  Then Verify Successfully Saved pop up in green color
  And Verify message "(1) Record Found"
  And Verify value of "date added column" is current date
  And User hits Submit
  Then Verify Successfully Saved pop up in green color

Scenario: Verify the newly created claim
  Given User has created a claim
  When User hits Employee Claims button
  And User searches with Reference Id captured above
  And User hits Search
  Then Verify the following data in the table columns
    | Reference Id | Employee Name | Event Name      | Currency     | Amount  |
    | Above Id     | Ranga Akunuri | Travel Allowance| Indian Rupee | 15000.00|
  When User hits View Details button
  Then Verify Claim is displayed
  And Verify page is non editable
  And Verify Back button is present
  When User hits Back button
  Then Verify user is taken back to Employee Claims page
  And Verify assigned claims are displayed again
