#!/bin/bash

. "/opt/spark/bin/load-spark-env.sh"

if [ "$SPARK_WORKLOAD" == "master" ];
then

export SPARK_MASTER_HOST=`hostname`
export worker1=9091
export worker2=9092

cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.master.Master --ip $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT >> $SPARK_MASTER_LOG
cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.worker.Worker --ip $SPARK_MASTER_HOST --port 9091 -c 2 -m 2G spark://10.128.0.1:7077
cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.worker.Worker --ip $SPARK_MASTER_HOST --port 9092 -c 2 -m 2G spark://10.128.0.1:7077

elif [ "$SPARK_WORKLOAD" == "worker" ];
then

cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.worker.Worker --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER >> $SPARK_WORKER_LOG

elif [ "$SPARK_WORKLOAD" == "submit" ];
then
    echo "SPARK SUBMIT"
else
    echo "Undefined Workload Type $SPARK_WORKLOAD, must specify: master, worker, submit"
fi
