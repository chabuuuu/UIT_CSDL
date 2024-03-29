USE QLBH
IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'QLBH')
BEGIN
	ALTER DATABASE QLGV SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    USE MASTER;
	DROP DATABASE QLGV;
END
GO
CREATE DATABASE QLGV

--1.Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
CREATE TABLE KHOA(
    MAKHOA  varchar(4) primary key,
    TENKHOA	varchar(40),
    NGTLAP	smalldatetime,
    TRGKHOA	char(4),
)

CREATE TABLE GIAOVIEN(
    MAGV char(4) PRIMARY KEY,
    HOTEN   varchar(40),
    HOCVI VARCHAR(10),
    HOCHAM	varchar(10),
    GIOITINH	varchar(3),
    NGSINH smalldatetime, 
    NGVL	smalldatetime,
    HESO	numeric(4,2),
    MUCLUONG    money,
    MAKHOA	varchar(4),
    CONSTRAINT FK_GIAOVIEN FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
)

--Them rang buoc khoa ngoai cho cot TRGKHOA trong KHOA
ALTER TABLE KHOA ADD CONSTRAINT FK_KHOA_TRGKHOA FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV);

CREATE TABLE MONHOC(
    MAMH    varchar(10) PRIMARY KEY,
    TENMH	varchar(40),
    TCLT	tinyint,
    TCTH	tinyint,
    MAKHOA	varchar(4),
    CONSTRAINT FK_MONHOC FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
)

CREATE TABLE DIEUKIEN(
    MAMH    varchar(10),
    MAMH_TRUOC	varchar(10),
    CONSTRAINT PK_DIEUKIEN_MAMH PRIMARY KEY (MAMH, MAMH_TRUOC),
    CONSTRAINT FK_DIEUKIEN_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
    CONSTRAINT FK_DIEUKIEN_MAMH_TRUOC FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)
)

CREATE TABLE LOP(
    MALOP   char(3) PRIMARY KEY,
    TENLOP  varchar(40),
    TRGLOP  char(5),
    SISO    tinyint,
    MAGVCN  char(4),
    CONSTRAINT FK_LOP_MAGVCN FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)
)

CREATE TABLE HOCVIEN(
    MAHV    char(5) PRIMARY KEY,
    HO  varchar(40),
    TEN varchar(10),
    NGSINH  smalldatetime,
    GIOITINH    varchar(3),
    NOISINH varchar(40),
    MALOP   char(3),
    CONSTRAINT FK_HOCVIEN_MALOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
)

ALTER TABLE LOP ADD CONSTRAINT FK_LOP_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV);

CREATE TABLE GIANGDAY(
    MALOP   char(3),
    MAMH	varchar(10),
    MAGV	char(4),
    HOCKY	tinyint,
    NAM smallint,
    TUNGAY  smalldatetime, 
    DENNGAY	smalldatetime,
    CONSTRAINT PK_GIANGDAY PRIMARY KEY (MALOP, MAMH),
    CONSTRAINT FK_GIANGDAY_MAGV FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV),
    CONSTRAINT FK_GIANGDAY_MALOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
    CONSTRAINT FK_GIANGDAY_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
)

CREATE TABLE KETQUATHI(
    MAHV	char(5),
    MAMH	varchar(10),
    LANTHI	tinyint,
    NGTHI	smalldatetime,
    DIEM	numeric(4,2),
    KQUA	varchar(10),
    CONSTRAINT PK_KETQUATHI PRIMARY KEY (MAHV,MAMH,LANTHI),
    CONSTRAINT FK_KETQUATHI_MAHV FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
    CONSTRAINT FK_KETQUATHI_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
)

--Add GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN
ALTER TABLE HOCVIEN ADD GHICHU TEXT;
ALTER TABLE HOCVIEN ADD DIEMTB NUMERIC(3,2);
ALTER TABLE HOCVIEN ADD XEPLOAI VARCHAR(10);

-- 2.Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”
 
GO
 CREATE FUNCTION CheckValidMalopInMAHV (@MAHV char(5)) 
 RETURNs TINYINT
 AS 
 BEGIN
    IF LEFT(@MAHV, 3) IN (SELECT MALOP FROM LOP)
        RETURN 1
    RETURN 0
END

GO
CREATE FUNCTION CheckValidSttInMAHV (@MAHV char(5), @MALOP_HV CHAR(3))
 RETURNs TINYINT
 AS 
 BEGIN
    IF RIGHT(@MAHV, 2) BETWEEN 1 AND  (SELECT SISO FROM LOP WHERE MALOP = @MALOP_HV)
        RETURN 1
    RETURN 0
END
GO

ALTER TABLE HOCVIEN ADD CONSTRAINT CK_MAHV CHECK (
    LEN(MAHV) = 5 AND dbo.CheckValidMalopInMAHV(MAHV) = 1 AND dbo.CheckValidSttInMAHV(MAHV, MALOP) = 1
)

GO

--3.Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CK_GIOITINH_GIAOVIEN CHECK (
    GIOITINH = 'Nam' OR GIOITINH = 'Nu'
)

ALTER TABLE HOCVIEN ADD CONSTRAINT CK_GIOITINH_HOCVIEN CHECK(
    GIOITINH = 'Nam' OR GIOITINH = 'Nu'
)

GO
--4.Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI ADD CONSTRAINT CK_DIEMSO CHECK(
    (DIEM BETWEEN 0 AND 10) 
    AND LEN(SUBSTRING(CAST(DIEM AS VARCHAR), CHARINDEX('.', DIEM) + 1, 1000)) >= 2
)
--5.Kết quả thi là “Dat” nếu điểm từ 5 đến 10  và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI ADD CONSTRAINT CK_KETQUA CHECK(
    KQUA = IIF(DIEM BETWEEN 5 AND 10, 'Dat', 'Khong dat')
)
--6.Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI ADD CONSTRAINT CK_LANTHI CHECK(
    LANTHI <= 3
)
--7.Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY ADD CONSTRAINT CK_HOCKY CHECK (
    HOCKY BETWEEN 1 AND 3
)
--8.Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CK_HOCVI CHECK(
    HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS')
)