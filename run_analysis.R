##UCI HAR Dataset is in the desktop
file<-"C:/Users/Ahuaflower/Desktop/UCI HAR Dataset"
setwd(file)
lsfile<-list.files()

features<-read.table(lsfile[2],sep=" ")
act<-read.table(lsfile[1],sep=" ")
test<-lsfile[5]
train<-lsfile[6]

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

number<-grep("mean",colnames(data))
number<-c(1,2,3,number)
ExtractData<-data[,number]

library(reshape2)
ExtractData<-mutate(ExtractData,index=paste(ExtractData$`ActLab$Activity`,ExtractData$subject,sep="_"))
colnames(ExtractData)[1]="Activity"
result<-melt(ExtractData,id=50,measure.vars = 4:49)
library(plyr)
Tab<-dcast(result,index~variable,mean)


setwd(file)
write.table(Tab,file="result.txt",row.names=FALSE)
