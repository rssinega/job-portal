create database project;
use project;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(200)
);

CREATE TABLE Candidates (
    candidate_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100),
    industry VARCHAR(100),
    website VARCHAR(200),
    location VARCHAR(100)
);

CREATE TABLE Recruiters (
    recruiter_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT,
    recruiter_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

CREATE TABLE Jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT,
    job_title VARCHAR(100),
    job_description TEXT,
    salary DECIMAL(10,2),
    posted_date DATE,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

CREATE TABLE Applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT,
    job_id INT,
    application_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);

CREATE TABLE Skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100)
);

CREATE TABLE Candidate_Skills (
    candidate_skill_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT,
    skill_id INT,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id)
);

CREATE TABLE Resumes (
    resume_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT,
    resume_title VARCHAR(100),
    upload_date DATE,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id)
);


CREATE TABLE Education (
    education_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT,
    degree VARCHAR(100),
    college_name VARCHAR(100),
    graduation_year INT,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id)
);

CREATE TABLE Experience (
    experience_id INT PRIMARY KEY AUTO_INCREMENT,
    candidate_id INT,
    company_name VARCHAR(100),
    job_role VARCHAR(100),
    years_of_experience INT,
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id)
);


CREATE TABLE Job_Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);


CREATE TABLE Job_Category_Map (
    map_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT,
    category_id INT,
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
    FOREIGN KEY (category_id) REFERENCES Job_Categories(category_id)
);

CREATE TABLE Locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE Job_Locations (
    job_location_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT,
    location_id INT,
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

CREATE TABLE Interviews (
    interview_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT,
    interview_date DATE,
    interview_mode VARCHAR(50),
    result VARCHAR(50),
    FOREIGN KEY (application_id) REFERENCES Applications(application_id)
);

CREATE TABLE Offers (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT,
    offered_salary DECIMAL(10,2),
    offer_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (application_id) REFERENCES Applications(application_id)
);

CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message VARCHAR(255),
    notification_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT,
    candidate_id INT,
    rating INT,
    review_text TEXT,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id)
);

CREATE TABLE Application_Status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT,
    status_name VARCHAR(50),
    updated_date DATE,
    FOREIGN KEY (application_id) REFERENCES Applications(application_id)
);





    

 
 
 
 

 
 


  













