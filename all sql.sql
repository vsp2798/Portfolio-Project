--------------------------SQL QUERIES FOR THE LONG TERM CARE SYSTEM---------------------------------------


-- What is the number of available visiting doctors with specialisations?

SELECT 
    COUNT(VSId), Type_of_specialisation
FROM
    visiting_specialists
GROUP BY Type_of_specialisation;

------------------------------------------------------------------------------------------------------------------
    
-- List the names of all residents who have allotted a private room and a semi-private room 

-- so you need count of residents ( resident id ), room type and group by (room id)


SELECT 
    r.Rname AS 'Resident Name', rm.Type_of_room AS 'Room Type'
FROM
    generates gn
        JOIN
    rooms rm ON gn.roomid = rm.RoomID
        JOIN
    Resident r ON gn.rid = r.RID
LIMIT 5;

SELECT r.Rname AS Resident_Name, rm.Type_of_room  
AS Room_Type From generates AS gn  
JOIN rooms AS rm On gn.roomid=rm.RoomID  
JOIN Resident AS r ON gn.rid=r.RID  
Limit 5 ; 

------------------------------------------------------------------------------------------------------------------


-- List the name of all residents that are assigned to a designated nurse?

-- you need name of residents, name of the nurse, connect with assigned table, name of nurse from employee table 

select r.Rname,a.NID
from Resident r
join Assigned a
on r.RID = a.ResidentID;

------------------------------------------------------------------------------------------------------------------

-- list the residents who are allergic to specific allergy?


-- what is the name or id of the visiting specialist assigned to a particular resident  



select * from visiting_specialists;
select * from prescribes;


SELECT 
    e.Ename AS 'Presciber Name',
    pr.prescriberID,
    r.Rname AS 'Resident Name',
    pr.rsid
FROM
    prescribes pr
        JOIN
    Resident r ON pr.rsid = r.RID
        JOIN
    employee e ON pr.prescriberID = e.EID
WHERE
    pr.prescriberID LIKE 'VS%'
LIMIT 10;

------------------------------------------------------------------------------------------------------------------

-- list the residents that are taken care by orthopaedic and physiotherapists

SELECT 
    r.Rname as 'Resident Name', vs.Type_of_specialisation AS Specialisation, vs.VSname as 'Doctor Name'
FROM
    visiting_specialists vs
        JOIN
    prescribes pr ON vs.VSId = pr.prescriberID
        JOIN
    Resident r ON pr.rsid = r.RID
WHERE
    Type_of_specialisation = 'Orthopedic'
        OR Type_of_specialisation = 'Physiotherapist'
LIMIT 10;


------------------------------------------------------------------------------------------------------------------

--- List the employees that have joined the facility in the past 2 years?

SELECT 
    Ename, Etype, Jdate
FROM
    employee
WHERE
    Jdate > '2020-04-05';
    
    
------------------------------------------------------------------------------------------------------------------

--- List the residents with high blood pressure are prescribed Lisinopril drug?

SELECT DISTINCT
    (res.Rname) AS 'Resident Name',
    r.Blood_Pressure AS 'Blood Pressure',
    m.MedicineName AS 'Medicine'
FROM
    records r
        JOIN
    prescribes pr ON r.Reid = pr.rsid
        JOIN
    Resident res ON pr.rsid = res.RID
        JOIN
    medicine m ON pr.medid = m.MedicineID
WHERE
    r.Blood_Pressure = 'High'
        AND m.MedicineName = 'Lisinopril';
        

------------------------------------------------------------------------------------------------------------------

--- List the residents who are allergic to a specific allergy ?

SELECT 
    res.Rname, rec.Allergies
FROM
    Resident res
        JOIN
    records rec ON res.RID = rec.Reid
WHERE
    rec.Allergies = 'Fish and Eggs'
    OR rec.Allergies='Nuts'  
	OR rec.Allergies='Seed'; 
        
------------------------------------------------------------------------------------------------------------------


select EID 
from employee 
where to_date = '9999-01-01' and 
datediff(to_date, jdate) = 
( 
   select max(datediff(to_date, jdate)) 
   from employee where to_date = '9999-01-01'
);

------------------------------------------------------------------------------------------------------------------

-- who is the longest admitted patient ?


SELECT 
    Resident.Rname AS 'Resident Name',
    DATEDIFF(SYSDATE(), Alloted.AdmitDate) AS 'Stay Duration'
FROM
    Alloted
        JOIN
    Resident ON Alloted.ResID = Resident.RID
WHERE
    DATEDIFF(SYSDATE(), Alloted.AdmitDate) = (SELECT 
            MAX(DATEDIFF(SYSDATE(), Alloted.AdmitDate))
        FROM
            Alloted);







    