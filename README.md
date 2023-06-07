## KUMUSTA: CMSC 23 FINAL PROJECT (Health Monitoring App for UPLB residents)

## DEVELOPERS: 
  - Alcantara, Mark Henry 
  - Brabante, Jakie Ashley
  - Gonzales, Kat
  - Tulio, Brad Lee

## SECTION: B6L

## APP DESCRIPTION: 
Stay informed and take control of your health with the UPLB Health Monitor, a powerful app designed specifically for the residents of the 
University of the Philippines Los Baños community. As COVID-19 cases continue to rise, it is crucial to stay vigilant and prioritize our health and well-being. This app is your reliable companion, providing essential features to help you monitor, track, and manage your health during these challenging times.

## APP FEATURES:
Figma Layout: https://www.figma.com/file/llJ1yhEslLIpgVJJCwugpG/KUMUSTA-APP?type=design&node-id=0%3A1&t=ZNDXqeinXd7PDORx-1

User's View:
- Sign in: Users can authenticate themselves to access the app.
- Sign up: Users provide their name, username, college, course, and student number to create an account.
- Pre-existing illness: Users must add any pre-existing illnesses they have, such as hypertension, diabetes, tuberculosis, cancer, kidney disease, cardiac disease, autoimmune disease, asthma, and allergies.
- Homepage: Users can view a list of entries, indicating whether they are quarantined or not.
- MyProfile: Users can access their profile, which includes a generated daily QR code for building access. The QR code cannot be generated if the user is quarantined, has symptoms, or has not made a health entry.
- Add Today's Entry: Users can add their health status for the day, specifying symptoms like fever, muscle or joint pains, cough, colds, sore throat, difficulty breathing, diarrhea, loss of taste, and loss of smell. If the user has any of these symptoms, they will not be allowed entry, and the QR code will not be generated.
- Edit Today's Entry: Users can edit their health entry, but the changes need to be approved by the admin.
- Delete Today's Entry: Users can request to delete their health entry, but the request also needs to be approved by the admin.

Admin's View:
- Sign in: Admins can authenticate themselves to access the admin interface.
- Sign up: Admins provide their name, employee number, position, and home unit to create an admin account.
- View All and View specific student: Admins can view all students' entries and filter them by date, course, college, or student number.
- Add Student to Quarantine: Admins can add students to quarantine and keep track of the number of students in quarantine.
- View Quarantined Students: Admins can view a list of quarantined students and have the ability to remove them from quarantine.
- View Under Monitoring Students: Admins can view students who are under monitoring and can choose to move them to quarantine or end monitoring.
- Approve/Reject Delete/Edit Request of Student: Admins can approve or reject delete/edit requests made by students for their health entries.
- Elevate user type: Admins can elevate the user type from the default user to admin or monitor.

Entrance Monitor:
- Sign in: Entrance monitors can authenticate themselves to access the app.
- Sign up: Entrance monitors provide their name, employee number, position, and home unit to create an account.
- Search student logs: Entrance monitors can search and view logs of students who have entered.
- View logs: Entrance monitors can view the logs of students who have entered.
- Read generated QR: Entrance monitors can scan and read the generated QR codes.
- Update Logs: Entrance monitors can update the logs with location, student number, and status of the students.

Types of Status for Users:
- Cleared: Users who have no symptoms and are not under monitoring or quarantine.
- Under Monitoring: Users who have had face-to-face encounters or contact with a confirmed COVID-19 case and need to be monitored.
- Under Quarantine: Users who are in quarantine due to exposure or positive COVID-19 test results.

## THINGS DONE IN THE CODE: 
1. Authentication:
   - Implement a user authentication system that validates the username and password.
   - Store user credentials securely in a database.

2. User Sign-up:
   - Create a registration form where users can provide their details.
   - Validate and store the user information in the database.

3. Health Entries:
   - Design a form for users to add their health entries, including symptoms and pre-existing illnesses.
   - Validate the entries to ensure accurate and relevant data.
   - Store the health entries in the database, associating them with the corresponding user.

4. QR Code Generation:
   - Generate a daily QR code for each user based on their health entry.
   - Implement logic to prevent QR code generation if the user is quarantined, has symptoms, or has not made a health entry.

5. Admin Functions:
   - Create an admin interface with appropriate access controls and authentication.
   - Implement functionalities for admins to view and filter student entries, including quarantine and monitoring status.
   - Provide options for adding students to quarantine and managing quarantine lists.
   - Enable admins to approve/reject delete/edit requests made by users.

6. Entrance Monitor Functions:
   - Develop an interface for entrance monitors with authentication.
   - Implement search and view functionalities for student logs, including entry details and generated QR codes.
   - Allow entrance monitors to update logs with location, student number, and status.


    

