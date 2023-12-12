#!/usr/bin/sh

source ~/.bashrc

export OV_TARGET_LIST="192.168.50.141/24"

if [ $# -ne 0 ]; then
  echo "Usage: $0"
  exit 1;
fi

echo $OV_USER

if [ ! -v OV_USER ]; then
  echo "OV_USER not set"
  exit 1;
fi

if [ ! -v OV_PASS ]; then
  echo "OV_PASS not set"
  exit 1;
fi

if [ ! -v OV_TARGET_LIST ]; then
  echo "OV_TARGET_LIST not set"
  exit 1;
fi

mkdir -p data

export OV_CONTAINER=$(docker ps -qf "name=gvm-tools")
export OV_TARGET_NAME=$(uuid)
export OV_LOGFILE=data/scan.log

# Create Target

echo "Start scan at $(date)" >> $OV_LOGFILE

docker exec --user gvm $OV_CONTAINER gvm-cli --gmp-username $OV_USER --gmp-password $OV_PASS socket --pretty --xml "<create_target><name>$OV_TARGET_NAME</name><hosts>$OV_TARGET_LIST</hosts><port_list id='33d0cd82-57c6-11e1-8ed1-406186ea4fc5'></port_list></create_target>" > data/target.xml

OV_STATUS=$(xmlstarlet sel -t -v  "/create_target_response/@status" data/target.xml)
if [ "$OV_STATUS" = "201" ]; then 
    echo "create_target SUCCESS" >> $OV_LOGFILE
else
    echo "create_target FAIL" >> $OV_LOGFILE
    exit 1
fi;


# Create Task using target id

OV_TARGET_ID=$(xmlstarlet sel -t -v  "/create_target_response/@id" data/target.xml)

docker exec --user gvm $OV_CONTAINER gvm-cli --gmp-username $OV_USER --gmp-password $OV_PASS socket --pretty --xml "<create_task><name>Scan</name><comment>Simple Scan</comment><config id='daba56c8-73ec-11df-a475-002264764cea'/><target id=\"$OV_TARGET_ID\"/><scanner id='08b69003-5fc2-4037-a479-93b440211c73'/></create_task>" > data/task.xml

OV_STATUS=$(xmlstarlet sel -t -v  "/create_task_response/@status" data/task.xml)
if [ "$OV_STATUS" = "201" ]; then 
    echo "create_task SUCCESS" >> $OV_LOGFILE
else
    echo "create_task FAIL" >> $OV_LOGFILE
    exit 1
fi;

# Start Task using task id

OV_TASK_ID=$(xmlstarlet sel -t -v  "/create_task_response/@id" data/task.xml)

docker exec --user gvm $OV_CONTAINER gvm-cli --gmp-username $OV_USER --gmp-password $OV_PASS socket --pretty --xml "<start_task task_id=\"$OV_TASK_ID\"/>" > data/report.xml

# 202 = started
OV_STATUS=$(xmlstarlet sel -t -v  "/start_task_response/@status" data/report.xml)
if [ "$OV_STATUS" = "202" ]; then 
    echo "start_task SUCCESS" >> $OV_LOGFILE
else
    echo "start_task FAIL" >> $OV_LOGFILE
    exit 1
fi;

# Get status of task using task id

OV_TASK_STATUS="Pending"
while [ "$OV_TASK_STATUS" != "Done" ]
do
    docker exec --user gvm $OV_CONTAINER gvm-cli --gmp-username $OV_USER --gmp-password $OV_PASS socket --pretty --xml "<get_tasks task_id=\"$OV_TASK_ID\"/>" > data/status.xml
    OV_TASK_STATUS=$(xmlstarlet sel -t -v  "/get_tasks_response/task/status" data/status.xml)
    if [ "$OV_TASK_STATUS" = "Done" ]; then 
        echo "Task Status Done" >> $OV_LOGFILE
    else
        echo "Task Status Pending" >> $OV_LOGFILE
    fi;
    sleep 5
done

# Get detailed results from task id of completed scan

docker exec --user gvm $OV_CONTAINER gvm-cli --gmp-username $OV_USER --gmp-password $OV_PASS socket --pretty --xml "<get_results task_id=\"$OV_TASK_ID\" filter='apply_overrides=0 levels=hml rows=1000 min_qod=70 first=1 sort-reverse=severity'/>" > data/detail.xml

echo "End scan at $(date)" >> $OV_LOGFILE

cat data/detail.xml
exit 0

