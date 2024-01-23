-- PHAN II
-- 1.	Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN SET HESO = HESO + 0.2 WHERE MAGV IN (
  SELECT TRGKHOA FROM KHOA
)
-- 2.	Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
UPDATE HV SET DIEMTB = DTB_HOCVIEN.DTB
FROM HOCVIEN HV LEFT JOIN (
	SELECT MAHV, AVG(DIEM) AS DTB 
	FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) 
	GROUP BY MAHV
) DTB_HOCVIEN
ON HV.MAHV = DTB_HOCVIEN.MAHV


-- 3.	Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN SET GHICHU = 'Cam thi'
WHERE MAHV IN (
	SELECT MAHV 
	FROM KETQUATHI 
	WHERE  DIEM < 5 AND LANTHI = 3
)


-- 4.	Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN
UPDATE HOCVIEN SET XEPLOAI = CASE 
	WHEN DIEMTB >= 9 THEN 'XS'
	WHEN DIEMTB >= 8 THEN 'G'
	WHEN DIEMTB >= 6.5 THEN 'K'
	WHEN DIEMTB >= 5 THEN 'TB'
	ELSE 'Y'
END

-- III. Ngôn ngữ truy vấn dữ liệu:
-- 6.	Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT DISTINCT MAMH 
	
  
  FROM GIANGDAY INNER JOIN GIAOVIEN 
	ON GIANGDAY.MAGV = GIAOVIEN.MAGV 
  
	WHERE HOCKY = 1  AND HOTEN = 
  'Tran Tam Thanh' AND NAM = 2006
)


-- 7.	Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	
  
  SELECT DISTINCT MAMH FROM GIANGDAY WHERE MAGV IN (
		
    SELECT MAGVCN FROM LOP WHERE MALOP = 'K11'
	) AND HOCKY = 1 AND NAM = 2006
)

-- 8.	Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT HO + ' ' + TEN AS HOTEN FROM HOCVIEN
WHERE MAHV IN (
	SELECT TRGLOP FROM LOP 
	
  
  WHERE MALOP IN (
		SELECT DISTINCT MALOP FROM GIANGDAY 
		WHERE MAGV IN (
          
			SELECT MAGV FROM GIAOVIEN WHERE HOTEN = 'Nguyen To Lan'
		) 
      AND MAMH IN (
			SELECT MAMH FROM MONHOC WHERE TENMH = 'Co So Du Lieu'
		)
	)
)

-- 9.	In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT MAMH_TRUOC FROM DIEUKIEN WHERE MAMH IN (
		SELECT MAMH FROM MONHOC     WHERE TENMH = 'Co So Du Lieu'
	)
)

-- 10.	Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT MAMH FROM DIEUKIEN WHERE MAMH_TRUOC IN (
		SELECT MAMH    FROM MONHOC WHERE TENMH = 'Cau Truc Roi Rac'
	)
)


-- 11.	Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT HOTEN FROM GIAOVIEN 
WHERE MAGV IN (
	SELECT MAGV FROM GIANGDAY 
	
  WHERE MAMH = 'CTRR' AND MALOP IN ('K11', 'K12') 
  AND HOCKY = 1 
  AND NAM = 2006
	GROUP BY MAGV 
  
	HAVING COUNT(DISTINCT MALOP) = 2
)

-- 12.	Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
SELECT MAHV, HO + ' ' + TEN AS HOTEN FROM HOCVIEN 
WHERE MAHV IN (
	SELECT MAHV FROM KETQUATHI A
	WHERE 
  NOT EXISTS (
		SELECT 1 FROM KETQUATHI B 
      
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND MAMH = 'CSDL' AND LANTHI = 1 AND KQUA = 'Khong Dat'
)

-- 13.	Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN FROM GIAOVIEN 
WHERE MAGV NOT IN (
	SELECT DISTINCT MAGV FROM GIANGDAY
)


-- 14.	Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT MAGV, HOTEN FROM GIAOVIEN 
WHERE MAGV NOT IN (
	SELECT GD.MAGV
	FROM GIANGDAY GD INNER JOIN GIAOVIEN GV 
	ON GD.MAGV = GV.MAGV INNER JOIN MONHOC MH
	ON GD.MAMH = MH.MAMH
	WHERE GV.MAKHOA = MH.MAKHOA
)


-- 15.	Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HO + ' ' + TEN AS HOTEN FROM HOCVIEN
WHERE MAHV IN (
	SELECT MAHV FROM KETQUATHI A
	WHERE LEFT(MAHV, 3) = 'K11' AND ((
		NOT EXISTS (
			SELECT 1 FROM KETQUATHI B 
			WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
		)  AND LANTHI = 3 AND KQUA = 'Khong Dat'
	) OR MAMH = 'CTRR' AND LANTHI = 2 AND DIEM = 5)
)


-- 16.	Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN FROM GIAOVIEN 
WHERE MAGV IN (
	SELECT MAGV FROM GIANGDAY 
	WHERE MAMH = 'CTRR'
	GROUP BY MAGV, HOCKY, NAM 
	HAVING COUNT(MALOP) >= 2
)


-- 17.	Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, DIEM 
FROM HOCVIEN HV INNER JOIN (
	SELECT MAHV, DIEM 
	FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND MAMH = 'CSDL'
) DIEM_CSDL
ON HV.MAHV = DIEM_CSDL.MAHV

-- 18.	Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, DIEM 
FROM HOCVIEN HV INNER JOIN (
	SELECT MAHV, MAX(DIEM) AS DIEM FROM KETQUATHI 
	WHERE MAMH IN (
		SELECT MAMH FROM MONHOC 
		WHERE TENMH = 'Co So Du Lieu'
	) 
	GROUP BY MAHV, MAMH
) DIEM_CSDL_MAX
ON HV.MAHV = DIEM_CSDL_MAX.MAHV



