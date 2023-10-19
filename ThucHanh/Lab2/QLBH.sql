--Cau 1:



SET DATEFORMAT DMY

GO

INSERT INTO NHANVIEN VALUES ('NV01', 'Nguyen Nhu Nhut', '927345678', '13/04/2006')
INSERT INTO NHANVIEN VALUES ('NV02', 'Le Thi Phi Yen', '987567390', '21/04/2006')
INSERT INTO NHANVIEN VALUES ('NV03', 'Nguyen Van B', '997047382', '27/04/2006')
INSERT INTO NHANVIEN VALUES ('NV04', 'Ngo Thanh Tuan', '913758498', '24/06/2006')
INSERT INTO NHANVIEN VALUES ('NV05', 'Nguyen Thi Truc Thanh', '918590387', '20/07/2006')

GO

SET DATEFORMAT DMY

INSERT INTO KHACHHANG VALUES ('KH01', 'Nguyen Van A', '731 Tran Hung Dao, Q5, TpHCM', '8823451', '22/10/1960', 13060000, '22/07/2006')
INSERT INTO KHACHHANG VALUES ('KH02', 'Tran Ngoc Han', '23/5 Nguyen Trai, Q5, TpHCM', '908256478', '03/04/1974', 280, '30/07/2006')
INSERT INTO KHACHHANG VALUES ('KH03', 'Tran Ngoc Linh', '45 Nguyen Canh Chan, Q1, TpHCM', '938776266', '12/06/1980', 3860000, '05/08/2006')
INSERT INTO KHACHHANG VALUES ('KH04', 'Tran Minh Long', '50/34 Le Dai Hanh, Q10, TpHCM', '917325476', '09/03/1965', 250, '02/10/2006')
INSERT INTO KHACHHANG VALUES ('KH05', 'Le Nhat Minh', '34 Truong Dinh, Q3, TpHCM', '8246108', '10/03/1950', 21, '28/10/2006')
INSERT INTO KHACHHANG VALUES ('KH06', 'Le Hoai Thuong', '227 Nguyen Van Cu, Q5, TpHCM', '8631738', '31/12/1981', 915, '24/11/2006')
INSERT INTO KHACHHANG VALUES ('KH07', 'Nguyen Van Tam', '32/3 Tran Binh Trong, Q5, TpHCM', '916783565', '06/04/1971', 125, '01/12/2006')
INSERT INTO KHACHHANG VALUES ('KH08', 'Phan Thi Thanh', '45/2 An Duong Vuong, Q5, TpHCM', '938435756', '10/01/1971', 365, '13/12/2006')
INSERT INTO KHACHHANG VALUES ('KH09', 'Le Ha Vinh', '873 Le Hong Phong, Q5, TpHCM', '8654763', '03/09/1979', 70, '14/01/2007')
INSERT INTO KHACHHANG VALUES ('KH10', 'Ha Duy Lap', '34/34B Nguyen Trai, Q1, TpHCM', '8768904', '02/05/1983', 675, '16/01/2007')


SELECT * FROM KHACHHANG

GO
SET DATEFORMAT DMY
INSERT INTO HOADON VALUES (1001, '23/07/2006', 'KH01', 'NV01', 320)
INSERT INTO HOADON VALUES (1002, '12/08/2006', 'KH01', 'NV02', 840)
INSERT INTO HOADON VALUES (1003, '23/08/2006', 'KH02', 'NV01', 100)
INSERT INTO HOADON VALUES (1004, '01/09/2006', 'KH02', 'NV01', 180)
INSERT INTO HOADON VALUES (1005, '20/10/2006', 'KH01', 'NV02', 3800000)
INSERT INTO HOADON VALUES (1006, '16/10/2006', 'KH01', 'NV03', 2430000)
INSERT INTO HOADON VALUES (1007, '28/10/2006', 'KH03', 'NV03', 510)
INSERT INTO HOADON VALUES (1008, '28/10/2006', 'KH01', 'NV03', 440)
INSERT INTO HOADON VALUES (1009, '28/10/2006', 'KH03', 'NV04', 200)
INSERT INTO HOADON VALUES (1010, '01/11/2006', 'KH01', 'NV01', 5200000)
INSERT INTO HOADON VALUES (1011, '04/11/2006', 'KH04', 'NV03', 250)
INSERT INTO HOADON VALUES (1012, '30/11/2006', 'KH05', 'NV03', 21)
INSERT INTO HOADON VALUES (1013, '12/12/2006', 'KH06', 'NV01', 5)
INSERT INTO HOADON VALUES (1014, '31/12/2006', 'KH03', 'NV02', 3150000)
INSERT INTO HOADON VALUES (1015, '01/01/2007', 'KH06', 'NV01', 910)
INSERT INTO HOADON VALUES (1016, '01/01/2007', 'KH07', 'NV02', 125)
INSERT INTO HOADON VALUES (1017, '02/01/2007', 'KH08', 'NV03', 35)
INSERT INTO HOADON VALUES (1018, '13/01/2007', 'KH08', 'NV03', 330)
INSERT INTO HOADON VALUES (1019, '13/01/2007', 'KH01', 'NV03', 30)
INSERT INTO HOADON VALUES (1020, '14/01/2007', 'KH09', 'NV04', 70)
INSERT INTO HOADON VALUES (1021, '16/01/2007', 'KH10', 'NV03', 675)
INSERT INTO HOADON VALUES (1022, '16/01/2007', Null, 'NV03', 7)
INSERT INTO HOADON VALUES (1023, '17/01/2007', Null, 'NV01', 330)

