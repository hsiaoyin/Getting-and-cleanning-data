##First please set your working directory- UCI HAR Dataset
file<-"C:/Users/Ahuaflower/Desktop/UCI HAR Dataset"
setwd(file)


features<-read.table("features.txt",sep=" ")
act<-read.table("activity_labels.txt",sep=" ")
test<-"test"
train<-"train"

##test##
setwd(test)
label<-read.table("y_test.txt",sep=" ")
ActLab<-merge(label,act,by.x="V1",by.y="V1")

subject<-read.table("subject_test.txt",sep=" ")
testset<-read.table("X_test.txt",sep="")
n<-lengths(testset)[[1]]
groupname<-data.frame("Test/Trainning"=rep("test",n))

colnames(ActLab)<-c("Id","Activity")
colnames(subject)<-"subject"
colnames(testset)<-features[[2]]

test<-cbind(ActLab$Activity,subject,groupname,testset)

##trainning##
setwd(file)
setwd(train)
label<-read.table("y_train.txt",sep=" ")
subject<-read.table("subject_train.txt",sep=" ")
trainset<-read.table("X_train.txt",sep="")
n<-lengths(trainset)[[1]]
groupname<-data.frame("Test/Trainning"=rep("train",n))

ActLab<-merge(label,act,by.x = "V1",by.y="V1")

colnames(ActLab)<-c("Id","Activity")
colnames(subject)<-"subject"
colnames(trainset)<-features[[2]]

train<-cbind(ActLab$Activity,subject,groupname,trainset)

data<-rbind(test,train)
colnames(data)[1]="Activity"
mean<-grep("mean",colnames(data))
sd<-grep("std",colnames(data))
number<-c(1,2,3,mean,sd)
ExtractData<-data[,number]

names<-names(ExtractData)
names<-gsub('-mean()-','Mean',names)
names<-gsub('-std()','Std',names)
names<-gsub('[()]','',names)
names(ExtractData)=names
ExtractData$subject=as.factor(ExtractData$subject)


library(reshape2)
library(plyr)

result <- melt(ExtractData[,-3], id = c("Activity", "subject"))

Tab<-dcast(result,Activity+subject~variable,mean)


setwd(file)
write.table(Tab,file="Q5.txt",row.names=FALSE)
write.table(ExtractData,file="Q4.txt",row.names=FALSE)

