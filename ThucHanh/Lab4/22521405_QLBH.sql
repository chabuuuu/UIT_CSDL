--- PHAN III
--- CAU 20.
SELECT COUNT(SOHD) SLHD 
FROM KHACHHANG KH, HOADON HD
WHERE HD.MAKH = KH.MAKH AND NGDK IS NULL

---CAU 21: Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006
SELECT COUNT (DISTINCT MASP) SLSP FROM 
HOADON HD, CTHD CT 
WHERE HD.SOHD = CT.SOHD AND 
YEAR(NGHD) = 2006

-- Cau 22.	Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MAX(TRIGIA) MAX_TRIGIA, MIN(TRIGIA) MIN_TRIGIA 
FROM HOADON HD

-- 23.	Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AVG_TRIGIA
FROM HOADON HD 
WHERE YEAR(NGHD)=2006

-- 24.	Tính doanh thu bán hàng trong năm 2006.
SELECT SUM (HD.TRIGIA) DOANHTHU 
FROM HOADON HD
WHERE YEAR(NGHD)=2006

-- 25.	Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD 
FROM HOADON
WHERE TRIGIA = (SELECT MAX(TRIGIA) MAX_TRIGIA FROM HOADON) 
AND YEAR(NGHD)=2006

--CACH 2:
/*SELECT SOHD FROM HOADON
WHERE YEAR(NGHD) = 2006 AND 
TRIGIA >= ALL (SELECT TRIGIA
				FROM HOADON
				WHERE YEAR(NGHD) = 2006)
*/
-- 26.	Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT KH.HOTEN 
FROM HOADON HD, KHACHHANG KH
WHERE TRIGIA = (SELECT MAX(TRIGIA) MAX_TRIGIA FROM HOADON) 
AND YEAR(NGHD) = 2006
AND HD.MAKH = KH.MAKH


-- 27.	In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.
SELECT TOP 3 MAKH, HOTEN 
FROM KHACHHANG 
ORDER BY DOANHSO DESC

-- 28.	In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP 
FROM SANPHAM SP 
WHERE GIA IN (SELECT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC)

/* 29.	In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có 
giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm). */
SELECT MASP, TENSP 
FROM SANPHAM SP 
WHERE GIA IN (SELECT DISTINCT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC) AND
	NUOCSX = 'Thai Lan'

/* 30.	In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá 
bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất). */
SELECT MASP, TENSP 
FROM SANPHAM SP 
WHERE GIA IN (SELECT DISTINCT TOP 3 GIA 
FROM SANPHAM 
WHERE (NUOCSX = 'Trung Quoc') ORDER BY GIA DESC ) AND
	NUOCSX = 'Trung Quoc'

-- 31.	* In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).

SELECT TOP 3 * FROM KHACHHANG ORDER BY DOANHSO DESC 

-- Cach 2:
SELECT MAKH, HOTEN 
FROM KHACHHANG 
WHERE DOANHSO IN
	(SELECT DISTINCT TOP 3 DOANHSO
	FROM KHACHHANG
	ORDER BY DOANHSO DESC)

-- 32.	Tính tổng số sản phẩm do “Trung Quoc” sản xuất.

SELECT COUNT (MASP) TONG_SP FROM SANPHAM WHERE NUOCSX = 'Trung Quoc' 

-- 33.	Tính tổng số sản phẩm của từng nước sản xuất.

SELECT NUOCSX, COUNT (MASP) TONG_SP 
FROM SANPHAM 
GROUP BY NUOCSX

-- 34.	Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.

SELECT NUOCSX, MAX(GIA) MAX_GIA, MIN(GIA) MIN_GIA, AVG(GIA) AVG_GIA
FROM SANPHAM GROUP BY NUOCSX

-- 35.  Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) DOANHTHU 
FROM HOADON 
GROUP BY NGHD

-- 36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT MASP, SUM (SL) TONG_SL
FROM CTHD CT, HOADON HD
WHERE CT.SOHD = HD.SOHD AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006 
GROUP BY MASP

-- 37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) THANG, SUM(TRIGIA) DOANHTHU 
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD) 




-- 38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT BANG2.SOHD, BANG2.SO_SP FROM 
(	SELECT SOHD, COUNT (MASP) SO_SP FROM CTHD CT 
	GROUP BY SOHD
) 
AS BANG2 WHERE BANG2.SO_SP >= 4

-- 39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau)

SELECT SOHD  FROM CTHD CT, SANPHAM SP 
WHERE CT.MASP = SP.MASP AND NUOCSX = 'Viet Nam' 
GROUP BY SOHD
HAVING COUNT(distinct SP.MASP) = 3

-- 40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất. 
SELECT MAKH, HOTEN, SOLANMUA FROM (
SELECT HD.MAKH, HOTEN, COUNT(HD.MAKH) SOLANMUA FROM HOADON HD, KHACHHANG KH 
WHERE HD.MAKH = KH.MAKH
GROUP BY HD.MAKH , HOTEN
) AS BANG2 
WHERE SOLANMUA >= ALL (
	SELECT COUNT(HD.MAKH) SOLANMUA FROM HOADON HD
	GROUP BY HD.MAKH
)

-- 41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP (1) WITH TIES MONTH(NGHD) THANG, SUM(TRIGIA) DOANHSO 
FROM HOADON WHERE YEAR(NGHD) = 2006 
GROUP BY MONTH(NGHD) ORDER BY SUM(TRIGIA) DESC
-- Cach 2:
SELECT MONTH(NGHD) THANG
FROM HOADON 
WHERE YEAR (NGHD) = 2006
GROUP BY MONTH(NGHD)
HAVING SUM(TRIGIA) >= ALL (SELECT SUM(TRIGIA) FROM HOADON
WHERE YEAR (NGHD) = 2006 GROUP BY MONTH(NGHD))

-- 42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 WITH TIES CT.MASP, TENSP, SUM(SL) SOLUONG 
FROM CTHD CT, SANPHAM SP 
WHERE CT.MASP = SP.MASP
GROUP BY CT.MASP, TENSP
ORDER BY SOLUONG ASC

-- 43. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất
SELECT MASP, TENSP, SANPHAM.NUOCSX FROM SANPHAM, 
(
	SELECT NUOCSX, MAX(GIA) MAX_GIA 
	FROM SANPHAM 
	GROUP BY NUOCSX 
) 
AS BANG2 
WHERE SANPHAM.GIA = BANG2.MAX_GIA AND SANPHAM.NUOCSX = BANG2.NUOCSX

-- 44. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT COUNT(DISTINCT GIA) SO_GIA_KHAC_NHAU, NUOCSX 
FROM SANPHAM GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

-- 45. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.

SELECT TOP 10 MAKH FROM KHACHHANG KH ORDER BY DOANHSO DESC