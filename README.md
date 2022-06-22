# Project Description

Architecture for scaling a database under postgresql

A software editor offers to its customers to develop their applications via its online platform (paas). The description of the applications is stored in the database of the editor whose model is the following: users(id:integer, user:json), apps(id:integer, app:json, userid:integer). 

After a few months of use the platform was no longer functional:

* the storage disk is full
* Unable to increase disk capacity

The only solution for the editor is to add new machines without the users noticing. notice it.

Tasks

* Propose a detailed architecture to solve the editor's problem
* implement your solution
*   simulate the initial architecture
*   propose a procedure to move from the initial architecture to the new architecture
*   test the new architecture
* what happens if we add a new machine to your solution


Deliverables
- a document describing and justifying the details of your architecture
- the deployment and simulation codes of the architecture
