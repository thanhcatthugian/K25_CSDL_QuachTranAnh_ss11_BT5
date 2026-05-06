drop database if exists ss11b5;
create database ss11b5;
use ss11b5;

create table patients(
patient_id varchar(5) primary key,
full_name varchar(50) not null,
status varchar(50) not null
);
create table depts(
dept_id varchar(5) primary key,
dept_name varchar(50) not null
);
create table beds(
bed_id varchar(5) primary key,
room_number int not null,
dept_id varchar(5),
foreign key(dept_id) references depts(dept_id),
patient_id varchar(5),
foreign key(patient_id) references patients(patient_id)
);

INSERT INTO patients (patient_id, full_name,status) VALUES
('P0001', 'Nguyen Van An','Completed'),
('P0002', 'Tran Thi Bich','Incompleted'),
('P0003', 'Le Hoang Cuong','Incompleted'),
('P0004', 'Pham Minh Duc','Completed'),
('P0005', 'Hoang Lan Anh','Incompleted'),
('P0006', 'Vu Hoang Long','Completed'),
('P0007', 'Dang Van Hung','Incompleted'),
('P0008', 'Bui Thi Hanh','Completed'),
('P0009', 'Do Minh Tuan','Completed'),
('P0010', 'Ngo Thanh Tung','Incompleted'),
('P0011', 'Ly Gia Han','Incompleted'),
('P0012', 'Truong Vinh Ky','Incompleted'),
('P0013', 'Vo Thi Sau','Completed'),
('P0014', 'Nguyen Trai','Incompleted'),
('P0015', 'Tran Hung Dao','Completed');

INSERT INTO depts (dept_id, dept_name) VALUES
('D01', 'Khoa Noi'),
('D02', 'Khoa Ngoai'),
('D03', 'Khoa Nhi'),
('D04', 'Khoa San'),
('D05', 'Khoa Hoi Suc Cap Cuu (ICU)'),
('D06', 'Khoa Mat'),
('D07', 'Khoa Tai Mui Hong'),
('D08', 'Khoa Rang Ham Mat'),
('D09', 'Khoa Tim Mach'),
('D10', 'Khoa Da Lieu'),
('D11', 'Khoa Than Kinh'),
('D12', 'Khoa Xuong Khop'),
('D13', 'Khoa Truyen Nhiem'),
('D14', 'Khoa Ung Buou'),
('D15', 'Khoa Phuc Hoi Chuc Nang');

INSERT INTO beds (bed_id, room_number, dept_id, patient_id) VALUES
('B001', 101, 'D01', 'P0001'),
('B002', 101, 'D01', 'P0002'),
('B003', 102, 'D01', NULL),  
('B004', 201, 'D02', 'P0003'),
('B005', 201, 'D02', 'P0004'),
('B006', 202, 'D02', NULL),   
('B007', 301, 'D03', 'P0005'),
('B008', 301, 'D03', NULL),   
('B009', 401, 'D04', 'P0006'),
('B010', 501, 'D05', 'P0007'),
('B011', 502, 'D05', 'P0008'),
('B012', 601, 'D06', NULL),    
('B013', 701, 'D07', 'P0009'),
('B014', 801, 'D08', 'P0010'),
('B015', 901, 'D09', NULL);    

delimiter //
create procedure find_bed(
	in p_pid varchar(5),
	in p_did varchar(5),
	out p_ann varchar(100)
)
begin
    declare d_status varchar(50);
    
    select status into d_status
    from patients
    where p_pid = patient_id;
    
    if 
    d_status = 'Completed' then
    set p_ann = 'Bệnh nhân đã xuất viện';
    
    elseif exists(
    select * from beds 
    where patient_id = p_pid and dept_id = p_did
    ) then
        select bed_id, room_number 
        from beds 
        where patient_id = p_pid and dept_id = p_did;
        set p_ann = 'Hết giường';

    elseif exists(
    select * from beds 
    where dept_id = p_did and patient_id is null
    ) then
        select bed_id, room_number 
        from beds 
        where dept_id = p_did and patient_id is null;
        set p_ann = 'Còn giường trống';

    else
        set p_ann = 'Thông tin bệnh nhân hoặc khoa sai';
    end if;
end
// delimiter ;
set @ann = '';
call find_bed('P0001','D01',@ann);
select @ann;
call find_bed('P0002','D01',@ann);
select @ann;
call find_bed('P0014','D01',@ann);
select @ann;