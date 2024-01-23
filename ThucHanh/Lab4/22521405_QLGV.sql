
------THUC HANH LAB4: QUAN LY GIAO VU--------
---19.	Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT TOP (1) WITH TIES * FROM KHOA ORDER BY NGTLAP ASC 

----20.	Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.

SELECT 
HOCHAM, COUNT(HOCHAM) SL FROM GIAOVIEN 
WHERE HOCHAM = 'GS' OR HOCHAM = 'PGS' 
GROUP BY HOCHAM

--21.	Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT 
MAKHOA, HOCVI, COUNT(HOCVI) SL 
FROM GIAOVIEN 
GROUP BY MAKHOA, HOCVI

------22.	Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MAMH, KQUA, COUNT(MAHV) SL
FROM KETQUATHI A
WHERE NOT EXISTS (
-- Lần thi thứ 1 thì không tính, chỉ tính lần thi thứ 2 thì tính là đậu.
	SELECT 1 
	FROM KETQUATHI B 
	WHERE 
	A.MAMH = B.MAMH AND 
	A.MAHV = B.MAHV AND 
	A.LANTHI < B.LANTHI
)
GROUP BY MAMH, KQUA

----23.	Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT MAGV, HOTEN 
FROM GIAOVIEN 
WHERE 
MAGV IN(

	SELECT DISTINCT MAGV
	FROM GIANGDAY GD INNER JOIN LOP LP
	ON  LP.MALOP =  GD.MALOP 
	WHERE MAGV = MAGVCN 

)

--24.	Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT HO + ' ' + TEN HOTEN 
FROM LOP LP, HOCVIEN HV
WHERE SISO = 
(SELECT MAX(SISO) FROM LOP) --LẤY RA LỚP CÓ SĨ SỐ CAO NHẤT
AND LP.TRGLOP = HV.MAHV

----25.	* Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT HO + ' ' + TEN HOTEN 
FROM HOCVIEN
WHERE MAHV IN (
	SELECT MAHV FROM KETQUATHI KQA
	WHERE MAHV IN (
		SELECT TRGLOP FROM LOP
	) 
	AND KQUA = 'Khong Dat'
	AND NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI KQB 
		WHERE 
		KQA.LANTHI < KQB.LANTHI AND
		KQA.MAHV = KQB.MAHV AND 
		KQA.MAMH = KQB.MAMH
	) 
	GROUP BY MAHV
	HAVING COUNT(MAMH) >= 3
)

----26.	Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT HVA.MAHV, HO + ' ' + TEN HOTEN 
FROM (
	SELECT MAHV, RANK () 
	OVER (ORDER BY COUNT(MAMH) DESC) THUTU 
	FROM KETQUATHI KQ 
	WHERE DIEM BETWEEN 9 AND 10
	GROUP BY KQ.MAHV
) HVA INNER JOIN HOCVIEN HVB
ON HVA.MAHV = HVB.MAHV
WHERE THUTU = 1 

--- 27.	Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT LEFT(A.MAHV, 3) MALOP, A.MAHV, HO + ' ' + TEN HOTEN 
FROM (
	SELECT MAHV, 
	RANK () OVER (ORDER BY COUNT(MAMH) DESC) THUTU FROM KETQUATHI KQ 
	WHERE DIEM BETWEEN 9 AND 10
	GROUP BY KQ.MAHV
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV
WHERE THUTU = 1
GROUP BY 
A.MAHV, HO, TEN, LEFT(A.MAHV, 3)


-----28.	Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT 
HOCKY, NAM, MAGV,  COUNT(MAMH) SL_MH, COUNT(MALOP) SL_LOP 
FROM GIANGDAY
GROUP BY NAM, MAGV, HOCKY


----29.	Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT 
HOCKY, NAM, A.MAGV, HOTEN FROM (
-- Bang sap xep cac so luong mon hoc ma cac giao vien day tu cao den thap
	SELECT 
	HOCKY, NAM, MAGV, RANK() 
	OVER (PARTITION BY HOCKY, NAM ORDER BY COUNT(MAMH) DESC) THUTU 
	FROM GIANGDAY
	GROUP BY HOCKY, NAM, MAGV
) A INNER JOIN GIAOVIEN GV 
ON A.MAGV = GV.MAGV 
WHERE THUTU = 1


---30.	Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
SELECT 
XH.MAMH, TENMH 
FROM (
---Bảng xếp hạng các môn học có số lượng sinh viên không đại ở lần 1 nhiều nhất
	SELECT 
	MAMH, RANK() OVER (ORDER BY COUNT(MAHV) DESC) THUTU 
		FROM KETQUATHI
	WHERE KQUA = 'Khong Dat' AND LANTHI = 1
	GROUP BY MAMH
) 
XH, MONHOC MH --nối 2 bảng
WHERE 
XH.MAMH = MH.MAMH AND THUTU = 1


----31.	Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
SELECT 
A.MAHV, HO + ' ' + TEN HOTEN 
FROM (

--- Bảng xếp hạng số lần đạt của các học viên
	SELECT MAHV, COUNT(KQUA) SOLANDAT 
	FROM KETQUATHI 
	WHERE LANTHI = 1 AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SO_MH 
	FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) A , 
HOCVIEN HV
WHERE A.MAHV = HV.MAHV

----32.	* Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
SELECT C.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, COUNT(KQUA) SODAT FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE 
		A.MAHV = B.MAHV AND 
		A.MAMH = B.MAMH AND 
		A.LANTHI < B.LANTHI
	) 
	AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SO_MH FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) C,  HOCVIEN HV
WHERE C.MAHV = HV.MAHV

-----33.	* Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).
SELECT 
A.MAHV, HO + ' ' + TEN HOTEN 
FROM (
	SELECT MAHV, COUNT(KQUA) SOLANDAT 
	FROM KETQUATHI 
	WHERE LANTHI = 1 AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SOMH 
	FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) A , HOCVIEN HV
WHERE A.MAHV = HV.MAHV

----34.	* Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt  (chỉ xét lần thi sau cùng).
SELECT 
C.MAHV, HO + ' ' + TEN HOTEN 
FROM (
	SELECT MAHV, COUNT(KQUA) SOLANDAT FROM KETQUATHI A
	WHERE 
	KQUA = 'Dat' AND
	NOT EXISTS (
		SELECT 1 FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) 
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SOMH 
		FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) C , HOCVIEN HV
WHERE C.MAHV = HV.MAHV



-----35.	** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
SELECT 
A.MAHV, HO + ' ' + TEN HOTEN 
FROM (SELECT B.MAMH, MAHV, DIEM, MAX_DIEM
	FROM KETQUATHI B INNER JOIN (
		SELECT MAMH, MAX(DIEM) MAX_DIEM FROM KETQUATHI

		GROUP BY MAMH
	) C 
	ON B.MAMH = C.MAMH
	WHERE NOT EXISTS (
		SELECT 1 FROM KETQUATHI D 
		WHERE 
		B.MAMH = D.MAMH AND 
		B.MAHV = D.MAHV AND 
		B.LANTHI < D.LANTHI
	) 
	AND MAX_DIEM = DIEM
) A, HOCVIEN HV
WHERE A.MAHV = HV.MAHV