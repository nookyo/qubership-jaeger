import os
import time

from PlatformLibrary import PlatformLibrary

environ = os.environ
namespace = environ.get("JAEGER_NAMESPACE")
service = environ.get("JAEGER_SERVICE_NAME")
jaeger_query = f"{service}-query"
jaeger_collector = f"{service}-collector"
timeout = 300


if __name__ == '__main__':
    print('Start Jaeger pods checker script')
    time.sleep(5)

    try:
        k8s_lib = PlatformLibrary("true")
    except Exception as e:
        print(e)
        exit(1)

    timeout_start = time.time()
    while time.time() < timeout_start + timeout:
        try:
            jaeger_query_deployments = k8s_lib.get_deployment_entities_count_for_service(namespace, jaeger_query, 'name')
            jaeger_query_ready_deployments = k8s_lib.get_active_deployment_entities_count_for_service(namespace, jaeger_query, 'name')
            print(f'[Check status] Query deployments: {jaeger_query_deployments}, ready deployments: {jaeger_query_ready_deployments}')

            jaeger_collector_deployments = k8s_lib.get_deployment_entities_count_for_service(namespace, jaeger_collector, 'name')
            jaeger_collector_ready_deployments = k8s_lib.get_active_deployment_entities_count_for_service(namespace, jaeger_collector, 'name')
            print(f'[Check status] Collector deployments: {jaeger_collector_deployments}, ready deployments: {jaeger_collector_ready_deployments}')
        except Exception as e:
            print(e)
            continue

        if jaeger_query_deployments == jaeger_query_ready_deployments and jaeger_query_deployments != 0 and jaeger_collector_deployments == jaeger_collector_ready_deployments and jaeger_collector_deployments != 0:
            print("Jaeger query and collector deployments are ready")
            time.sleep(10)
            exit(0)

        time.sleep(10)

    print(f'Jaeger query and collector deployments are not ready at least {timeout} seconds')
    exit(1)
