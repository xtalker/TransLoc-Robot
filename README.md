# TransLoc-Robot
Robot testing exercise for TransLoc

The Robot Framework allows test cases to be written in a BDD/"Cucumber" type style. The test case automation is implemented with "keywords" that are coded to perform all the steps in a test case.

A test case (.robot) file typically has three sections:

- Settings: Things required to setup the test environment before the test cases are executed.
- Variables: Variables common to all the test cases in this file.
- Test Cases: The test cases themselves made up of the test name and the keywowrds required to implement it.
- Keywords: The definition of each keyword used in a test case.

The following tests are included here (in Test_cases.robot).  A test setup file is used to setup the test env (Test_Setup.robot)
- Log in to the Architect application and verify that test feed is available
- Open the default GTFS feed and verify that all components exist
- Add a new stop to this GTFS feed
- Export this GTFS feed to local file system

The last test was to include verifying that the changes made to the feed actually showed up in the export.  
Either there is a potential bug here, or I don't understand how Architect is supposed to work (likely!) because
the changes I made to the "Stops" component never seem to show up in the exported feed.

A video capture of the test session is also included (TransLoc_Robot_Session.mov).  Sorry about the shaded area,
couldn't figure that one out!
