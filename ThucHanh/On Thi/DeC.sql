--cau 3--
....check (LOAIKH = 'Vip' AND GIAMGIA = 10)
			OR (LOAIKH != 'Vip')

--Cau 4--

--Bang rang buoc:
-------------------------------------
--|         THEM   |  XOA  |  SUA     |
--|HOPDONG|   -    |  -(*) | + (NGKT) |
--|CTHD   |   +    |   -   | +(NGSD)  |


-- Cau 6--
SELECT TENDV, GIA
FROM DICHVU DV, CTHD CT
WHERE ...
GROUP BY ...
HAVING COUNT(SOHD) <= ALL (
	SELECT COUNT(SOHD)
	FROM CTHD
	WHERE YEAR(NGHD) = 2018
	GROUP BY MADV
)