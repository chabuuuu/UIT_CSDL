----------Trigger-----------
--cau lenh
/*
 -print
 -declare <ten bien><kieu du lieu> = <gia tri khoi tao>
 -set<ten bien> = <gia tri>
 -select :-truy van 
 -in gia tri cho bien : select <ten bien>
 -gan gia tri cho bien : select <ten bien> = <gia tri >
 -exists
 -not exists
 -if exists()
 else()
 -TCL
 -Rollback tran[saction]
 */
/*
 Các thao tác tạo trigger:
 
 + Tạo trigger:
 =>  Create trigger
 
 + Sửa trigger:
 alter Trigger
 
 + xóa trigger:
 drop trigger
 
 */
USE QLBH
GO
--câu 1a
CREATE TRIGGER trg_Bai1a ON KHACHHANG FOR
INSERT
    AS BEGIN
    Print 'Khach hang da them thanh cong'
END
INSERT INTO
    KHACHHANG
    (MAKH)
VALUES
    ('KH50')
GO
-- Câu 1b
--Cách 2
CREATE TRIGGER trg_Bai2a ON HOADON FOR
INSERT
    AS BEGIN
    DECLARE @HOTEN VARCHAR(40)
    SELECT
        @HOTEN = HOTEN
    FROM
        inserted INS,
        KHACHHANG KH
    WHERE
    INS.MAKH = KH.MAKH
    Print 'Hóa đơn của khách hàng ' + @HOTEN + ' đã thêm thành công'
END -- INSERT INTO HOADON
-- (SOHD, MAKH, MANV)
-- VALUES (1112, 'KH01', 'NV01')
DROP TRIGGER trg_Bai2a -- Cách 1
go
CREATE TRIGGER trg_Kiemtra_NhapHD ON HOADON FOR
INSERT
    AS BEGIN
    -- Dùng từ khoá để khai báo biến 
    DECLARE @MAKH CHAR(4)
    DECLARE @HOTEN VARCHAR(40)
    -------------------------------- 
    SELECT
        @MAKH = MAKH
    FROM
        INSERTED
    SELECT
        @HOTEN = HOTEN
    FROM
        KHACHHANG
    WHERE
    MAKH = @MAKH
    PRINT 'Hoa don cua khach hang ' + @HOTEN + ' da duoc them thanh cong'
END
go
--Bai 2
CREATE TRIGGER trg_bai2_ngdk ON KHACHHANG for
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
    SELECT
        @NGHD = NGHD
    FROM
        HOADON
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
---- Cau 13
CREATE TRIGGER Them_CTHD_13 ON CTHD FOR DELETE AS BEGIN
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
----R3:
CREATE TRIGGER Them_SINHVIEN ON SINHVIEN FOR
INSERT
    AS BEGIN
    DECLARE @MALOP VARCHAR(10)
    SELECT
        @MALOP = MALOP
    FROM
        inserted
    IF EXISTS (
        SELECT
        *
    FROM
        LOP
    WHERE
            @MALOP = MALOP
    ) BEGIN
        PRINT N'Thành công'
    ELSE PRINT N'Thất bại'
    ROLLBACK TRAN
END ----R4:
GO
CREATE TRIGGER Them_ketqua ON KETQUATHI FOR
INSERT
    AS BEGIN
    DECLARE @MAMH VARCHAR(10)
    SELECT
        @MAMH = MAMH
    FROM
        inserted
    IF EXISTS (
        SELECT
        *
    FROM
        MONHOC
    WHERE
            @MAMH = MAMH
    ) BEGIN
        PRINT N'Thành công'
    ELSE PRINT N'Thất bại'
    ROLLBACK TRAN
END