*** Settings ***
Library  String
Library  Collections
Library  PlatformLibrary  managed_by_operator=true

*** Variables ***
${NAMESPACE}      %{JAEGER_NAMESPACE}

