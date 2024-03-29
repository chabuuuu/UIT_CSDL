
-- Phan III (QLBH)

-- Cau 12
SELECT Distinct SOHD FROM CTHD 
WHERE (
    (MASP IN ('BB01', 'BB02')) AND (SL BETWEEN 10 AND 20)
)


-- Cau 13
SELECT Distinct SOHD FROM CTHD 
WHERE (
    (MASP = 'BB01') AND (SL BETWEEN 10 AND 20)
)
INTERSECT
SELECT Distinct SOHD FROM CTHD 
WHERE (
    (MASP = 'BB02') AND (SL BETWEEN 10 AND 20)
)


-- Cau 14
SET DATEFORMAT DMY
SELECT DISTINCT SP.MASP, TENSP 
FROM SANPHAM SP, HOADON HD, CTHD 
WHERE (
    HD.SOHD = CTHD.SOHD AND CTHD.MASP = SP.MASP AND
    (NUOCSX = 'Trung Quoc' OR NGHD = '1/1/2007')
)

-- Cau 15
--Cach 1:
SELECT MASP, TENSP 
FROM SANPHAM
EXCEPT 
(SELECT SP.MASP, TENSP FROM SANPHAM SP, CTHD WHERE
    SP.MASP = CTHD.MASP
)


--Cach 2:
SELECT MASP, TENSP FROM SANPHAM 
WHERE (
    MASP NOT IN (SELECT MASP FROM CTHD)
)

-- Cau 16

-- Cach 1:
SELECT MASP, TENSP 
FROM SANPHAM
EXCEPT 
(SELECT SP.MASP, TENSP FROM SANPHAM SP, CTHD, HOADON HD WHERE
    SP.MASP = CTHD.MASP AND CTHD.SOHD = HD.SOHD AND YEAR(NGHD) = 2006
)

-- Cach 2:
SELECT MASP, TENSP FROM SANPHAM 
WHERE (
    MASP NOT IN (SELECT MASP FROM CTHD CT, HOADON HD WHERE
        (
            CT.SOHD = HD.SOHD AND YEAR(NGHD) = 2006
        )
    )
)

-- Cau 17
SELECT MASP, TENSP FROM SANPHAM 
WHERE (
    MASP NOT IN (SELECT MASP FROM CTHD CT, HOADON HD WHERE
        (
            CT.SOHD = HD.SOHD AND YEAR(NGHD) = 2006
        )
    )
    AND NUOCSX = 'Trung Quoc'
)

-- Cau 18

SELECT HD.SOHD
FROM HOADON HD
WHERE NOT EXISTS (
    SELECT *
    FROM SANPHAM SP
    WHERE NUOCSX = 'Singapore' AND NOT EXISTS (
        SELECT * 
        FROM CTHD CT
        WHERE CT.MASP = SP.MASP AND CT.SOHD = HD.SOHD))

-- Cau 19
SELECT HD.SOHD
FROM HOADON HD
WHERE YEAR(NGHD) = 2006 AND NOT EXISTS (
    SELECT *
    FROM SANPHAM SP
    WHERE NUOCSX = 'Singapore' AND NOT EXISTS (
        SELECT * 
        FROM CTHD CT
        WHERE CT.MASP = SP.MASP AND CT.SOHD = HD.SOHD))
