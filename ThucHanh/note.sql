Số tinyint, smallint, int,
numeric(m,n), decimal(m,n), float, real, 
smallmoney, money
bit
Chuỗi ký tự varchar(n), char(n), nvarchar(n), nchar(n)
Ngày tháng smalldatetime, datetime
Chuỗi nhị phân binary, varbinary


Gồm
 CREATE TABLE (tạo bảng)
 DROP TABLE (xóa bảng)
 ALTER TABLE (sửa bảng)
 CREATE DOMAIN (tạo miền giá trị)
 CREATE DATABASE (tạo cơ sở dữ liệu)

Thêm cột
ALTER TABLE <Tên_bảng> 
ADD <Tên_cột> <Kiểu_dữ_liệu> [<RBTV>]
Xóa cột
ALTER TABLE <Tên_bảng> 
DROP COLUMN <Tên_cột> 
Sửa cột
ALTER TABLE <Tên_bảng> 
ALTER COLUMN <Tên_cột> <Kiểu_dữ_liệu_mới>
Thêm RBTV
ALTER TABLE <Tên_bảng> ADD
CONSTRAINT <Ten_RBTV> <RBTV>,
CONSTRAINT <Ten_RBTV> <RBTV>,
…
Xóa RBTV
ALTER TABLE <Tên_bảng> DROP <Tên_RBTV

DELETE FROM <tên bảng>
[WHERE <điều kiện>]

Cú pháp
UPDATE <tên bảng>
SET <tên thuộc tính>=<giá trị mới>,
<tên thuộc tính>=<giá trị mới>, 
…
[WHERE <điều kiện>]



Loại bỏ các dòng trùng nhau
 Sử dụng DISTINCT trong mệnh đề SELECT

SELECT DISTINCT LUONG
FROM NHANVIEN
WHERE PHG=5 


BETWEEN … AND…
 Ví dụ: Tìm tất cả nhân viên có lương tối thiểu là 20000 và
lương tối đa là 45000
NOT BETWEEN… AND…
SELECT *
FROM NHANVIEN
WHERE LUONG BETWEEN 20000 AND 45000

NOT BETWEEN… AND
SELECT MANV, TENNV 
FROM NHANVIEN
WHERE LUONG NOT BETWEEN 20000 AND 45000

Phép hợp: UNION
Cho biết mã nhân viên tham gia dự án với nhiệm
vụ là Quan ly hay Tu van
SELECT DISTINCT MANV 
FROM PHANCONG
WHERE NVU=‘Quan ly’
UNION
SELECT DISTINCT MANV 
FROM PHANCONG
WHERE NVU=‘Tu van’


Phép giao: INTERSECT
Cho biết mã nhân viên tham gia dự án với nhiệm
vụ là Quan ly và Tu vanSELECT DISTINCT MANV 
FROM PHANCONG
WHERE NVU=‘Quan ly’
INTERSECT
SELECT DISTINCT MANV 
FROM PHANCONG
WHERE NVU=‘Tu van’
Phép hiệu: EXCEPT
Cho biết mã nhân viên không tham gia dự án
SELECT DISTINCT MANV 
FROM NHANVIEN
EXCEPT
SELECT DISTINCT MANV 
FROM PHANCONG

ORDER BY:

Cú pháp
SELECT <danh sách các cột>
FROM <danh sách các bảng>
WHERE <điều kiện>
ORDER BY <danh sách các cột>
Nếu muốn thứ tự tăng dần, sử dụng ASC (mặc 
định)
Nếu muốn thứ tự giảm dần, sử dụng DESC

-- VÍ DỤ:
SELECT MANV, TENNV 
FROM NHANVIEN
WHERE NVU=‘LT’
ORDER BY PHG DESC, NGSINH ASC


-- Có 5 hàm kết hợp cơ bản:
 COUNT
 COUNT(*) đếm số dòng
 COUNT(<tên thuộc tính>) đếm số giá trị khác NULL của thuộc tính
 SUM(A)
 AVG(A)
 MIN(A)
 MAX(A)

