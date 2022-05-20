# Insert Queries for all the tables (The data is inserted from stage1 tables- alldata, fielddata and dataforuser) 

INSERT INTO Institution(
			institutionID, 
			institutionName, 
			city, 
			state, 
			zipCode) 
SELECT institutionID, 
			institutionName, 
			city, 
			state, 
			zipCode 
FROM alldata
ORDER BY institutionID, 
			institutionName, 
			state, 
			city, 
			zipCode;
            
-- -----------------------------------------------------------------------------------
INSERT INTO AccredatingAgency(
			accredCode, 
			accredAgency) 
SELECT DISTINCT accredCode, 
			accredAgency 
FROM alldata 
WHERE accredCode IS NOT NULL
ORDER BY accredCode; 
            
-- -----------------------------------------------------------------------------------
INSERT INTO AccredatedBy(
			institutionID, 
			accredCode) 
SELECT DISTINCT institutionID, 
			accredCode 
FROM alldata
WHERE accredCode IS NOT NULL
ORDER BY institutionID; 
            
-- -----------------------------------------------------------------------------------
INSERT INTO Expenses(
			institutionID,
			totalFee,
			tuitionFeeInState,
			tuitionFeeOutState,
			bookSupplies, 
			housing,
			miscellaneous) 
SELECT DISTINCT institutionID,
			totalFee, 
			tuitionFeeInState,
			tuitionFeeOutState, 
			bookSupplies, 
			housing, 
			miscellaneous 
FROM alldata
WHERE institutionID IS NOT NULL and 
			totalFee IS NOT NULL and
			tuitionFeeInState IS NOT NULL and
			tuitionFeeOutState IS NOT NULL and
			bookSupplies IS NOT NULL and
			housing IS NOT NULL and
			miscellaneous IS NOT NULL; 
            
-- -----------------------------------------------------------------------------------
INSERT INTO InstitutionType(
			institutionID, 
			menOnly, 
			womenOnly, 
			distanceOnly) 
SELECT DISTINCT institutionID, 
			menOnly, 
			womenOnly,
			distanceOnly 
FROM alldata; 
            
-- -----------------------------------------------------------------------------------
INSERT INTO ProgrammeDetails(
			programmeCode, 
			programmeDesc) 
SELECT DISTINCT programmeCode, 
			programmeDesc 
FROM fielddata
ORDER BY programmeCode;
            
-- -----------------------------------------------------------------------------------
INSERT INTO DegreeDetails(
			degreeTypeLevel,
			degreeTypeDesc) 
SELECT DISTINCT degreeTypeLevel,
			degreeTypeDesc 
FROM fielddata; 
            
-- -----------------------------------------------------------------------------------
INSERT INTO institutiondegree (
			institutionID, 
			programmeCode, 
			degreeTypeLevel, 
			placementSalaryYr1, 
			placementSalaryYr2  )
SELECT DISTINCT institutionID,
			programmeCode, 
			degreeTypeLevel, 
			placementSalaryYr1, 
			placementSalaryYr2 
FROM fielddata AS fd 
INNER JOIN alldata ad 
ON ad.institutionID = fd.institutionID; 
            
-- -----------------------------------------------------------------------------------
INSERT INTO InstitutionInformation(
			institutionID,
			url,
			npcUrl,
			mainCampus,
			numBranch,
			governanceStructure,
			affiliation,
			admissionRate,
			totalAdmissions,
			pctPartTimeAdmissions,
			completionRate,
			avgFacultySalary,
			rating,
			ranking,
			onCampusHousing,
			employeeSatisfaction,
			transportFacility,
			numReviews) 
SELECT institutionID,
			url,
			npcUrl,
			mainCampus,
			numBranch,
			governanceStructure,
			CONCAT(HBCU, PBI, ANNHI,TRIBAL,AANAPII,HSI,NANTI) AS affiliation,
			admissionRate,
			totalAdmissions,
			pctPartTimeAdmissions,
			completionRate,
			avgFacultySalary,
			rating,
			ranking,
			onCampusHousing,
			employeeSatisfaction,
			transportFacility,
			inumReviews
FROM alldata;
            
-- -----------------------------------------------------------------------------------
INSERT INTO User(id, 
			username, 
			password, 
			role) 
SELECT id, 
			username, 
			password, 
			role 
FROM dataforuser;
            
-- -----------------------------------------------------------------------------------
INSERT INTO UserProfile(
			id, 
			email, 
			firstName, 
			lastName, 
			createdOn, 
			updatedOn, 
			country, 
			city, 
			state, 
			zipCode) 
SELECT id, 
			email, 
			firstName, 
			lastName, 
			createdOn,
			updatedOn, 
			country, 
			city, 
			state, 
			zipCode
FROM dataforuser;