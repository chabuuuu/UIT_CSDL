--Cau 1:
CREATE TABLE KHACHHANG (
	MAKH char(4) primary key, 
	HOTEN varchar(40), 
	DCHI varchar(50), 
	SODT varchar(20), 
	NGSINH smalldatetime, 
	DOANHSO money, 
	NGDK smalldatetime
)

CREATE TABLE NHANVIEN (
	MANV	char(4) PRIMARY KEY,
 	HOTEN	varchar(40),
 	SODT	varchar(20),
 	NGVL	smalldatetime
)
CREATE TABLE SANPHAM (
	MASP	char(4) PRIMARY KEY,
 	TENSP	varchar(40),
 	DVT	varchar(20),
 	NUOCSX	varchar(40),
 	GIA	money
)

CREATE TABLE HOADON (
	SOHD	int PRIMARY KEY,
 	NGHD	smalldatetime,
 	MAKH	char(4),
 	MANV	char(4),
 	TRIGIA	money,
	FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH),
	FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
)

CREATE TABLE CTHD (
	SOHD	int,
 	MASP	char(4),
 	SL	int,
	constraint PK_CTHD PRIMARY KEY (SOHD, MASP),
	constraint FK_CTHD_MASP FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP),
	constraint PK_CTHD_SOHD FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD)
)



--CAU 2: Them thuoc tinh GHICHU vao bang SANPHAM
ALTER TABLE SANPHAM ADD GHICHU VARCHAR(20);

--CAU 3: Them thuoc tinh LOAIKH vao bang KHACHHANG
ALTER TABLE KHACHHANG ADD LOAIKH tinyint;

--CAU 4: Sua kieu du lieu thuoc tinh GHICHU thanh varchar(100)
ALTER TABLE SANPHAM ALTER COLUMN GHICHU VARCHAR(100);

--Cau 5: Xoa thuoc tinh ghi chu khoi bang SANPHAM
ALTER TABLE SANPHAM DROP COLUMN GHICHU;

--CAU 6: Sua kieu du lieu thuoc tinh LOAIKH
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH VARCHAR(20);

--CAU 7: Them rang buoc CK_DVT cho bang SANPHAM
ALTER TABLE SANPHAM ADD CONSTRAINT CK_DVT 
CHECK(
	DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc')
	);

ALTER TABLE SANPHAM ADD CONSTRAINT CK_DVT_2 
CHECK(
	DVT = 'cay' OR DVT = 'hop' OR DVT = 'cai' OR DVT = 'quyen' 
	OR DVT = 'chuc'
	);

--CAU 8: Them rang buoc CK_GIA cho bang SANPHAM
ALTER TABLE SANPHAM ADD CONSTRAINT CK_GIA 
CHECK(
	GIA >= 500
	);

--CAU 9: Them rang buoc CK_SL cho bang CTHD
ALTER TABLE CTHD ADD CONSTRAINT CK_SL 
CHECK (
	SL >= 1
	);

-- CAU 10: Them rang buoc CK_NGSINH_NGDK cho bang KHACHHANG
ALTER TABLE KHACHHANG ADD CONSTRAINT CK_NGSINH_NGDK
CHECK(
	NGDK > NGSINH
	);

DROP TABLE CTHD;

