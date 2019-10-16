ucl-geospatial/ ucfajhd-quiz Project name: University College London Module (“UCL”): CEGE0043 Assigment – Developing & Deploying a location based quiz App with three components. 


Contents: 
1.	Author 
2.	Description
3.	System requirements
4.	Installation / getting started 
5.	Code testing 
6.	List of files in this repository with purpose  
7.	Acknowlegement & sources of the code 
8.	Other references
9.	MIT Licence


--- 
## 1.	Author

Jason Dalrymple Masters Degree Student UCL 2018



## 2.	 Description

University College London’s Masters in Geospatial Analysis contains a module called Web & Mobile GIS. The assessment of this module requires students to create a map based App ( ie location) quiz with three components and then deploy it using the PhoneGap APP. 

The three components are as follows :

•	A quiz app which is capable of being run on an android phone
•	An App that sets the questions
•	A NodeJS server where in which the questions are saved. 

The code for each of these three components has its own github as follows: 

•	ucl-geospatial/ucfajhd-quiz
•	ucl-geospatial/ucfajhd-questions
•	ucl-geospatial/ucfajhd-server



## 3.	System requirements

uploading the code to the server, and running the code in a browser or App requires the following: 

3.1  Software

For editing the code, uploading to servers and running in a production environment or through a brower the following is required; 

Text editor: the code was created using Sublime, available for mac or windows.

A file transfer system is required to upload the files from github to the server.  I have been using cyberduck. 

3.2	Phone APPS

The following Apps, available through Google’s Play Store will need to be installed on the android phone

PhoneGap App. 

If using a VPM to access your server then install the app that gives access to your VPM.  UCL’s VPM was accessed via the Cisco AnyConnect App. 

3.2 Browsers

Giuthub appears to no longer fully support internet explorer and therefore the best way to navigate github is through Crome. 

Browsers shuch as Crome, Safari or Internet explorer as sufficient for running the URL. 

3.3 Hardwear

The PhoneGap APP best runs on an android phone v5.0 or higher.  
The Apps do not run on  Iphones. 


3.4	Archetecture Specific Code

3.4.1	Server side Code:  For the purposes of this project the server side code used is Node.js

3.4 2 Client side code: For the purpose of this project the client side code used is javascript together with the latest version of HTML5


## 4. Installation / getting started 



4.1 For Apple OS X

The following is a guide as to how to instal the files on the server and then run the files. 

Step 1. Make sure that you have access to your organisations servers. One way of doing this is via Cisco anyConnect. if you havent got this then instal the app on your pc/desktop. Your IT department will help you with requisit passwords

Step 2. Click on the ICONand in the box type in the relevant address to access your organisations VPN access. 

Step 3. On request type in your username and password. 

Step 4. On prompt, a) from the drop down options select  SSH File transfer,b) type in the following server address developer.cege.ucl.ac.uk, c) in the port box type in your relevant server, d) enter the relevant username and e) password. 

Step 5. If you get a pop up with [Deny] and [Allow] options select [Allow]

Step 6. The next screen will show you the files that are currently resident on the server.  Check that ucfajhd-quiz anf ucfajhd-questions are on the server. if they are not then these will need to be cloned onto the server.

Step 7. From the options on the line at the top of the screen select  [Go], an then select [Open in terminal]

Step 8 At the ext screen a  request to enter your SSH password will come. 

Step 9. At this point you will need to identify the route directory where to clone the relevant githiub file. so type cd /home/studentserver/code

Step 10. Then type in the clone command as follows: git clone https://github.com/ucl-geospatial/ucfajhd-quiz.git. The terminal will then ask for your github username and password. The cloning will then happen. 

A step by step guide by way of a flowchart is located in the installationGuide.html file.


4.2 Windows

Coming soon 



## 5.	Code testing 

this code has been tested using the following UCL servers:

- https:     https://developer.cege.ucl.ac.uk:310271
- phonegap:  https://developer.cege.ucl.ac.uk:31271
- http:      http://developer.cege.ucl.ac.uk:30271

The following notes provide guideance on how to tets the code.  Screenshots are available in the codeTesting.html File. 

Step 1. In the server console highlight the directory where the phonegap files are 

Step 2 Open a new terminal line command 

Step 3. When prompted a) type in your cyberduck password , b) check that the text in blue corresponds to the folder where-in which the phonegap app is resident. If it is then type cd /home/studentuser/ucfajhd-quiz/ucfajhd, then open the phonegap server by typing phonegap serve. You should get a message saying " starting the app server. 

