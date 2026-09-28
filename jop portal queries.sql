-- basic queries:-- 
select company_name,company_id from Companies;
select result from Interviews where interview_id=5;
select skill_name from Skills where skill_id in(3,4,5);
select*from Jobs where salary >60000 and company_id in (5,6,7,8,9,10);
select*from Jobs where salary >50000 or company_id in (11,12,13,14,15);
select*from Jobs where not salary>50000 and job_id=4;
select* from Application_Status limit 5 offset 2;
select*from Experience where company_name like "A%";
select*from Experience where company_name like "%S";
select*from Jobs where salary between 50000 and 1300000.00;
select * from Candidates order by date_of_birth desc;
select distinct* from Companies;


-- Aggregate Function--
select count(*) from Jobs;
select count(salary)from Jobs ;
select min(salary) from Jobs;
select max(salary) from Jobs;
select avg(salary)from Jobs;
select sum(salary)as total,job_Title from Jobs group by job_Title order by total desc limit 1;
select sum(salary)as total,job_Title from Jobs group by job_Title having total > 60000;

select*from Candidates where first_name is not null;
select*from Candidates where first_name is null;

-- queries-- 

-- 1. find candidate who applied most for the jobs-- 
 
select a.candidate_id,a.first_name,a.last_name,count(b.application_id) as total from Candidates as a
inner join Applications as b
on a.candidate_id=b.candidate_id
group by a.candidate_id,a.first_name,a.last_name
order by total desc limit 1;


-- 2.find top 5 highest paying jobs-- 

select job_id,job_Title,salary from Jobs
order by salary desc limit 5;

-- 3.Find the company that posted mosted jobs-- 

select a.company_name,a.company_id,count(b.job_id) as total from Companies as a
inner join Jobs as b 
on a.company_id=b.company_id
group by a.company_name,a.company_id
order by total desc limit 1;

-- 4.find the company with the highest average salary--

select avg(b.salary) as total,a.company_name from Companies as a
inner join Jobs as b
on a.company_id=b.company_id
group by a.company_name
order by total desc limit 1;
   
-- 5.find candidates who received offers from multiple company--

select a.first_name,a.last_name,count(DISTINCT d.company_id) as total from Candidates as a
inner join Applications as b
on a.candidate_id=b.candidate_id
inner join Offers as c
on b.application_id=c.application_id
inner join Jobs as d
on b.job_id=d.job_id
group by a.first_name,a.last_name
having total>1;

-- 6. find  jobs that received offers from multiple companies--

select b.job_Title,count(c.company_id) as total from Applications as a
inner join Jobs as b 
on a.job_id=b.job_id 
inner join Companies as c
on b.company_id=c.company_id
inner join Offers as d
on a.application_id=d.application_id
group by b.job_Title
order by total desc;

-- 7.find the most popular skill among candidate--  

select a.skill_name,count(a.skill_id) as total from Skills as a
inner join Candidate_Skills as b
on a.skill_id=b.skill_id
inner join Candidates as c
on b.candidate_id=c.candidate_id
group by a.skill_name
order by total desc limit 1;

-- 8.find candidates who have both python and sql skills--

select a.candidate_id from Candidates as a
inner join Candidate_Skills as b
on a.candidate_id=b.candidate_id
inner join Skills as c
on b.skill_id=c.skill_id
where c.skill_name in ("Python","SQL")
group by a.candidate_id
having count(distinct skill_name)=2;

-- 9 find candidate with more than 3 years of experience--  

select a.first_name,b.years_of_experience from Candidates as a
inner join Experience as b
 on a.candidate_id=b.candidate_id
 where b.years_of_experience=3
 order by b.years_of_experience;
 
--  10.find companies that never received any reviews--

select company_name from Companies 
where company_id not in (select company_id from Reviews);

-- 11.find companies with a perfect 5 star rating--

select a.rating,b.company_name from Reviews as a
inner join  Companies as b
on a.company_id=b.company_id 
where a.rating=5
order by b.company_name;

-- 12.find candidate who never shortlisted--

select first_name,last_name from Candidates 
where candidate_id not in
(select candidate_id from Applications
where status="Shortlisted");

-- 13 .find candidate who are selected but not accepted any offers--
 
select a.first_name,b.status from Candidates as a
inner join Applications as b 
on a.candidate_id=b.candidate_id
where status="Shortlisted" and b.application_id not in
(select application_id from Offers
where status="Accepted");

 -- 14. find the job category with the most opening--

select a.category_name,count(b.job_id) as total
from Job_Categories as a
inner join Job_Category_Map as b
on a.category_id=b.category_id
group  by a.category_name
order by total desc limit 1;

-- 15. find jobs that never received any application--

select a.job_id,a.job_Title from Jobs as a
inner join Applications as b
on a.job_id=b.job_id
where b.status is null;

-- 16. find the fastest hired candidate--

select a.first_name,b.application_date,c.offer_date,datediff(c.offer_date,b.application_date) as hiring_days
from Candidates as a
inner join Applications as b
on a.candidate_id=b.candidate_id
inner join Offers as c
on b.application_id=c.application_id
order by hiring_days limit 1;

-- 17. find the slowest hiring process--

select  a.application_date,b.offer_date,datediff(b.offer_date,a.application_date)as slowest_hiring from Applications as a
inner join Offers as b
on a.application_id=b.application_id
order by slowest_hiring desc limit 1;

