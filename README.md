# Job Portal Database (MySQL)

A relational database project modelling an online job portal: candidates, companies, recruiters, job postings, applications, interviews and offers. It includes the schema, sample data, and a set of SQL queries covering basic filters, aggregates, joins, subqueries, window functions, views, stored procedures and triggers.

## Project Files

| File | Description |
|------|-------------|
| `job_portal_tables.sql` | Creates the `project` database and all 20 tables |
| `job_portal_insert_values.sql` | Sample data for the tables |
| `jop_portal_queries.sql` | Practice and analysis queries, views, procedures, trigger |
| `job_portal_er_diagram.png` | Entity-Relationship diagram |

## ER Diagram

![ER Diagram](job_portal_er_diagram.png)

## Database Schema

The database is named `project` and contains 20 tables, grouped below by purpose.

**Users and candidates**
- `Users` - account details (name, email, phone, address)
- `Candidates` - personal details, linked to `Users`
- `Resumes` - resumes uploaded by candidates
- `Education` - degrees and colleges
- `Experience` - past employers, roles, years of experience
- `Skills` and `Candidate_Skills` - skill master list and candidate-to-skill mapping

**Companies and jobs**
- `Companies` - company profile
- `Recruiters` - recruiters working for a company
- `Jobs` - job postings with salary and posted date
- `Job_Categories` and `Job_Category_Map` - job categories (many-to-many with jobs)
- `Locations` and `Job_Locations` - locations (many-to-many with jobs)

**Hiring process**
- `Applications` - a candidate applying to a job
- `Application_Status` - status history of an application
- `Interviews` - interview date, mode and result
- `Offers` - offered salary, date and status

**Engagement**
- `Notifications` - messages sent to users
- `Reviews` - candidate ratings and reviews of companies

### Key Relationships

- One `User` has one or more `Candidates` and many `Notifications`
- One `Company` has many `Recruiters`, `Jobs` and `Reviews`
- One `Candidate` has many `Applications`, `Resumes`, `Education`, `Experience` and `Reviews`
- One `Application` has many `Interviews`, `Offers` and `Application_Status` rows
- `Jobs` to `Job_Categories`, `Jobs` to `Locations`, and `Candidates` to `Skills` are many-to-many, resolved through the mapping tables

## Setup

Requires MySQL 8.0 or later (window functions are used).

```bash
mysql -u root -p < job_portal_tables.sql
mysql -u root -p project < job_portal_insert_values.sql
mysql -u root -p project < jop_portal_queries.sql
```

Or run the files in order from MySQL Workbench. Note that the queries file ends with a `DROP TRIGGER` and a test insert, so run the last section deliberately rather than as part of a full-file run.

## What the Queries Cover

### Basic queries
`SELECT`, `WHERE`, `IN`, `AND` / `OR` / `NOT`, `LIMIT` / `OFFSET`, `LIKE`, `BETWEEN`, `ORDER BY`, `DISTINCT`, `IS NULL`.

### Aggregate functions
`COUNT`, `MIN`, `MAX`, `AVG`, `SUM`, with `GROUP BY` and `HAVING`.

### Analysis queries (30)

| # | Question answered |
|---|-------------------|
| 1 | Candidate who applied to the most jobs |
| 2 | Top 5 highest-paying jobs |
| 3 | Company that posted the most jobs |
| 4 | Company with the highest average salary |
| 5 | Candidates with offers from multiple companies |
| 6 | Jobs receiving offers, grouped by title |
| 7 | Most popular skill among candidates |
| 8 | Candidates with both Python and SQL skills |
| 9 | Candidates by years of experience |
| 10 | Companies that never received a review |
| 11 | Companies with a 5-star rating |
| 12 | Candidates who were never shortlisted |
| 13 | Shortlisted candidates who have not accepted an offer |
| 14 | Job category with the most openings |
| 15 | Jobs that received no applications |
| 16 | Fastest hire (application date to offer date) |
| 17 | Slowest hiring process |
| 18 | Interview success rate per company |
| 19 | Offer acceptance per company |
| 20 | Candidates with above-average experience |
| 21 | Second-highest-paying job |
| 22 | Rank jobs by salary (window function `RANK()`) |
| 23 | Candidates who applied across more than 3 locations |
| 24 | Recruiter whose company made the most accepted offers |
| 25 | Skill count per candidate |
| 26 | Candidates who applied but never attended an interview |
| 27 | Month with the most applications |
| 28 | Candidate with the most interviews |
| 29 | Companies that never made an offer |
| 30 | Companies whose average offer is above the overall average |

### Views
- `Candidates_Applications` - candidate first name with the job title applied for
- `company_jobs` - company name with job description

### Stored procedures
- `getcandetails(cand_id)` - returns details for one candidate
- `countapplicationid(jobid)` - returns applications for jobs

### Trigger
- `trg_candi_insert` - fires after an insert on `Candidates` to write a record into `Applications`

## Known Issues in the Query File

These are worth fixing before presenting or submitting the project.

- **Query 9**: the heading says "more than 3 years" but the condition is `years_of_experience = 3`. Use `> 3`.
- **Query 15**: joining `Applications` with `b.status IS NULL` will not find jobs with no applications. Use a `LEFT JOIN` and check `b.application_id IS NULL`, or `NOT IN` / `NOT EXISTS`.
- **Query 19**: only lists companies with accepted offers. For a true acceptance rate, divide accepted offers by total offers per company, as query 18 does for interviews.
- **Query 22**: `RANK() OVER (ORDER BY salary)` ranks lowest salary first. Add `DESC` for highest first.
- **Query 25**: joins through `Applications` and `Jobs`, which multiplies rows and inflates the skill count. The joins aren't needed; count from `Candidate_Skills` directly and group by `candidate_id`.
- **Procedure `countapplicationid`**: the name says count but it returns rows with `job_id > jobid`. Use `SELECT COUNT(*) ... WHERE job_id = jobid`.
- **Trigger `trg_candi_insert`**: the `INSERT INTO Applications(...)` lists four columns but supplies only two values, so it will fail. It also logs into `Applications` rather than a dedicated log table. A separate `Candidate_Log` table would match the stated purpose.
- **Grouping by `first_name`** (queries 5, 23, 25, 28) merges candidates who share a first name. Group by `candidate_id` as well.
- **Table name case**: `jobs` in query 22 will fail on case-sensitive systems (Linux). Use `Jobs`.

## Tech Stack

- MySQL 8.x
- MySQL Workbench (recommended client)

## Author

Sinegavalli.S
