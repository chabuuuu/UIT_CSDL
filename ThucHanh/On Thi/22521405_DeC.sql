﻿USE MASTER
IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'BAITHI')
BEGIN
	ALTER DATABASE BAITHI SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE BAITHI;
END
GO

CREATE DATABASE BAITHI

SET DATEFORMAT DMY
-- Câu 1:
CREATE TABLE KHACHHANG 
(MAKH VARCHAR (10) PRIMARY KEY, 
HTKH NVARCHAR(30), 
CMND VARCHAR(20), 
SDT VARCHAR(20), 
LOAIKH VARCHAR(15), 
GIAMGIA INT)

CREATE TABLE DICHVU (
MADV VARCHAR (10) PRIMARY KEY, 
TENDV NVARCHAR(30),
GIA MONEY
)

CREATE TABLE HOPDONG (
SOHD VARCHAR(10) PRIMARY KEY, 
MAKH VARCHAR(10) FOREIGN KEY REFERENCES KHACHHANG(MAKH), 
TENTC NVARCHAR(20), 
NGLAP SMALLDATETIME, 
NGKT SMALLDATETIME
)

CREATE TABLE  CTHD (
SOHD VARCHAR(10), 
MADV VARCHAR(10), 
NGSD SMALLDATETIME,
CONSTRAINT PK_CTHD PRIMARY KEY (SOHD, MADV),
CONSTRAINT FK_SOHD_CTHD FOREIGN KEY (SOHD) REFERENCES HOPDONG(SOHD),
CONSTRAINT FK_MADV_CTHD FOREIGN KEY (MADV) REFERENCES DICHVU(MADV)
)


-- Câu 2:
SET DATEFORMAT DMY
INSERT INTO KHACHHANG VALUES('KH001','Bui Hoang Nhat Phuong', '357753735', '761231234', 'VIP', 10)
INSERT INTO KHACHHANG VALUES('KH002','Bui Van Tri', '246264426', '523453456', 'Than thiet', 5)
INSERT INTO KHACHHANG VALUES('KH003','Le Duy Thanh Cong', '197917791', '354321508', 'Thuong', 0)


INSERT INTO DICHVU VALUES('DV01','Tam rua', 100000)
INSERT INTO DICHVU VALUES('DV02','Nghe nhac', 45000)
INSERT INTO DICHVU VALUES('DV03','Mat xa thu gian', 150000)

INSERT INTO HOPDONG VALUES('1','KH001', 'Boss', '09/11/2018', '16/11/2018')
INSERT INTO HOPDONG VALUES('2','KH002', 'Den', '22/12/2018', '25/12/2018')
INSERT INTO HOPDONG VALUES('3','KH001', 'Map', '14/12/2018', '28/12/2018')

INSERT INTO CTHD VALUES('1','DV01', '10/11/2018')
INSERT INTO CTHD VALUES('2','DV02', '23/12/2018')
INSERT INTO CTHD VALUES('1','DV03', '28/12/2018')

-- Câu 3:
ALTER TABLE KHACHHANG ADD CONSTRAINT CK_LOAIKH
Check ((LOAIKH = 'Vip' AND GIAMGIA = 10)
			OR (LOAIKH != 'Vip')
)


-- Câu 4:
--Bang rang buoc:
-------------------------------------
--|         THEM   |  XOA  |  SUA     |
--|HOPDONG|   -    |  -(*) | + (NGKT) |
--|CTHD   |   +    |   -   | +(NGSD)  |

GO
CREATE TRIGGER TG_SUA_HOPDONG
ON HOPDONG
FOR UPDATE
AS
BEGIN
	DECLARE @SOHD VARCHAR(10), @NGKT SMALLDATETIME
	SELECT @SOHD = SOHD, @NGKT = NGKT FROM inserted
	IF (EXISTS (
		SELECT * FROM CTHD 
		WHERE SOHD = @SOHD AND NGSD > @NGKT
	) 
	)
	BEGIN
			PRINT N':  Ngày sử dụng phải là ngày trước hoặc trùng với ngày kết thúc hợp đồng'
			ROLLBACK TRAN
		END
	ELSE
	PRINT N'Cập nhật thành công'
END

GO

CREATE TRIGGER TG_CTHD_INSERT
ON CTHD
FOR INSERT
AS
BEGIN
	DECLARE @SOHD VARCHAR(10), @NGSD SMALLDATETIME, @NGKT SMALLDATETIME
	SELECT @SOHD = SOHD, @NGSD = NGSD FROM inserted
	SELECT @NGKT = NGKT FROM HOPDONG WHERE @SOHD = SOHD
	IF (@NGSD >= @NGKT)
	PRINT N'Thêm thành công'
	ELSE
		BEGIN
			PRINT N'Ngày sử dụng phải là ngày trước hoặc trùng với ngày kết thúc hợp đồng'
			ROLLBACK TRAN
		END
END
go

CREATE TRIGGER TG_CTHD_UPDATE
ON CTHD
FOR UPDATE
AS
BEGIN
	DECLARE @SOHD VARCHAR(10), @NGSD SMALLDATETIME, @NGKT SMALLDATETIME
	SELECT @SOHD = SOHD, @NGSD = NGSD FROM inserted
	SELECT @NGKT = NGKT FROM HOPDONG WHERE @SOHD = SOHD
	IF (@NGSD >= @NGKT)
	PRINT N'Cập nhật thành công'
	ELSE
		BEGIN
			PRINT N'Ngày sử dụng phải là ngày trước hoặc trùng với ngày kết thúc hợp đồng'
			ROLLBACK TRAN
		END
END
go

--Câu 5:
SELECT SOHD
FROM HOPDONG H
WHERE MONTH(NGLAP) = 12 AND YEAR(NGLAP) = 2018
ORDER BY NGKT DESC

-- Câu 6:
SELECT TOP 1 WITH TIES TENDV, GIA
FROM DICHVU DV, CTHD CT
WHERE DV.MADV = CT.MADV AND YEAR(NGSD) = 2018
GROUP BY DV.MADV, TENDV, GIA
ORDER BY COUNT(DV.MADV) ASC


--Câu 7:
SELECT DV1.MADV, TENDV FROM KHACHHANG KH1, HOPDONG HD1, DICHVU DV1, CTHD CT1
WHERE 
KH1.MAKH = HD1.MAKH 
AND CT1.SOHD = HD1.SOHD 
AND DV1.MADV = CT1.MADV
EXCEPT
SELECT DV2.MADV, TENDV FROM KHACHHANG KH2, HOPDONG HD2, DICHVU DV2, CTHD CT2
WHERE (LOAIKH = 'Thuong' 
OR LOAIKH = 'Than thiet')
AND KH2.MAKH = HD2.MAKH 
AND CT2.SOHD = HD2.SOHD 
AND DV2.MADV = CT2.MADV

--Câu 8:
SELECT KH.MAKH, HTKH FROM KHACHHANG KH
WHERE NOT EXISTS (
	SELECT * FROM DICHVU DV WHERE GIA > 100000
	AND NOT EXISTS (
		SELECT * FROM HOPDONG HD, CTHD CT
		WHERE HD.SOHD = CT.SOHD AND 
		HD.MAKH = KH.MAKH
		AND DV.MADV = CT.MADV
		AND YEAR(NGSD)=2018
	)
)