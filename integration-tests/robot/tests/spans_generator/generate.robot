*** Settings ***
Resource  ../shared/shared.robot
Suite Setup  Preparation


*** Test Cases ***
Send spans
    [Tags]  generator
    FOR  ${i}  IN RANGE  ${GENERATE_COUNT}
        ${trace} =  JaegerLibrary.generate_trace
        Post Random Spans As Generator  ${trace}
        sleep  ${WAITING_TIME}
    END
