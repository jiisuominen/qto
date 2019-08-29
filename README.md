#  README
* [1. WHY](#1-why)
* [2. SO, WHAT IS THIS ?!](#2-so,-what-is-this-)
  * [2.1. WHAT CAN IT DO TO MY ORGANISATION ?](#21-what-can-it-do-to-my-organisation-)
  * [2.2. ASSUMPTION AND PREREQUISITES](#22-assumption-and-prerequisites)
  * [2.3. PROPOSED CAPABILITIES](#23-proposed-capabilities)
* [3. DEMO](#3-demo)
* [4. DOCUMENTATION](#4-documentation)
* [5. MISSION](#5-mission)
  * [5.1. THE INSTALLATIONS DOC](#51-the-installations-doc)
  * [5.2. THE CONCEPTS DOC](#52-the-concepts-doc)
  * [5.3. THE USERSTORIES DOC](#53-the-userstories-doc)
  * [5.4. THE DEVOPS GUIDE DOC](#54-the-devops-guide-doc)
  * [5.5. THE ENDUSER GUIDE DOC](#55-the-enduser-guide-doc)
  * [5.6. THE REQUIREMENTS DOC](#56-the-requirements-doc)
* [6. INSTALLATION AND CONFIGURATION VIA DOCKER](#6-installation-and-configuration-via-docker)
  * [6.1. FETCH THE SOURCE](#61-fetch-the-source)
  * [6.2. RUN THE BOOTSTRAP SCRIPT](#62-run-the-bootstrap-script)
  * [6.3. BUILD THE QTO IMAGE](#63-build-the-qto-image)
  * [6.4. RUN THE CONTAINER](#64-run-the-container)
  * [6.5. VERIFY THAT THE WHOLE SYSTEM WORKS](#65-verify-that-the-whole-system-works)
* [7. ACKNOWLEDGEMENTS](#7-acknowledgements)
* [8. LICENSE](#8-license)




    

## 1. WHY
Why ?! Yet! Another App ?! ...

Software development is prohibitively expensive. This application will provide your organisation with the answers who does(did) what, when, how and why in a strikingly open manner, but ONLY if your biz owners have the needed courage and commitment to do it.  In fact it could do it for ANY type of project, not only software development one ..
Because work should be inspiring and not overwhelming people. 
Because even good intentions without transparency, proper commitment, allocation and resourcing and most importantly, a mean for tracking advancement of an endeavour in an open way reflecting the reality, might end-up stressing people. In fact a really simple solution could be applied for any bigger challenge requiring progress tracking, communication and coordination ... 
And tons of other reasons we all having been in project disasters know about ... Still here ?! Let's move on !

    

## 2. SO, WHAT IS THIS ?!
A generic and simplistic db centric content management system, build on postgres CRUDs ( s stands for search ) and hierarchical nested data-sets. 
Qto is a web based app for managing multiple databases from the same web application layer by means of simplest possible UI and/or shell tools for xls/md export, import etc. An included example application is the "qto application", which is used to manage multiple projects' issues, including itself ;o). 
The full and extensive https://qto.fi/qto/view/features_doc contain all the features and functionalities of this released version. 
This application is the reflection of the best practices and principles for tens of years in IT resulting into a product of the Multi-environment instance architecture, which is in a way a reflection of the simple axiom in IT - "if there is one there will be many" ...


Figure: 1 
the 7 main entities of the qto app
![Figure: 1 
the 7 main entities of the qto app](https://raw.githubusercontent.com/YordanGeorgiev/qto/master/doc/img/readme/what-is-is.png)

    

### 2.1. What can it do to my organisation ?
With qto you could either re-use the existing items for management available from the home page or you could in less than 5 minutes per item define your own. 

    

### 2.2. Assumption and prerequisites
Your organisation:

- has the need to constantly update comparably small ( less than 10k rows) (hierarchy) tables
- has full trust to the persons in the org for all, but users data related CRUD operations 
- has the a need to load MANY tables into a postgres db, which might be changing constantly DDL wise
- the API of having bigint id and uid as PK as well as default vals for nullable cols is acceptable
- might have the need to save technical documentation in versioned md format

    

### 2.3. Proposed capabilities
You could:

- deploy an instance of the qto, bare metal/vm/docker install should take no more than 2h
- provide access to the non-technical person via http for CRUD operations
- quickly define LOTS of tables DDL by using the existing examples and just changing the columns
- load initial data via xls ( less than 10k rows per sheet should be ok )
- generate md docs format based on the qto native view docs ..
- provide them with initial links to grasp the "semi-sql" syntax
- demo the simple search feature ( working only with name and description cols , but you could ddl hack-it)

    

## 3. DEMO
You can check the following https://qto.fi/qto/view/enduser_guide_doc of the web app, additionally every doc bellow has it's "it-doc" link aka the "native" qto document format …
Use the "test.user@gmail.com" and "secret" credentials to login or even better try to login with your own e-mail and request access from the admin e-mail displayed to the error msg ...

    

## 4. DOCUMENTATION

Qto IS about documentation, we do all the doc-fooding on our docs, which are aimed to be as up-to-date to the current release version as possible. Thus you get the following documentation set:
 - ReadMe - the initial landing readme doc for the project
 - UserStories - the collection of user-stories used to describe "what is desired"
 - Requirements - the structured collection of the requirements 
 - SystemGuide - architecture and System description
 - DevOps Guide - a guide for the developers and devops operators
 - Installation Guide - a guide for installation of the application
 - End-User Guide - the guide for the usage of the UI ( mainly ) for the end-users
 - Concepts - the concepts doc 

    

## 5. MISSION
Enable transperent collaboration.


    

### 5.1. The Installations doc
Contains the tasks and activities to perform to get a fully operational instance of the qto application:
 - https://github.com/YordanGeorgiev/qto/blob/master/doc/md/installations_doc.md
 - https://qto.fi/qto/view/installations_doc

    

### 5.2. The Concepts doc
General level concepts of the application. 
 - https://github.com/YordanGeorgiev/qto/blob/master/doc/md/concepts_doc.md
 - https://qto.fi/qto/view/concepts_doc

    

### 5.3. The UserStories doc
Naturally contains the userstories of the app. 
- in https://github.com/YordanGeorgiev/qto/blob/master/doc/md/userstories_doc.md 
- https://qto.fi/qto/view/userstories_doc

    

### 5.4. The DevOps Guide doc
Contains content on how to develop the application + general devops info.
- https://github.com/YordanGeorgiev/qto/blob/master/doc/md/devops_guide_doc.md
- https://qto.fi/qto/view/devops_guide_doc

    

### 5.5. The EndUser Guide doc
The enduser guide contains mostly UI usage instructions:
 - https://github.com/YordanGeorgiev/qto/blob/master/doc/md/enduser_guide_doc.md
 - https://qto.fi/qto/view/concepts_doc

    

### 5.6. The Requirements doc
Contains the specs and requirements, which can be defined at the current stage of the development:
 - https://github.com/YordanGeorgiev/qto/blob/master/doc/md/requirements_doc.md
 - https://qto.fi/qto/view/requirements_doc

    

## 6. INSTALLATION AND CONFIGURATION VIA DOCKER
Skip this section if you do not want to be a full stack devops / sysadmin operator on the qto application ...
This section provides the instructions to build the whole system from scratch on docker. You will need git, bash, perl and docker to complete the whole containerised deployment and access to OS user having sudo.
It should take about 45-60 min to complete depending on your network connection and host hardware specs, 75%-80% of which is the image building process which does not require shell interaction. 
The target setup is such that you could edit the source code on the host machine, but both the db and the application layer will be run in the docker. 

    

### 6.1. Fetch the source
As a non-root account, having sudo fetch the source on your local machine, which will be use to run the container onto a dir your user has full read, write and execute permissions:

    # do not execute as root !
    mkdir -p ~/opt/ ; cd ~/opt
    git clone https://github.com/YordanGeorgiev/qto

### 6.2. Run the bootstrap script
In the qto realm each deployment INSTANCE is "self-aware" of the type of environment it represents -  dev, tst , prd. To bootstrap to the dev environment run the following command:

    bash qto/src/bash/qto/bootstrap-qto-host.sh
    
    # cd to the product instance dir as suggested by the script
    

### 6.3. Build the qto image
This step will take 80% of the time. It is non-interactive, that is the whole image building should succeed at once. 

    # build the docker image
    clear ; bash src/bash/qto/qto.sh -a build-docker-image

### 6.4. Run the container
Run a container of the already build image issue the following command:

    bash src/bash/qto/qto.sh -a run-container
    # read the actual command to attach to the container if needed

### 6.5. Verify that the whole system works
To verify the list ui point your local machine browser to the following uri:
http://localhost:3001/qto/list/release_issues

To verify the view doc ui point your local machine browser to the following uri:
http://localhost:3001/qto/view/devops_guide_doc

Note that you deployed a development environment type ( aka dev ) instance. Read further in the devops_guide how to setup tst and prd environments as well ...

    

## 7. ACKNOWLEDGEMENTS
This project would NOT have been possible without the work of the people working on the following frameworks/languages/OS communities listed in no particular order.
 - Perl
 - Mojolicious
 - GNU Linux
 - Vue
 - FreeBSD

Deep gratitudes and thanks to all those people ! This application aims to contain the best practices of our former colleagues and collaborators and fellow travellers in life, which also deserve huge thanks for their support and contributions ! We tend to incorporate and re-use a lot of code snippets from the Stackoverflow and Codepen sites, should you consider that you were the author of those code snippets and you deserve mentioning of the source please let us know ...

    

## 8. LICENSE
All the trademarks mentioned in the documentation and in the source code belong to their owners. This application uses the Perl Artistic license, check the license.txt file or the following link : https://dev.perl.org/licenses/artistic.html

Should any trademark attribution be missing, mistaken or erroneous, please contact us as soon as possible for rectification.

    

