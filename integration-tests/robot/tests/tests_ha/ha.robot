*** Settings ***
Resource  ../shared/shared.robot
Suite Setup  Preparation


*** Test Cases ***
Reboot query pod
    [Tags]  ha  query
    Check Jaeger Alive
    ${component} =  Set Variable  query
    ${trace} =  JaegerLibrary.generate_trace
    Post Random Spans  ${trace}
    Get Trace From Jaeger With Attempts  ${trace[0]['traceId']}
    Get List Pod Names For Deployment Entity  ${component}
    Get Active Deployment Replicas  ${component}
    FOR  ${pod}  IN  @{list_pods}
        Delete Pod By Pod Name  ${pod}  ${JAEGER_NAMESPACE}
        Log To Console  Delete ${pod}
        Sleep  1s
    END
    Get Trace From Jaeger With Attempts  ${trace[0]['traceId']}
    [Teardown]  Set Replicas For Deployment Entity  ${JAEGER_SERVICE_NAME}-${component}  ${JAEGER_NAMESPACE}  replicas=${ACTIVE_POD}

Reboot collector pods
    [Tags]  ha  collector
    Check Jaeger Alive
    ${component} =  Set Variable  collector
    ${trace} =  JaegerLibrary.generate_trace
    Post Random Spans  ${trace}
    Get Trace From Jaeger With Attempts  ${trace[0]['traceId']}
    Get List Pod Names For Deployment Entity  ${component}
    Get Active Deployment Replicas  ${component}
    FOR  ${pod}  IN  @{list_pods}
        Delete Pod By Pod Name  ${pod}  ${JAEGER_NAMESPACE}
        Log To Console  Delete ${pod}
        Sleep  2s
        ${trace} =  JaegerLibrary.generate_trace
        Wait Until Keyword Succeeds  ${COUNT_OF_RETRY}  ${RETRY_INTERVAL}
        ...  Post Random Spans  ${trace}
        Get Trace From Jaeger With Attempts  ${trace[0]['traceId']}
    END
    [Teardown]  Set Replicas For Deployment Entity  ${JAEGER_SERVICE_NAME}-${component}  ${JAEGER_NAMESPACE}  replicas=${ACTIVE_POD}
