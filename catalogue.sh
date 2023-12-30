#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGDB_HOST=mongodb.awsdevopslearning.website

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE () {
   if [ "$1" -ne 0 ]; then
      echo -e "$2 ...$R FAILED $N"
   else
      echo -e "$2 ...$G SUCCESS $N"
   fi
}



if [ $ID -ne 0 ];
then
   echo -e "$R ERROR:: Please run this script with root access $N"
   exit 1 # you can give other than 0
else
   echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current Nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling Nodejs::18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing Nodejs"

useradd roboshop &>> $LOGFILE

VALIDATE $? "Adding User"

mkdir /app &>> $LOGFILE

VALIDATE $? "Creating directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Dowloading catalogue application"

cd /app &>> $LOGFILE &>> $LOGFILE

VALIDATE $? "Opening the directory"

npm install $LOGFILE &>> $LOGFILE


VALIDATE $? "Installing npm"

cp /home/centos/Roboshop/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying catalogue service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon reloading"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "enabling catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "starting catalogue"

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copying Mongo repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "installing mongo repo"

mongo --host $MONGDB_HOST</app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalogue data in to mongdb"
