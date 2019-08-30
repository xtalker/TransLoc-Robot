*** Settings ***
# Resource file with global common settings and reusable project-wide stuff

# Dont forget to setup the Python venv with: source ../requis-2.0/test/bob_qa/robot_project/venv/bin/activate

Library    DebugLibrary
Library    String

           # run_on_failure: Debug, Nothing or Capture Page Screenshot (default)
Library    SeleniumLibrary   run_on_failure=Capture Page Screenshot  timeout=10.0


*** Variables ***

# Browser related
${BROWSER}                firefox     # Can be overridden by command line option
${ROOT_URL}               https://login.stage.transloc.com/login/?next=https://architect.stage.transloc.com/
${BROWSER_WINDOW_HEIGHT}  1200
${BROWSER_WINDOW_WIDTH}   1280
${SELENIUM_SPEED}         0.2 seconds  # 0.2 here makes it easy to watch (takes about 3x longer)

# TransLoc architect credentials
${USERID}       qa_user_02
${PASSWORD}     EhTAs7K4hJB^


*** Keywords ***

Open browser and start
    [Tags]   common

    Set selenium speed   ${SELENIUM_SPEED}
    Open Browser         ${ROOT_URL}  ${BROWSER}
    Set window size      ${BROWSER_WINDOW_WIDTH}  ${BROWSER_WINDOW_HEIGHT}
    Sleep  5 s  reason=Delay to start the screen recorder


I'm logged in as
    [Arguments]      ${userid}  ${passwd}
    [Tags]           common

    # Make sure we're at the login page
    Wait Until Page Contains  Forgot your password?

    Input Text      id=username     ${userid}
    Input Text      id=password     ${passwd}
    Click Button    Log in

    # Logged in?
    Wait Until Page Contains  QA User

