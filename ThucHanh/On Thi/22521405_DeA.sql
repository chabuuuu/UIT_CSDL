﻿DROP DATABASE BAITHI
-- Cau 1:
CREATE DATABASE BAITHI
SET DATEFORMAT DMY
CREATE TABLE KHACHTHUE 
(MAKT VARCHAR(10) PRIMARY KEY, 
TENKT NVARCHAR(20), 
NGSINH SMALLDATETIME, 
CMND VARCHAR(40) , 
DIACHI NVARCHAR(50)
)
CREATE TABLE XEMAY (
	MAXE VARCHAR(10) PRIMARY KEY, 
	TENXE NVARCHAR(20), 
	DUNGTICH INT, 
	GIA MONEY, 
	TINHTRANG VARCHAR(10)
)

CREATE TABLE E_BILL (
	SOHD VARCHAR(10) PRIMARY KEY, 
	NGTHUE SMALLDATETIME, 
	NGTRA SMALLDATETIME , 
	MAKT VARCHAR(10),
	CONSTRAINT FK_MAKT_E_BILL FOREIGN KEY (MAKT) 
REFERENCES KHACHTHUE(MAKT),
)
CREATE TABLE CTTHUE(
SOHD VARCHAR(10), 
MAXE VARCHAR(10), 
SL INT,
CONSTRAINT PK_CTTHUE PRIMARY KEY(SOHD, MAXE),
CONSTRAINT FK_SOHD_CTTHUE FOREIGN KEY (SOHD) 
REFERENCES E_BILL(SOHD),
CONSTRAINT FK_MAXE_CTTHUE FOREIGN KEY (MAXE) 
REFERENCES XEMAY(MAXE),
)

-- Cau 2:
SET DATEFORMAT DMY
INSERT INTO KHACHTHUE VALUES('KT0083', 'Le Thi Phuong Khanh', '09/02/1999', '273656107' , 'BRVT')
INSERT INTO KHACHTHUE VALUES('KT0329', 'Nguyen Vinh Hai', '03/01/1999' , '221421550', 'Phu Yen')
INSERT INTO KHACHTHUE VALUES('KT0137', 'Le Hoang Long', '07/07/1999' ,'184361699' , 'Ha Tinh')

INSERT INTO XEMAY VALUES('X1942' ,'Yamaha Exciter',150, 80000, 'Con')
INSERT INTO XEMAY VALUES('X2719' ,'Honda SH 150' ,153, 100000, 'Gan het')
INSERT INTO XEMAY VALUES('X2739' , 'Suzuki Raider' ,147 ,70000,'Het')

INSERT INTO E_BILL VALUES('1', '01/11/2018', '10/11/2018 ', 'KT0329')
INSERT INTO E_BILL VALUES('2', '07/12/2018', '10/12/2018 ', 'KT0329')
INSERT INTO E_BILL VALUES('3', '18/12/2018', '25/12/2018', 'KT0137')

INSERT INTO CTTHUE VALUES('1', 'X2739', 2)
INSERT INTO CTTHUE VALUES('1', 'X2719', 1)
INSERT INTO CTTHUE VALUES('2', 'X2739', 5)


-- Câu 3:
ALTER TABLE XEMAY ADD CONSTRAINT 
	CK_TINHTRANG_XEMAY CHECK (
		TINHTRANG IN ('Con', 'Gan het', 'Het')
	)

-- Câu 4:
-------------------------------
--           | THEM    | XOA  | SUA
--KHACHTHUE  |  -      | -(*) |+(NGSINH)
--E_BILL     | +       | -    |+(NGTHUE)
--

-- Trigger Sua Khachthue

GO
CREATE TRIGGER TRG_SUA_KHACHTHUE ON KHACHTHUE
FOR UPDATE 
AS BEGIN
	DECLARE @MAKT VARCHAR(10), @NGSINH SMALLDATETIME
	SELECT @MAKT = MAKT, @NGSINH = NGSINH FROM inserted
	IF (EXISTS (
		SELECT * FROM E_BILL WHERE MAKT = @MAKT AND NGTHUE <= @NGSINH
		)  
	)
		BEGIN 
			PRINT N'Ngày thuê phải lớn hơn ngày sinh'
			ROLLBACK TRAN
		END
	ELSE 
		PRINT N'Sửa thành công'