-- 18. find the interview success rate of each company--

select b.company_name ,
	   round(
		   (count(case when d.result='pass'
then 1	end)*100.0)
		   /count(d.interview_id),2
                )as success_rate
from Jobs as a
inner join Companies as b
on a.company_id=b.company_id
inner join Applications as c
on a.job_id=c.job_id
inner join Interviews as d
on c.application_id=d.application_id
group by b.company_name;

-- 19. find the offer acceptance rate of each company--

select a.company_name,d.status from Companies as a
inner join Jobs as b
on a.company_id=b.company_id
inner join Applications as c
on b.job_id=c.job_id
inner join Offers as d
on c.application_id=d.application_id
where d.status="Accepted"
group by a.company_name;

-- 20.find candidates whose experience is above the average experience

select a.first_name,a.last_name,b.years_of_experience from Candidates as a
inner join Experience as b
on a.candidate_id=b.candidate_id
where b.years_of_experience >
	  (select avg(years_of_experience) from Experience);
      
-- 21.find the second highest salary job--

select job_Title,salary from Jobs 
order by salary desc
limit 1 offset 1;

-- window function-- 
-- 22.rank all jobs by salary using window functions-- 

select job_id,job_title,salary,
rank() over(order by salary)
as salary_rank
from jobs;

 -- 23. find candidates who applied for jobs in more than 3 different location--
 
 select a.first_name,count(distinct d.location_id) as total from Candidates as a
 inner join Applications as b
 on a.candidate_id=b.candidate_id
 inner join Jobs as c
 on b.job_id=c.job_id
 inner join Job_Locations as d
 on c.job_id=d.job_id 
 inner join Locations as e
 on d.location_id=e.location_id
 group by a.first_name
 having count(distinct d.location_id)>3;
 
 
-- 24. find the recruiter whose company hired the most candidates--

select a.recruiter_name,count(b.company_id)as total from Recruiters as a
inner join Companies as b
on a.company_id=b.company_id
inner join Jobs as c
on b.company_id=c.company_id
inner join Applications as d
on c.job_id=d.job_id
inner join Offers as e
on d.application_id=e.application_id
where e.status="Accepted"
group by  a.recruiter_name
order by total desc limit 1;

 -- 25.How many skills does each candidate have?--
 
select c.first_name,count(b.skill_id) as total from Candidate_Skills as b
inner join  Candidates as c
on b.candidate_id=c.candidate_id
inner join Applications as d
on c.candidate_id=d.candidate_id
inner join Jobs as e
on d.job_id=e.job_id
group by c.first_name;

-- 26. find candidate who applied but never attented an interview--

select a.first_name,a.last_name from Candidates as a
inner join Applications as b
on a.candidate_id=b.candidate_id
left join Interviews as c
on b.application_id=c.application_id
where c.interview_id is null;

-- 27. find the month with highest number of job applications--

select monthname(application_date) as highest_month,count(application_id) as total from Applications as a 
group by highest_month
order by  total 
desc limit 1;

-- 28.find the candidate who got the maximum number of interview calls--

select a.first_name,count(c.interview_id) as total
 from Candidates as a
 inner join Applications as b
 on a.candidate_id=b.candidate_id
 inner join Interviews as c
 on b.application_id=c.application_id
 group by a.first_name
 order by total desc limit 1;
 
 -- 29. find companies that have never made an offer--
 
select a.company_name,d.status from Companies as a
inner join Jobs as b
on a.company_id=b.company_id
inner join Applications as c
on b.job_id=c.job_id
left join Offers as d
on c.application_id=d.application_id
where d.offer_id is null;

-- 30. find companies whose avg offered salary is above the overall average offered salary--

select a.company_name,avg(offered_salary) as avg_salry from Companies as a 
inner join Jobs as b
on a.company_id = b.company_id   
inner join Applications as c
on b.job_id=c.job_id
inner join Offers as d
on c.application_id=d.application_id
group by a.company_name
having avg(d.offered_salary)>
(
select avg(offered_salary) 
from Offers
);

-- views-- 
-- 1.candidate:details-- 

create view Candidates_Applications as 
select a.first_name,c.job_Title from Candidates as a 
inner join Applications as b
on a.candidate_id=b.candidate_id
inner join Jobs as c
on b.job_id=c.job_id;
 
select*from  Candidates_Applications;

-- 2.company_job--

create view company_jobs as
select company_name,job_description from Companies as a 
inner join Jobs as b
on a.company_id=b.company_id; 

select * from company_jobs; 

-- stored procedure-- 
-- 1. get candidate details--

delimiter &&
create procedure getcandetails(in cand_id int)
begin 
	select *from Candidates where candidate_id=cand_id;
end  &&
DELIMITER ;

CALL getcandetails(3);


-- 2.count Application for a job--
delimiter **
create procedure countapplicationid(in jobid int)
begin
	select *from Applications
    where job_id>jobid;
end **
delimiter ;


call countapplicationid(2);

-- Triggers--  
-- 1.create a trigger to maintain a log whenever a new candidate is added

select*from Candidates;
select*from Applications;

delimiter **
create trigger trg_candi_insert
after insert on Candidates
for each row
begin
	insert into Applications(candidate_id,job_id,application_date,status)
    values(new.candidate_id,"Selected");
end **
delimiter ;
 drop trigger trg_candi_insert;
insert into Applications(candidate_id,job_id)values(1,2);
