# TransLoc Test Automation Exercise using Robot Test Framework
# Bob Steinbeiser 8/28/2019

*** Settings ***

Resource        ${EXECDIR}/Test_Setup.robot

Suite Setup     Open browser and start
Suite Teardown  Close All Browsers

Force Tags      critical


*** Variables ***

${DEMO_SLEEP_TIME}  2 Seconds
${FEED_LINK}        /qainterviewtwo/service-periods/2759

# Test Data
#    Note: this would normally be stored in a common place in a standard (like YAML) format

# New stop data
${STOP_NAME}   1 Test Ruckersville
${STOP_LAT}    38.233245078253596
${STOP_LONG}   -78.3690562458496
${STOP_DESCR}  This is a stop created for testing purposes


*** Test Cases ***

Log in to the Architect application and verify that test feed is available

    Given I'm logged in as  ${USERID}  ${PASSWORD}
    Then I can see that this test GTFS feed is availalble:  GTFS Import (Aug 23, 2019)


Open the default GTFS feed and verify that all components exist

    [Setup]  I can open the feed named:  GTFS Import (Aug 23, 2019)

    [Template]  Navigate to each component of the feed and verify:

    # Component Name     Component Page Text
      routes             Routes are equivalent to "Lines" in public transportation systems.
      stops              Individual locations where vehicles pick up or drop off passengers.
      patterns           Patterns are templates for trips that share stop sequences and shapes within a route.
      calendars          A calendar is a range of dates during which a trip is available.
      trips              A Trip is a time-specific journey taken by vehicles through Stops.
      blocks             Blocks are a sequence of trips taken by a single vehicle.


Add a new stop to this GTFS feed

    Given I'm at the stops component for this feed:  GTFS Import (Aug 23, 2019)
    Then I can add a new stop with this data:  ${STOP_NAME}  ${STOP_LAT}  ${STOP_LONG}  ${STOP_DESCR}
    And I can verify that this stop has been created:  ${STOP_NAME}


Export this GTFS feed to local file system

    Given I can export this feed:  GTFS Import (Aug 23, 2019)

    # Then Verify exported feed stop component contains the added stop

    # Potential bug?  The exported feed doesn't seem to contain new changes in 'stops.txt'?
    # The above test step not implemented


*** Keywords ***

I can see that this test GTFS feed is availalble:
    [Arguments]      ${feed name}
    [Tags]           local

    Page should contain  ${feed name}


I can open the feed named:
    [Arguments]      ${feed_name}
    [Tags]           local

    # Open the feed page
    Page should contain link  ${feed_link}
    Click link  ${feed_link}

    # Verify that the feed page is opened
    Wait until page contains element  name:name
    Page should contain  ${feed_name}


Go to the feed start page and open this feed
    [Arguments]      ${feed_name}
    [Tags]           local

    Go to  ${ROOT_URL}
    Wait Until Page Contains  QA User
    Run keyword  I can open the feed named:  ${feed_name}


Navigate to each component of the feed and verify:
    [Arguments]      ${component_name}  ${component_text}
    [Tags]           local

    # Verify and navigate to this component and verify the component descript text
    ${component_link}=  Catenate  ${FEED_LINK}/${component_name}
    Page should contain link  ${component_link}
    Click link  ${component_link}
    Wait until page contains  ${component_text}

    # Sleep for demo display purposes then go back to main feed page
    Sleep  ${DEMO_SLEEP_TIME}  reason=For demo purposes
    Go back


I'm at the stops component for this feed:
    [Arguments]      ${feed_name}
    [Tags]           local

    # Go to the feed home page and open the feed
    Run Keyword  Go to the feed start page and open this feed  ${feed_name}

    # Open the stops component
    ${component_link}=  Catenate  ${FEED_LINK}/stops
    Click link  ${component_link}
    Wait until page contains  Individual locations where vehicles pick up or drop off passengers.


I can add a new stop with this data:
    [Arguments]      ${name}  ${lat}  ${long}  ${descr}
    [Tags]           local

    # Add a new stop
    ${component_link}=  Catenate  ${FEED_LINK}/stops/new
    Click link  ${component_link}
    Wait until page contains  Save

    # Create a new stop
    Input text  name:name  ${name}
    Input text  name:position.latitude  ${lat}
    # Bug: the longitude field won't accept a neg number? This stop is now someplace in west China!
    Input text  name:position.longitude  ${long}
    Input text  name:description  ${descr}
    click button  Save


I can verify that this stop has been created:
    [Arguments]      ${name}
    [Tags]           local

    # Return to stops page and verify new stop is there
    Go back
    Wait until page contains  ${name}


I can export this feed:
    [Arguments]      ${name}
    [Tags]           local

    Go to  ${ROOT_URL}
    Wait Until Page Contains  QA User

    # Find this feed, open the menu and click 'Export'
    Click element  xpath://div/span[contains(text(),\'${name}\')]/parent::div/following-sibling::div/button
    Wait until page contains element  xpath://li[contains(text(),'Export')]
    Click element  xpath://li[contains(text(),'Export')]
    Wait until page contains  Export Successful

    Sleep  ${DEMO_SLEEP_TIME}  reason=For demo purposes
    Go to  ${ROOT_URL}


