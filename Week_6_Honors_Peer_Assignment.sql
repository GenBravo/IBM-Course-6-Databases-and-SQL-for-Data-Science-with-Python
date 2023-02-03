SELECT CPS.NAME_OF_SCHOOL, CPS.community_area_name, CPS.average_student_attendance, CD.hardship_index
FROM CHICAGO_PUBLIC_SCHOOLS CPS
LEFT OUTER JOIN CENSUS_DATA CD ON CPS.community_area_number = CD.COMMUNITY_AREA_NUMBER
WHERE CD.hardship_index = 98;


SELECT Case_Number, Primary_Type, COMMUNITY_AREA_NAME
FROM CHICAGO_CRIME_DATA CCD
LEFT OUTER JOIN CENSUS_DATA CD ON CCD.COMMUNITY_AREA_NUMBER = CD.COMMUNITY_AREA_NUMBER	
WHERE CCD.LOCATION_DESCRIPTION LIKE '%SCHOOL%';


CREATE VIEW CSTM_V AS SELECT 
NAME_OF_SCHOOL AS School_Name,
Safety_Icon	as Safety_Rating,
Family_Involvement_Icon as Family_Rating,
Environment_Icon as Environment_Rating,
Instruction_Icon as Instruction_Rating,
Leaders_Icon as Leaders_Rating,
Teachers_Icon as Teachers_Rating
FROM CHICAGO_PUBLIC_SCHOOLS;

SELECT * FROM CSTM_V;
SELECT School_Name, Leaders_Rating FROM CSTM_V;


ALTER TABLE CHICAGO_PUBLIC_SCHOOLS      
ALTER COLUMN LEADERS_ICON     
SET DATA TYPE VARCHAR(20); 



DROP PROCEDURE UPDATE_LEADERS_SCORE;

--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE ( 
    IN in_School_ID INTEGER, IN in_Leader_Score INTEGER )     -- ( { IN/OUT type } { parameter-name } { data-type }, ... )

LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table

BEGIN 
     UPDATE CHICAGO_PUBLIC_SCHOOLS 
     SET LEADERS_SCORE = in_Leader_Score
     WHERE SCHOOL_ID = in_School_ID;
     
     IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN                           -- Start of conditional statement
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Very weak'
        WHERE SCHOOL_ID = in_School_ID;
        
	 ELSEIF in_Leader_Score < 40 THEN                           
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Weak'
        WHERE SCHOOL_ID = in_School_ID;
        
	 ELSEIF in_Leader_Score < 60 THEN                           
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Average'
        WHERE SCHOOL_ID = in_School_ID;
        
     ELSEIF in_Leader_Score < 80 THEN                           
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Strong'
        WHERE SCHOOL_ID = in_School_ID;
        
	 ELSEIF in_Leader_Score < 100 THEN
   		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET Leaders_Icon = 'Very strong'
        WHERE SCHOOL_ID = in_School_ID;     

 	 ELSE                                   
        ROLLBACK WORK;

	 END IF;
	 
	 COMMIT WORK;
END
@                                                           -- Routine termination character


CALL UPDATE_LEADERS_SCORE(610038, 10);

SELECT * FROM CSTM_V;


