﻿USE MASTER
IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'BAITHI')
BEGIN
	ALTER DATABASE BAITHI SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE BAITHI;
END
GO

CREATE DATABASE BAITHI
SET DATEFORMAT DMY

CREATE TABLE KHACHHANG (MAKH VARCHAR(5) PRIMARY KEY, TENKH VARCHAR(30), DIACHI VARCHAR(20), LOAIKH VARCHAR(20))CREATE TABLE  LOAICAY (MALC VARCHAR(5) PRIMARY KEY, TENLC VARCHAR(30), XUATXU VARCHAR(20), GIA MONEY)CREATE TABLE HOADON (SOHD VARCHAR(5) PRIMARY KEY, NGHD SMALLDATETIME, MAKH VARCHAR(5) FOREIGN KEY REFERENCES KHACHHANG(MAKH), KHUYENMAI SMALLINT)CREATE TABLE CTHD (SOHD VARCHAR(5), MALC VARCHAR(5), SOLUONG SMALLINT,CONSTRAINT PK_CTHD PRIMARY KEY(SOHD, MALC),CONSTRAINT FK_SOHD_CTHD FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD),CONSTRAINT FK_MALC_CTHD FOREIGN KEY (MALC) REFERENCES LOAICAY(MALC),)--Câu 2:SET DATEFORMAT DMYINSERT INTO KHACHHANG VALUES('KH01','Liz Kim Cuong', 'Ha Noi', 'Vang lai')
INSERT INTO KHACHHANG VALUES('KH02','Ivone Dieu Linh', 'Da Nang', 'Thuong xuyen')
INSERT INTO KHACHHANG VALUES('KH03','Emma Nhat Khanh', 'TP.HCM', 'Vang lai')

INSERT INTO LOAICAY VALUES('LC01','Xuong rong tai tho', 'Mexico', 180000)
INSERT INTO LOAICAY VALUES('LC02','Sen thach ngoc', 'Anh', 300000)
INSERT INTO LOAICAY VALUES('LC03','Ba mau rau', 'Nam Phi', 270000)

INSERT INTO HOADON VALUES('00001','22/11/2017', 'KH01', 5)
INSERT INTO HOADON VALUES('00002','04/12/2017', 'KH03', 5)
INSERT INTO HOADON VALUES('00003','10/12/2017', 'KH02', 10)


INSERT INTO CTHD VALUES('00001','LC01', 1)
INSERT INTO CTHD VALUES('00001','LC02', 2)
INSERT INTO CTHD VALUES('00003','LC03', 5)


--Câu 3:
ALTER TABLE LOAICAY ADD CONSTRAINT CK_XUATXU_GIA
CHECK (
	XUATXU = 'Anh' AND GIA > 250000
	OR XUATXU != 'Anh'
)

--Câu 4:
-------------------------------------
--|         THEM   |  XOA  |  SUA     |
--|HOADON|   -    |  -(*) | + (KHUYENMAI) |
--|CTHD   |   +    |   -   | +(SOHD)  |

GO
CREATE TRIGGER TRG_SUA_HOADON ON HOADON
FOR UPDATE
AS BEGIN 
	DECLARE @SOHD VARCHAR(5), @KHUYENMAI SMALLINT
	SELECT @SOHD = SOHD, @KHUYENMAI = KHUYENMAI FROM inserted
	IF (5 <= 
	(SELECT SUM(SOLUONG) 
	 FROM CTHD
	 WHERE SOHD = @SOHD
	 GROUP BY SOHD
	) 
	)
	BEGIN
	IF (@KHUYENMAI = 10)
	BEGIN
		PRINT N'Sửa thành công'
	END
	ELSE
		BEGIN
			PRINT N': Hóa đơn mua với số lượng tổng cộng lớn hơn hoặc bằng 5 đều được giảm giá 10 phần trăm'
			ROLLBACK TRAN
		END
	END
END

GO
CREATE TRIGGER TRG_THEM_CTHD ON CTHD
FOR INSERT, UPDATE
AS BEGIN 
	DECLARE @SOHD VARCHAR(5), @SOLUONG SMALLINT, @KHUYENMAI SMALLINT
	SELECT @SOHD = SOHD, @SOLUONG = SOLUONG FROM inserted
	SELECT @KHUYENMAI = KHUYENMAI FROM HOADON WHERE SOHD = @SOHD
	IF (
		(@SOLUONG + (SELECT SUM(SOLUONG) FROM CTHD WHERE SOHD = @SOHD GROUP BY SOHD)) >= 5
	)
	BEGIN
			IF (@KHUYENMAI = 10)
				BEGIN
				PRINT N'Thành công'
				END
			ELSE 
				BEGIN
					PRINT N': Hóa đơn mua với số lượng tổng cộng lớn hơn hoặc bằng 5 đều được giảm giá 10 phần trăm'
					ROLLBACK TRAN					
				END
	END
END


--Câu 5:
SELECT SOHD FROM HOADON 
WHERE MONTH(NGHD) >= 10 AND MONTH(NGHD) <= 12
AND YEAR(NGHD) = 2017
ORDER BY KHUYENMAI ASC

--Câu 6:
SELECT TOP 1 WITH TIES MALC
FROM CTHD CT, HOADON HD
WHERE CT.SOHD = HD.SOHD
AND MONTH(NGHD) = 12
GROUP BY MALC
ORDER BY SUM(SOLUONG) ASC

--Câu 7:
SELECT CT.MALC FROM CTHD CT, HOADON HD, KHACHHANG KH
WHERE CT.SOHD = HD.SOHD
AND HD.MAKH = KH.MAKH
AND LOAIKH = 'Thuong xuyen' 
INTERSECT
SELECT CT2.MALC FROM CTHD CT2, HOADON HD2, KHACHHANG KH2
WHERE CT2.SOHD = HD2.SOHD
AND HD2.MAKH = KH2.MAKH
AND LOAIKH = 'Vang lai'

--Câu 8:

SELECT MAKH, TENKH FROM KHACHHANG KH
WHERE NOT EXISTS (
	SELECT * FROM LOAICAY LC
	WHERE NOT EXISTS (
		SELECT * FROM HOADON HD, CTHD CT
		WHERE HD.SOHD = CT.SOHD
		AND HD.MAKH = KH.MAKH
		AND CT.MALC = LC.MALC
	)
)