SELECT * FROM HOADON

GO
SET DATEFORMAT DMY
INSERT INTO SANPHAM VALUES ('BC01', 'But chi', 'cay', 'Singapore', 3000)
INSERT INTO SANPHAM VALUES ('BC02', 'But chi', 'cay', 'Singapore', 5000)
INSERT INTO SANPHAM VALUES ('BC03', 'But chi', 'cay', 'Viet Nam', 35000)
INSERT INTO SANPHAM VALUES ('BC04', 'But chi', 'hop', 'Viet Nam', 30000)
INSERT INTO SANPHAM VALUES ('BB01', 'But bi', 'cay', 'Viet Nam', 5000)
INSERT INTO SANPHAM VALUES ('BB02', 'But bi', 'cay', 'Trung Quoc', 7000)
INSERT INTO SANPHAM VALUES ('BB03', 'But bi', 'hop', 'Thai Lan', 100000)
INSERT INTO SANPHAM VALUES ('TV01', 'Tap 100 giay mong', 'quyen', 'Trung Quoc', 25000)
INSERT INTO SANPHAM VALUES ('TV02', 'Tap 200 giay mong', 'quyen', 'Trung Quoc', 45000)
INSERT INTO SANPHAM VALUES ('TV03', 'Tap 100 giay tot', 'quyen', 'Viet Nam', 3000)
INSERT INTO SANPHAM VALUES ('TV04', 'Tap 200 giay tot', 'quyen', 'Viet Nam', 55000)
INSERT INTO SANPHAM VALUES ('TV05', 'Tap 100 trang', 'chuc', 'Viet Nam', 23000)
INSERT INTO SANPHAM VALUES ('TV06', 'Tap 200 trang', 'chuc', 'Viet Nam', 53000)
INSERT INTO SANPHAM VALUES ('TV07', 'Tap 100 trang', 'chuc', 'Trung Quoc', 34000)
INSERT INTO SANPHAM VALUES ('ST01', 'So tay 500 trang', 'quyen', 'Trung Quoc', 40000)
INSERT INTO SANPHAM VALUES ('ST02', 'So tay loai 1', 'quyen', 'Viet Nam', 55000)
INSERT INTO SANPHAM VALUES ('ST03', 'So tay loai 2', 'quyen', 'Viet Nam', 51000)
INSERT INTO SANPHAM VALUES ('ST04', 'So tay', 'quyen', 'Thai Lan', 55000)
INSERT INTO SANPHAM VALUES ('ST05', 'So tay mong', 'quyen', 'Thai Lan', 20000)
INSERT INTO SANPHAM VALUES ('ST06', 'Phan viet bang', 'hop', 'Viet Nam', 5000)
INSERT INTO SANPHAM VALUES ('ST07', 'Phan khong bui', 'hop', 'Viet Nam', 7000)
INSERT INTO SANPHAM VALUES ('ST08', 'Bong bang', 'cai', 'Viet Nam', 1000)
INSERT INTO SANPHAM VALUES ('ST09', 'But long', 'cay', 'Viet Nam', 5000)
INSERT INTO SANPHAM VALUES ('ST10', 'But long', 'cay', 'Trung Quoc', 7000)

SELECT * FROM SANPHAM

GO

