# Create Table Queries for all the tables

CREATE TABLE `accredatedby` (
  `institutionID` int NOT NULL,
  `accredCode` varchar(15) NOT NULL,
  PRIMARY KEY (`institutionID`,`accredCode`),
  KEY `accredatedby_ibfk_3` (`accredCode`),
  CONSTRAINT `accredatedby_ibfk_1` FOREIGN KEY (`institutionID`) REFERENCES `institution` (`institutionID`),
  CONSTRAINT `accredatedby_ibfk_2` FOREIGN KEY (`institutionID`) REFERENCES `institution` (`institutionID`),
  CONSTRAINT `accredatedby_ibfk_3` FOREIGN KEY (`accredCode`) REFERENCES `accredatingagency` (`accredCode`)
) ;

CREATE TABLE `accredatingagency` (
  `accredCode` varchar(15) NOT NULL,
  `accredAgency` varchar(150) NOT NULL,
  PRIMARY KEY (`accredCode`),
  KEY `AccredatingAgency_index` (`accredAgency`)
) ;


CREATE TABLE `degreedetails` (
  `degreeTypeLevel` int NOT NULL,
  `degreeTypeDesc` varchar(50) NOT NULL,
  PRIMARY KEY (`degreeTypeLevel`),
  KEY `DegreeDetails_index` (`degreeTypeDesc`)
) ;


CREATE TABLE `expenses` (
  `institutionID` int NOT NULL,
  `totalFee` float DEFAULT NULL,
  `tuitionFeeInState` float DEFAULT NULL,
  `tuitionFeeOutState` float DEFAULT NULL,
  `bookSupplies` float DEFAULT NULL,
  `housing` float DEFAULT NULL,
  `miscellaneous` float DEFAULT NULL,
  PRIMARY KEY (`institutionID`),
  CONSTRAINT `expenses_ibfk_1` FOREIGN KEY (`institutionID`) REFERENCES `institution` (`institutionID`)
) ;

CREATE TABLE `institution` (
  `institutionID` int NOT NULL,
  `institutionName` varchar(120) NOT NULL,
  `city` varchar(25) NOT NULL,
  `state` char(2) NOT NULL,
  `zipCode` char(10) NOT NULL,
  PRIMARY KEY (`institutionID`),
  KEY `Institution_index` (`city`)
) ;

CREATE TABLE `institutiondegree` (
  `institutionID` int NOT NULL,
  `programmeCode` int NOT NULL,
  `degreeTypeLevel` int NOT NULL,
  `placementSalaryYr1` int DEFAULT NULL,
  `placementSalaryYr2` int DEFAULT NULL,
  PRIMARY KEY (`institutionID`,`degreeTypeLevel`,`programmeCode`),
  KEY `degreeTypeLevel` (`degreeTypeLevel`),
  KEY `programmeCode` (`programmeCode`),
  CONSTRAINT `institutiondegree_ibfk_1` FOREIGN KEY (`institutionID`) REFERENCES `institution` (`institutionID`),
  CONSTRAINT `institutiondegree_ibfk_2` FOREIGN KEY (`degreeTypeLevel`) REFERENCES `degreedetails` (`degreeTypeLevel`),
  CONSTRAINT `institutiondegree_ibfk_3` FOREIGN KEY (`programmeCode`) REFERENCES `programmedetails` (`programmeCode`)
) ;

CREATE TABLE `institutioninformation` (
  `institutionID` int NOT NULL,
  `url` text NOT NULL,
  `npcUrl` text,
  `mainCampus` char(5) NOT NULL,
  `numBranch` int DEFAULT NULL,
  `governanceStructure` char(18) NOT NULL,
  `affiliation` int DEFAULT NULL,
  `admissionRate` int DEFAULT NULL,
  `totalAdmissions` float DEFAULT NULL,
  `pctPartTimeAdmissions` float DEFAULT NULL,
  `completionRate` float DEFAULT NULL,
  `avgFacultySalary` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `ranking` int DEFAULT NULL,
  `onCampusHousing` varchar(13) DEFAULT NULL,
  `employeeSatisfaction` int DEFAULT NULL,
  `transportFacility` varchar(13) DEFAULT NULL,
  `numReviews` int DEFAULT NULL,
  PRIMARY KEY (`institutionID`),
  KEY `InstitutionInformation_index` (`governanceStructure`),
  CONSTRAINT `institutioninformation_ibfk_1` FOREIGN KEY (`institutionID`) REFERENCES `institution` (`institutionID`)
) ;

CREATE TABLE `institutiontype` (
  `institutionID` int NOT NULL,
  `menOnly` char(5) DEFAULT NULL,
  `womenOnly` char(5) DEFAULT NULL,
  `distanceOnly` char(5) DEFAULT NULL,
  PRIMARY KEY (`institutionID`),
  CONSTRAINT `institutiontype_ibfk_1` FOREIGN KEY (`institutionID`) REFERENCES `institution` (`institutionID`)
) ;

CREATE TABLE `institutionuser` (
  `institutionID` int NOT NULL,
  `id` int NOT NULL,
  PRIMARY KEY (`institutionID`,`id`),
  KEY `id` (`id`),
  CONSTRAINT `institutionuser_ibfk_1` FOREIGN KEY (`institutionID`) REFERENCES `institution` (`institutionID`),
  CONSTRAINT `institutionuser_ibfk_2` FOREIGN KEY (`id`) REFERENCES `user` (`id`)
) ;


CREATE TABLE `instrepresentative` (
  `id` int NOT NULL,
  `institutionID` int NOT NULL,
  `institutionName` varchar(70) NOT NULL,
  PRIMARY KEY (`id`,`institutionID`),
  KEY `institutionID` (`institutionID`),
  CONSTRAINT `instrepresentative_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`),
  CONSTRAINT `instrepresentative_ibfk_2` FOREIGN KEY (`institutionID`) REFERENCES `institution` (`institutionID`)
) ;

CREATE TABLE `programmedetails` (
  `programmeCode` int NOT NULL,
  `programmeDesc` varchar(200) NOT NULL,
  PRIMARY KEY (`programmeCode`),
  KEY `ProgrammeDetails_index` (`programmeDesc`)
) ;

CREATE TABLE `user` (
  `id` int NOT NULL,
  `username` varchar(10) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ;

CREATE TABLE `userprofile` (
  `id` int NOT NULL,
  `email` varchar(40) NOT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `createdOn` datetime DEFAULT NULL,
  `updatedOn` datetime DEFAULT NULL,
  `country` varchar(25) DEFAULT NULL,
  `city` varchar(25) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  `zipCode` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `userprofile_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`)
) ;