Cho biết tổng lương, lương cao nhất, lương thấp 
nhất, lương trung bình của các nhân viên thuộc 
P4
SELECT COUNT(MANV) 
FROM NHANVIEN
SELECT SUM(LUONG),MAX(LUONG),MIN(LUONG),AVG(LUONG) 
FROM NHANVIEN
WHERE PHG=‘P4’


-- gom nhóm:

SELECT <danh sách các cột>
FROM <danh sách các bảng>
[WHERE <điều kiện>]
GROUP BY <danh sách các cột gom nhóm>
 <danh sách các cột> chỉ có thể là các cột trong <danh sách 
các cột gom nhóm

Cho biết số lượng nhân viên của từng phòng
SELECT PHG, COUNT(*) AS SL_NV
FROM NHANVIEN
GROUP BY PHG

Với mỗi phòng ban, cho biết tên phòng và lương 
cao nhất của phòng

SELECT TENPHG, MAX(LUONG) AS MAXLUONG
FROM NHANVIEN, PHONGBAN
WHERE PHG=MAPHG
GROUP BY MAPHG,TENPHG

Với mỗi nhân viên cho biết mã số, họ tên, số 
lượng đề án và tổng thời gian mà họ tham gia


-- Mệnh đề HAVING
Mục đích: chọn ra các nhóm thỏa điều kiện nào 
đó
Mệnh đề HAVING: điều kiện được áp dụng trên 
mỗi nhóm
Cú pháp
SELECT <danh sách các cột>
FROM <danh sách các bảng>
WHERE <điều kiện>
GROUP BY <danh sách các cột gom nhóm>
HAVING <điều kiện trên nhóm

Cho biết tên các phòng ban có lương trung bình 
của nhân viên lớn hơn 45000
SELECT TENPHG, AVG(LUONG) AS LUONG_TB
FROM NHANVIEN, PHONGBAN
WHERE PHG=MAPHG
GROUP BY MAPHG,TENPHG
HAVING AVG(LUONG) > 45000


-- Sub query:
Cho biết mã số và tên các nhân viên có lương lớn 
hơn lương của tất cả nhân viên chức vụ ‘LT’
SELECT MANV,TENNV
FROM NHANVIEN 
WHERE LUONG > ALL(SELECT LUONG
FROM NHANVIEN
WHERE CVU=‘LT’)

Cho biết mã số và tên các nhân viên có lương lớn 
hơn ít nhất lương của một nhân viên chức vụ ‘LT’

SELECT MANV,TENNV
FROM NHANVIEN 
WHERE LUONG > ANY(SELECT LUONG
FROM NHANVIEN
WHERE CVU=‘LT’)


Cho biết mã số các trưởng phòng không có thân 
nhân
SELECT TRPHG
FROM PHONGBAN 
WHERE TRPHG NOT IN(SELECT MANV
FROM THANNHAN)


SELECT TRPHG
FROM PHONGBAN 
WHERE TRPHG <> ALL(SELECT MANV
FROM THANNHAN


--Phép chia:
SELECT x.A
FROM R x
WHERE NOT EXISTS (
SELECT *
FROM S y
WHERE NOT EXISTS (
SELECT * 
FROM R z
WHERE z.A=x.A AND z.B=y.B))


Cho biết tên các nhân viên tham gia tất cả các dự án
1: Nhân viên NV sao cho
2: không có đề án D nào mà không có
3: một bộ phân công PC chứng tỏ NV có tham gia D
SELECT TENNV
FROM NHANVIEN NV
WHERE NOT EXISTS (
SELECT *
FROM DEAN D
WHERE NOT EXISTS (
SELECT * 
FROM PHANCONG PC
WHERE PC.MA_NVIEN = NV.MANV 
AND PC.SODA = D.MADA ))
