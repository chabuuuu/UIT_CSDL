-- Cau 11:

--Rang buoc them HOADON:
 CREATE TRIGGER TRG_INSERT_HOADON ON HOADON
 FOR INSERT
 AS BEGIN
 DECLARE @NGHD smalldatetime, @MAKH VARCHAR(10), @NGDK SMALLDATETIME
 SELECT @NGHD = NGHD, @MAKH = MAKH FROM inserted
 SELECT @NGDK = NGDK 
 FROM KHACHHANG 
 WHERE @MAKH = MAKH
	IF @NGHD >= @NGDK
		PRINT N'THEM HOA DON THANH CONG'
	ELSE
		BEGIN
		PRINT N'NGAY HOA DON PHAI LON HON NGAY DANG KY'
		ROLLBACK TRAN
		END
 END


 -- INSERT INTO NHANVIEN(MANV, HOTEN, SODT, NGVL) VALUES('NV01', 'Nguyễn Văn A', '09321313', '22/01/2013')
 --SET DATEFORMAT DMY;
-- INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1025', '22/07/2025', 'KH03', 'NV01', '320000')
 GO

CREATE TRIGGER TRG_UPDATE_KHACHHANG ON KHACHHANG for
UPDATE
    AS BEGIN
    DECLARE @MAKH CHAR(4),
    @NGDK SMALLDATETIME,
    @NGHD SMALLDATETIME
    SELECT
        @MAKH = MAKH,
        @NGDK = NGDK
    FROM
        INSERTED
    IF EXISTS (
        SELECT
        *
    FROM
        HOADON
    WHERE
            MAKH = @MAKH
        AND NGHD < @NGDK
    ) BEGIN
        PRINT N'Lỗi'
        ROLLBACK TRAN
    END
ELSE PRINT N'Thành công'
END

go
CREATE TRIGGER TRG_UPDATE_HOADON ON HOADON for
UPDATE
    AS BEGIN
    DECLARE @MAKH CHAR(4),
    @NGDK SMALLDATETIME,
    @NGHD SMALLDATETIME
    SELECT
        @MAKH = MAKH,
        @NGHD = NGHD
    FROM
        INSERTED

	SELECT @NGDK = NGDK 
	FROM KHACHHANG
	WHERE MAKH = @MAKH
    IF @NGHD < @NGDK 
    BEGIN
        PRINT N'Lỗi'
        ROLLBACK TRAN
    END
ELSE PRINT N'Thành công'
END


-- Cau 12:

---------------------------------------
--            THEM   | XOA    |SUA
-- HOADON   |   +    |        |+(NGHD)
--NHANVIEN  |   -    |  -(*)  |+(NGVL)
---------------------------------------
--
GO
CREATE TRIGGER CAU12_INSERT_HOADON ON HOADON
FOR INSERT
AS BEGIN
	DECLARE @MANV VARCHAR(10), @NGHD SMALLDATETIME, @NGVL SMALLDATETIME
	SELECT @MANV = MANV, @NGHD = NGHD FROM inserted
	SELECT @NGVL = NGVL FROM NHANVIEN WHERE @MANV = MANV
IF (@NGHD >= @NGVL)
	PRINT N'Thêm hóa đơn thành công'
ELSE 
	BEGIN 
		PRINT N'Ngày hóa đơn phải lớn hơn ngày nhân viên vào làm'
		ROLLBACK TRAN
	END
END

GO

CREATE TRIGGER CAU12_UPDATE_HOADON ON HOADON
FOR UPDATE
AS BEGIN
	DECLARE @MANV VARCHAR(10), @NGHD SMALLDATETIME, @NGVL SMALLDATETIME
	SELECT @MANV = MANV, @NGHD = NGHD FROM inserted
	SELECT @NGVL = NGVL FROM NHANVIEN WHERE @MANV = MANV
IF (@NGHD >= @NGVL)
	PRINT N'Sửa hóa đơn thành công'
ELSE 
	BEGIN 
		PRINT N'Ngày hóa đơn phải lớn hơn ngày nhân viên vào làm'
		ROLLBACK TRAN
	END
END

GO

CREATE TRIGGER CAU12_UPDATE_NHANVIEN ON NHANVIEN
FOR UPDATE
AS BEGIN
	DECLARE @MANV VARCHAR(10), @NGVL SMALLDATETIME
	SELECT @MANV = MANV, @NGVL = NGVL FROM inserted
IF (EXISTS (
		SELECT * FROM HOADON 
			WHERE MANV = @MANV AND NGHD < @NGVL
		)
)
	PRINT N'Thêm nhân viên thành công'
ELSE 
	BEGIN 
		PRINT N'Ngày hóa đơn phải lớn hơn ngày nhân viên vào làm'
		ROLLBACK TRAN
	END
END
--DROP TRIGGER CAU12_UPDATE_NHANVIEN

-- Cau 13:
---------------------------------------
--            THEM   | XOA    |SUA
-- HOADON   |   -    |  -(*)  |-
--CTHD      |   -    |  +     |+(SOHD)
---------------------------------------
--
GO

CREATE TRIGGER Delete_CTHD_13 ON CTHD 
FOR DELETE 
AS BEGIN
    DECLARE @SOHD INT
    SELECT
        @SOHD = SOHD
    FROM
        deleted
    IF (
        SELECT
        COUNT(*)
    FROM
        CTHD
    WHERE
            SOHD = @SOHD
    ) < 1 BEGIN
        PRINT N'Lỗi rồi nhé'
        ROLLBACK TRAN
    END
ELSE PRINT N'Thành công'
END
GO
--DELETE FROM CTHD WHERE SOHD = 1025;
CREATE TRIGGER UPDATE_CTHD_13 ON CTHD
FOR UPDATE
AS BEGIN
	DECLARE @SOHD INT
	SELECT @SOHD = SOHD FROM deleted
IF (SELECT COUNT(*) FROM CTHD WHERE SOHD = @SOHD) < 1
	BEGIN
	PRINT N'Lỗi'
	ROLLBACK TRAN
	END
ELSE 
		PRINT N'Thành công'
END

GO