END


-- Trigger them E_BILL
GO
CREATE TRIGGER TRG_THEM_E_BILL ON E_BILL
FOR INSERT 
AS BEGIN
	DECLARE @MAKT VARCHAR(10), @NGSINH SMALLDATETIME, 
	@NGTHUE SMALLDATETIME
	SELECT @MAKT = MAKT, @NGTHUE = NGTHUE FROM inserted
	SELECT @NGSINH = NGSINH FROM KHACHTHUE WHERE @MAKT = MAKT
	IF (
		@NGTHUE <= @NGSINH 
	)
		BEGIN 
			PRINT N'Ngày thuê phải lớn hơn ngày sinh'
			ROLLBACK TRAN
		END
	ELSE 
		PRINT N'Thêm thành công'
END

--Trigger sua e_bill:
GO
CREATE TRIGGER TRG_SUA_E_BILL ON E_BILL
FOR UPDATE
AS BEGIN
	DECLARE @MAKT VARCHAR(10), @NGSINH SMALLDATETIME, 
	@NGTHUE SMALLDATETIME
	SELECT @MAKT = MAKT, @NGTHUE = NGTHUE FROM inserted
	SELECT @NGSINH = NGSINH FROM KHACHTHUE WHERE @MAKT = MAKT
	IF (
		@NGTHUE <= @NGSINH 
	)
		BEGIN 
			PRINT N'Ngày thuê phải lớn hơn ngày sinh'
			ROLLBACK TRAN
		END
	ELSE 
		PRINT N'Sửa thành công'
END

-- Câu 5:
SELECT XM.MAXE, TENXE
FROM XEMAY XM, E_BILL E, CTTHUE CT
WHERE XM.MAXE = CT.MAXE AND CT.SOHD = E.SOHD
AND MONTH(NGTHUE) = 12 AND YEAR(NGTHUE) = 2018
ORDER BY DUNGTICH ASC

-- Câu 6:
SELECT TOP 1 WITH TIES  XM.MAXE, TENXE
FROM XEMAY XM, CTTHUE CT, E_BILL E
WHERE XM.MAXE = CT.MAXE AND E.SOHD = CT.SOHD AND YEAR(NGTHUE)=2018
GROUP BY XM.MAXE, TENXE
ORDER BY SUM(SL) DESC
-- 

-- Câu 7:
-- KHACHTHUE - KHACHTHUE XE DUNG TICH TUOI 100CC
SELECT KT.MAKT, TENKT 
FROM KHACHTHUE KT, XEMAY X, E_BILL E, CTTHUE C
WHERE KT.MAKT = E.MAKT AND E.SOHD = C.SOHD AND X.MAXE = C.MAXE 
AND DUNGTICH >= 100 --Cần phải có bước này để loại ra những khách không thuê xe nào
EXCEPT 
SELECT KT_2.MAKT, TENKT
FROM KHACHTHUE KT_2, E_BILL E, CTTHUE CT, XEMAY XM
WHERE KT_2.MAKT = E.MAKT 
AND E.SOHD = CT.SOHD 
AND CT.MAXE = XM.MAXE
AND DUNGTICH < 100

-- Câu 8:
SELECT MAKT, TENKT FROM KHACHTHUE KT
WHERE YEAR(NGSINH) = 1999 AND NOT EXISTS (
	SELECT * FROM XEMAY XM
	WHERE DUNGTICH >= 150 AND NOT EXISTS (
		SELECT * FROM E_BILL E, CTTHUE CT
		WHERE E.MAKT = KT.MAKT AND E.SOHD = CT.SOHD AND
			XM.MAXE = CT.MAXE
	)
)
