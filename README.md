# kafka-k8s
k8s StatefulSet wrapper for [Apache Kafka official docker image](https://cwiki.apache.org/confluence/display/KAFKA/KIP-975%3A+Docker+Image+for+Apache+Kafka)

## Usage
1. Clone this project using

```
git clone https://github.com/averemee-si/kafka-k8s
```

2. Create and tag docker image

```
docker build -t averemee/kafka4k8s:0 .
```

3. Deploy Kafka cluster to k8s using

```
apiVersion: v1
kind: Service
metadata:
  name: kafka-headless-svc
  labels:
    app: kafka-app
spec:
  clusterIP: None
  ipFamilyPolicy: SingleStack
  ipFamilies:
  - IPv4
  ports:
    - name: '9092'
      port: 9092
      protocol: TCP
      targetPort: 9092
  selector:
    app: kafka-app
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: kafka
  labels:
    app: kafka-app
spec:
  serviceName: kafka-headless-svc
  replicas: 3
  selector:
    matchLabels:
      app: kafka-app
  template:
    metadata:
      labels:
        app: kafka-app
    spec:
      containers:
        - name: kafka-container
          image: averemee/kafka4k8s:0
          ports:
            - containerPort: 9092
            - containerPort: 9093
          env:
            - name: REPLICAS
              value: '3'
            - name: CLUSTER_ID
              value: ryGWk9_ISQ2OxoXJp4NK5Q
            - name: KAFKA_PROCESS_ROLES
              value: 'controller,broker'
            - name: KAFKA_LISTENERS
              value: 'PLAINTEXT://:9092,CONTROLLER://:9093' 
            - name: KAFKA_LISTENER_SECURITY_PROTOCOL_MAP
              value: 'CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT'
            - name: KAFKA_CONTROLLER_LISTENER_NAMES
              value: 'CONTROLLER'
            - name: KAFKA_INTER_BROKER_LISTENER_NAME
              value: 'PLAINTEXT'
            - name: KAFKA_LOG_DIRS
              value: '/tmp/kraft-combined-logs'

```


