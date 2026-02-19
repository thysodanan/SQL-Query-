create database School;


create table States(
	stateCode char(2) primary key not null,
	stateName varchar(12) not null
)


select * from States;


create table Students(
	stuId int primary key identity(1,1),
	stuFirstName nvarchar(20) not null,
	stuLastName nvarchar(20) not null,
	gender char(1) check(gender in('M','F')),
	dateBirth date not null,
	phone int not null,
	email varchar(18) not null unique,
	address nvarchar(100),
	enrollmentDate date default getdate(),
	stateCode char(2),
	constraint fk_stateCode foreign key(stateCode) references States(stateCode)
)

create table Teachers(
	tId int primary key identity(1,1),
	tName varchar(15) not null,
	tPhone int not null,
	tEmail varchar(15) not null,
	hireDate Date default getdate(),
)
select * from Teachers;

--rename table 
EXEC sp_rename 'Students', 'Pupils';

create table Shifts(
	shiftId int primary key identity(1,1),
	shiftSName varchar(10) not null,

)
select * from Shifts;

create table Classes(
	classId int primary key identity(1,1),
	className varchar(10) not null,
	tId int not null,
	shiftId int null,
	constraint fk_tId foreign key(tId) references Teachers(tId),
	constraint fk_shiftId foreign key(shiftId) references Shifts(shiftId)
)

create table Enrollments(
	enrollId int primary key identity(1,1),
	stuId int not null,
	classId int not null,
	state varchar(20) default 'Enrolled',
	constraint fk_class foreign key(classId) references Classes(classId)
)


INSERT INTO States(stateCode, stateName) VALUES
('KH', 'Kandal'),
('PP', 'Phnom Penh'),
('BT', 'Battambang'),
('SR', 'Siem Reap'),
('TK', 'Takeo'),
('PV', 'Prey Veng');

INSERT INTO Students(stuFirstName, stuLastName, gender, dateBirth, phone, email, address, stateCode) VALUES
(N'Sok', N'Chan', 'M', '2005-06-15', 123456789, 'sokchan1@email.com', N'Phnom Penh', 'KH'),
(N'Srey', N'Pov', 'F', '2006-02-21', 234567891, 'sreypov2@email.com', N'Siem Reap', 'SR'),
(N'Vannak', N'Sean', 'M', '2005-12-10', 345678912, 'vannak3@email.com', N'Battambang', 'BT'),
(N'Phirum', N'Sophat', 'M', '2004-11-17', 456789123, 'phirum4@email.com', N'Takeo', 'TK'),
(N'Sophea', N'Ly', 'F', '2006-07-25', 567891234, 'sophea5@email.com', N'Phnom Penh', 'PP'),
(N'Rith', N'Kim', 'M', '2005-04-05', 678912345, 'rith6@email.com', N'Prey Veng', 'PV');


INSERT INTO Teachers (tName, tPhone, tEmail) VALUES
('Mr. Dara', 111111111, 'dara@email.com'),
('Mrs. Sreyneang', 222222222, 'neang@email.com'),
('Mr. Vuthy', 333333333, 'vuthy@email.com'),
('Ms. Mary', 444444444, 'mary@email.com'),
('Mr. Samnang', 555555555, 'nang@email.com'),
('Mrs. Lina', 666666666, 'lina@email.com');


INSERT INTO Shifts (shiftSName) VALUES
('Morning'),
('Afternoon'),
('Evening'),
('Weekend'),
('Holiday'),
('Special');

truncate table Shifts;
delete from Shifts where shiftId in(4,5,6)


INSERT INTO Classes (className, tId, shiftId) VALUES
('Math', 8, 1),
('Khmer', 10, 2),
('English', 11, 3),
('IT', 12, 1),
('Science', 13, 2),
('Sport', 9, 3);



INSERT INTO Enrollments (stuId, classId) VALUES
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10),
(6, 11);


SELECT * FROM States;
SELECT * FROM Teachers;
SELECT * FROM Shifts;
SELECT * FROM Classes;
SELECT * FROM Enrollments;
