# Data analysis queries providing some insights for users to benefit for college selection

-- ------------------------------------------------------------------------------------------------------------------------------------
# Analysing the most common acrrediting agencies by quering accrediting agencies and its corresponding number of institutes accredited by them 

SELECT DISTINCT COUNT(ii.institutionID),
				a.accredCode, 
                aa.accredAgency  
FROM institutioninformation AS ii
INNER JOIN accredatedby AS a
ON ii.institutionID = a.institutionID
INNER JOIN accredatingagency AS aa
ON aa.accredCode = a.accredCode
WHERE totalAdmissions IS NOT NULL
AND totalAdmissions <> 0
GROUP BY a.accredCode
ORDER BY COUNT(ii.institutionID) DESC 
LIMIT 15;

-- ------------------------------------------------------------------------------------------------------------------------------------
# Analysing percentage of completion rate of the degrees for each programme

SELECT	pd.programmeCode, 
		pd.programmeDesc, 
        ROUND(AVG(ii.completionRate)*100,2) percent_completion_rate
FROM institutioninformation AS ii
INNER JOIN institutiondegree AS id 
ON ii.institutionID = id.institutionID
INNER JOIN programmedetails AS pd
ON id.programmeCode = pd.programmeCode
WHERE completionRate IS NOT NULL
GROUP BY programmeCode 
LIMIT 15;

-- ------------------------------------------------------------------------------------------------------------------------------------
# Analysis of how much percent the tuition fees for out of state students are greater than that of the in state students for every state

With A AS (SELECT DISTINCT i.state, 
			      CAST((ABS(e.tuitionfeeinstate - e.tuitionfeeoutstate)/e.tuitionfeeinstate)*100 AS DECIMAL (10, 2)) as high_outstate_fee
		  FROM expenses AS e 
		  INNER JOIN institution AS i
		  ON i.institutionID = e.institutionID
		  ORDER BY i.state, high_outstate_fee)
SELECT state, 
	   AVG(high_outstate_fee) as avgpercent 
FROM A
GROUP BY state
ORDER BY avgpercent DESC; 

-- ------------------------------------------------------------------------------------------------------------------------------------
# Analysing the maximum salary in the first and the second year after completing the respective types of degrees

WITH max_salaries AS (
					SELECT  id.degreeTypeLevel, 
							MAX(id.placementSalaryYr1) as max_1st_year_salary, 
							MAX(id.placementSalaryYr2) as max_2st_year_salary, 
							dd.degreeTypeDesc
					FROM institutiondegree AS id
					INNER JOIN degreedetails AS dd 
					ON id.degreeTypeLevel = dd.degreeTypeLevel
					WHERE placementSalaryYr1 IS NOT NULL
					AND placementSalaryYr2 IS NOT NULL
					GROUP BY id.degreeTypeLevel
					)
SELECT 	degreeTypeLevel,
		degreeTypeDesc,
		ROUND(max_1st_year_salary/100)*100 as max_1st_year_salary, 
        ROUND(max_2st_year_salary/100)*100 as max_2st_year_salary
FROM max_salaries
ORDER BY degreetypelevel;

-- ------------------------------------------------------------------------------------------------------------------------------------
# Analysing the relation of the employee satisfaction,average salary of faculty and the admission rate with respect to the governance structure

SELECT governanceStructure,
		ROUND(AVG(employeeSatisfaction), 2) as avg_employee_satisfaction,
        ROUND(AVG(avgFacultySalary)/10)*10 avg_faculty_salary, 
        ROUND(AVG(admissionRate)) _avg_admission_rate
 FROM institutioninformation
 GROUP BY governanceStructure;
 
 -- ------------------------------------------------------------------------------------------------------------------------------------
 # Analysing the number of institions in each state which are of type either men only, women only or having distance education only
 
WITH Women AS (	SELECT count(it.institutionID) as Inst_type, i.state
				FROM institutiontype as it
				INNER JOIN institution AS i 
				ON it.institutionID = i.institutionID
				WHERE womenOnly = 'True'
				GROUP BY i.state
			),
	Men AS 
			(	SELECT count(it.institutionID) as Inst_type, i.state
				FROM institutiontype as it
				INNER JOIN institution AS i 
				ON it.institutionID = i.institutionID
				WHERE menOnly = 'True'
				GROUP BY i.state
			),
	Distance AS 
			(	SELECT count(it.institutionID) as Inst_type, i.state
				FROM institutiontype as it
				INNER JOIN institution AS i 
				ON it.institutionID = i.institutionID
				WHERE distanceOnly = 'True'
				GROUP BY i.state
			)
SELECT DISTINCT women.Inst_type as womenonly, 
				men.Inst_type as menonly,
				distance.Inst_type as distanceonly, 
				women.state
FROM women 
INNER JOIN men ON women.state = men.state
INNER JOIN distance ON men.state = distance.state;