INSERT INTO CTHD VALUES (1001, 'TV02', 10)
INSERT INTO CTHD VALUES (1001, 'ST01', 5)
INSERT INTO CTHD VALUES (1001, 'BC01', 5)
INSERT INTO CTHD VALUES (1001, 'BC02', 10)
INSERT INTO CTHD VALUES (1001, 'ST08', 10)
INSERT INTO CTHD VALUES (1002, 'BC04', 20)
INSERT INTO CTHD VALUES (1002, 'BB01', 20)
INSERT INTO CTHD VALUES (1002, 'BB02', 20)
INSERT INTO CTHD VALUES (1003, 'BB03', 10)
INSERT INTO CTHD VALUES (1004, 'TV01', 20)
INSERT INTO CTHD VALUES (1004, 'TV02', 10)
INSERT INTO CTHD VALUES (1004, 'TV03', 10)
INSERT INTO CTHD VALUES (1004, 'TV04', 10)
INSERT INTO CTHD VALUES (1005, 'TV05', 50)
INSERT INTO CTHD VALUES (1005, 'TV06', 50)
INSERT INTO CTHD VALUES (1006, 'TV07', 20)
INSERT INTO CTHD VALUES (1006, 'ST01', 30)
INSERT INTO CTHD VALUES (1006, 'ST02', 10)
INSERT INTO CTHD VALUES (1007, 'ST03', 10)
INSERT INTO CTHD VALUES (1008, 'ST04', 8)
INSERT INTO CTHD VALUES (1009, 'ST05', 10)
INSERT INTO CTHD VALUES (1010, 'TV07', 50)
INSERT INTO CTHD VALUES (1010, 'ST07', 50)
INSERT INTO CTHD VALUES (1010, 'ST08', 100)
INSERT INTO CTHD VALUES (1010, 'ST04', 50)
INSERT INTO CTHD VALUES (1010, 'TV03', 100)
INSERT INTO CTHD VALUES (1011, 'ST06', 50)
INSERT INTO CTHD VALUES (1012, 'ST07', 3)
INSERT INTO CTHD VALUES (1013, 'ST08', 5)
INSERT INTO CTHD VALUES (1014, 'BC02', 80)
INSERT INTO CTHD VALUES (1014, 'BB02', 100)
INSERT INTO CTHD VALUES (1014, 'BC04', 60)
INSERT INTO CTHD VALUES (1014, 'BB01', 50)
INSERT INTO CTHD VALUES (1015, 'BB02', 30)
INSERT INTO CTHD VALUES (1015, 'BB03', 7)
INSERT INTO CTHD VALUES (1016, 'TV01', 5)
INSERT INTO CTHD VALUES (1017, 'TV02', 1)
INSERT INTO CTHD VALUES (1017, 'TV03', 1)
INSERT INTO CTHD VALUES (1017, 'TV04', 5)
INSERT INTO CTHD VALUES (1018, 'ST04', 6)
INSERT INTO CTHD VALUES (1019, 'ST05', 1)
INSERT INTO CTHD VALUES (1019, 'ST06', 2)
INSERT INTO CTHD VALUES (1020, 'ST07', 10)
INSERT INTO CTHD VALUES (1021, 'ST08', 5)
INSERT INTO CTHD VALUES (1021, 'TV01', 7)
INSERT INTO CTHD VALUES (1021, 'TV02', 10)
INSERT INTO CTHD VALUES (1022, 'ST07', 1)
INSERT INTO CTHD VALUES (1023, 'ST04', 6)

SELECT * FROM CTHD;

GO

SELECT * FROM NHANVIEN;


-- Cau 2:
GO
SELECT * INTO SANPHAM1 FROM SANPHAM;

SELECT * INTO KHACHHANG1 FROM KHACHHANG;

GO
--Cau 3:

UPDATE SANPHAM 
SET GIA = GIA + GIA * 5/100
WHERE NUOCSX = 'Thai Lan';

--Cau 4:

UPDATE SANPHAM1 
SET GIA = GIA - GIA * 5/100
WHERE NUOCSX = 'Trung Quoc' AND GIA <= 10000;

-- Cau 5:

DELETE FROM SANPHAM1 WHERE NUOCSX = 'Uc';




-- PHAN III

--Cau 1:

SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc';

--Cau 2:

SELECT MASP, TENSP 
FROM SANPHAM
WHERE DVT = 'cay' OR DVT = 'quyen';

--Cau 3:

SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE 'B%01';

--Cau 4:

SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND (GIA BETWEEN 30000 AND 40000);

--Cau 5:

SELECT MASP, TENSP
FROM SANPHAM
WHERE (NUOCSX = 'Trung Quoc' OR NUOCSX = 'Thai Lan') AND (GIA BETWEEN 30000 AND 40000);

--Cau 6:
SELECT SOHD, TRIGIA 
FROM HOADON
WHERE NGHD = '2007-1-1' OR NGHD = '2007-2-1'

--Cau 7:
SELECT SOHD, TRIGIA
FROM HOADON
WHERE MONTH(NGHD) = 1 AND YEAR(NGHD) = 2007
ORDER BY NGHD ASC, TRIGIA DESC;
-- Cau 8:

SELECT  KH.MAKH,  KH.HOTEN 
FROM KHACHHANG KH, HOADON HD WHERE KH.MAKH = HD.MAKH AND HD.NGHD = '2007-01-01';