Step 4. go to your android phone. Make sure you have the right access to the VPN; I have used an APP called ANyConnect. Make sure that the passwords are correct, and that there a connection.

Step 5. Make sure that you have the PhoneGap App installed, and click on the icon. 

Step 6. When prompted type in the relevant developer address : developer.cege.ucl.ac.uk:"31271", and click connect.  You should get a flashing [Download] message, and then [Extracting] , and then [Sucess]. At this Point a map with an icon will appear. 

Step 7. The user guide will provide information on how to use the APP. 

A step by step guide by way of a flowchart is located in the codeTesting.html file, 


## 6.	List of files in this repository with purpose  


This repository contains a number of files; many of which are not directly relevant to the running of the Phonegap APP but were created as part of the development of the code.  For completeness all the files created during this project are contained here. However the ones that are specific to the APP are the following: 



| Directory     | File  | Purpose |
| ------------- | ------------- | -------------|
| www/js   |ajax.js | this file makes an ajaz http request to the server      |
| www   | blankQuiz.html | Contains the code that creates the blank quiz accessible via the quiz and question App. |
| www   | blankQuizOptional.html | Contains the code that creates the blank quiz accessible via the quiz and question App. |
| www/installationGuide | deployingCode | This provides a guide on how to deploy the code onto local servers. |
| www/codetesting| codeTesting.html  | Provides information on how to test that the code works correctly on a PhoneGap APP.      |
| www | index.html  | Contains the code that drives the APP      |
| www | index.js | This file runs the app startup, routing and prioritisation of the files all app functionality. |
| www | installationGuide.html  | Provides information on how instal the code from GitHub to a local server     |
| www | leafletFunctions.js| Leaflet is an opensource javascript library containing web app.s     |
| www | legalInformation,js| Licencing information pertaining to the use of Phonegap App      |
| www | rhMenu.js| Code that creates the right hand menu in materialdesignlite      |
| www | startUp.js| code that is run when the app starts up and pulls all the requisit files      |
| www/js | trackLocation.js| This file tracks the user's location and is integral identifying the co-ordinates of the user     |
| www | uploadData.js| This file uploads to the server the data that the user enters into the questionnaire     |
| www | userGuide.html| This file, accessible from the menu in the app provides the user on information as to how to use the app      |
| www/js   |userLocation.js | This file identifies the GPS co-ordinates of the user    | 
| www/js   |userTracking.js | This file tracks the location of the phone and is inherent in driving the popping up of the quiz and the questions when the user reaches specific co-ordinates.    | 
| www | userQuiz.html| Contains the code that creates the quiz pertaining to UCL     |
| www | utilities.js| The javascript file that extracts the information from the webserver as to what port is required.     |




## 7.	Acknowlegements and sources of the code 

The majority of the code was made available by Dr Claire Ellul by way of the cege0043 lectures. 

The principle file that drive the App, and which references all the key files is index.html


Where other sources ( Open source or otherwise) have been referenced these are cited in the respective files, and summaried as follows: 



| File   | Commentry  | 
| ------------- | ------------- | 
| blankQuiz.html|  http://www.w3.org/TR/html4/strict.dtd  | 
| blankQuizOptional.html|  http://www.w3.org/TR/html4/strict.dtd  | 
| codeTesting.html|  http://www.w3.org/TR/html4/strict.dtd  | 
| deployingCode.html|  http://www.w3.org/TR/html4/strict.dtd  | 
| index.html|  https://css-tricks.com/lets-make-a-form-that-puts-current-location-to-use-in-a-map/   | 
| legalInformation.html  | http://www.w3.org/TR/html4/strict.dtd      |
| userGuide.html|  http://www.w3.org/TR/html4/strict.dtd  | 
| userTracking |  https://www.htmlgoodies.com/beyond/javascript/calculate-the-distance-between-two-points-inyour-web-apps.html  |



## 8.	Other references 

The following source were consulted on how to create a good readme file : 

https://github.com/akashnimare/foco/releases
hhttps://en.wikipedia.org/wiki/READMEtps://gist.github.com/PurpleBooth/109311bb0361f32d87a2
https://guides.github.com/features/wikis/

## 9.	MIT License

Copyright (c) 2019 Jason Howell Dalrymple 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
