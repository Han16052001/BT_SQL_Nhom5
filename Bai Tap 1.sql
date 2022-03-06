--CREATE DATABASE QLMUAHANG;
--USE QLMUAHANG;
--drop database QLMUAHANG
CREATE TABLE CUSTOMER (
       MaKH VARCHAR (10) PRIMARY KEY,
	   TenKH NVARCHAR (100),
	   Email VARCHAR (100),
	   SoDT VARCHAR (10),
	   DiaChi VARCHAR (100)
	  )
GO
CREATE TABLE PAYMENT (
       MaPTTT VARCHAR (10) PRIMARY KEY,
	   TenPhuongThucTT NVARCHAR (100),
	   PhiTT INT
	  )
GO
CREATE TABLE PRODUCT (
       MaSP VARCHAR (10) PRIMARY KEY,
	   TenSP NVARCHAR (100),
	   MoTa NVARCHAR(225),
	   GiaSP INT,
	   SoLuongSP INT,
	  )
GO
CREATE TABLE ORDERS (
       MaDH VARCHAR (10) PRIMARY KEY,
	   MaKH VARCHAR (10)
	   FOREIGN KEY (MaKH) REFERENCES CUSTOMER (MaKH),
	   MaPTTT VARCHAR (10),
	   FOREIGN KEY (MaPTTT) REFERENCES PAYMENT (MaPTTT),
	   NgayDat DATE,	
	   TrangThaiDatHang NVARCHAR(100),
	   TongTien INT
	   )
GO

CREATE TABLE ORDER_DETAIL (
       MaOD VARCHAR (10) PRIMARY KEY,
	   MaDH VARCHAR (10)
	   FOREIGN KEY(MaDH) REFERENCES ORDERS (MaDH),
	   MaSP VARCHAR (10),
	   FOREIGN KEY(MaSP) REFERENCES PRODUCT (MaSP),
	   SoLuong INT,
	   GiaSP INT ,
	   ThanhTien INT 	   
	  )
GO

INSERT INTO CUSTOMER VALUES  
--           MaKH        TenKH           Email            SoDT      DiaChi 
            ('KH0001', 'Bui Nhi',    'nhi@gmail.com',  09012345, 'Lien Chieu'),
			('KH0002', 'Bui Anh',    'anh@gmail.com',  09112345, 'Thanh Khe'),
			('KH0003', 'Nguyen Van', 'van@gmail.com',  09112346, 'Lien Chieu'),
			('KH0004', 'Nguyen Bao', 'bao@gmail.com',  09012346, 'Thanh Khe'),
			('KH0005', 'Bui Lan',    'lan@gmail.com',  09012347, 'Hai Chau'),
			('KH0006', 'Nguyen Tai', 'tai@gmail.com',  09112347, 'Hai Chau');
GO
INSERT INTO PAYMENT VALUES
--           MaPTTT   TenPhuongThucTT           PhiTT 
            ('TT001',  N'Visa',                 2000),
            ('TT002',  N'Banking',              1000),
            ('TT003',  N'MoMo',                 1000),
			('TT004',  N'Thanh toán trực tiếp', 50000);
GO
INSERT INTO PRODUCT VALUES
--           MaSP           TenSP                 MoTa             GiaSP  SoLuongSP 
            ('SP001',  N'Bánh bông lan cốt mềm',N'Bánh bông lan ', 55000,  20),
            ('SP002',  N'Bánh ngọt socola'  ,   N'Bánh ngọt',      200000, 10),
            ('SP003',  N'Bánh 2 tầng',          N'Bánh ngọt',      250000, 5);
GO 
INSERT INTO ORDERS VALUES
--            MaDH       MaKH     MaPTTT     NgayDat      TrangThaiDatHang  TongTien 
            ('DH0001', 'KH0002', 'TT001',  '2021-05-25',    N'Đã giao',     277000),
			('DH0002', 'KH0002', 'TT002',  '2022-01-01',    N'Đang giao',   331000),
			('DH0003', 'KH0001', 'TT004',  '2022-01-15',    N'Đã giao',     1050000),
			('DH0004', 'KH0005', 'TT003',  '2021-08-25',    N'Đã giao',     1501000),
			('DH0005', 'KH0004', 'TT003',  '2021-06-30',    N'Đang giao',   251000);
GO
INSERT INTO ORDER_DETAIL VALUES
--           MaOD     MaDH    MaSP  SoLuong GiaSP ThanhTien 
            ('OD001','DH0001','SP001', 5,   55000,  275000),
            ('OD002','DH0002','SP001', 6,   55000,  330000),
            ('OD003','DH0003','SP003', 4,  250000, 1000000),
			('OD004','DH0004','SP002', 6,  200000, 1500000),
            ('OD005','DH0005','SP003', 1,  250000,  250000);
GO 

---- 1 Tạo View (khung nhìn)
--1.1 Tạo khung nhìn có tên là KH_ThanhToanTT để xem thông tin của 
--tất cả khách hàng đã sử dụng phương thức thanh toán trực tiếp
CREATE VIEW KH_ThanhToanTT AS
SELECT KH.* FROM CUSTOMER KH
JOIN ORDERS OD
ON OD.MaKH = KH.MaKH
JOIN PAYMENT PM
ON PM.MaPTTT = OD.MaPTTT
WHERE PM.TenPhuongThucTT = N'Thanh toán trực tiếp'

SELECT * FROM KH_ThanhToanTT

----1.2 Tạo khung nhìn có tên là KH_DangGiao để xem thông tin của 
--khách hàng đã có trạng thái đặt hàng là đang giao
CREATE VIEW KH_DangGiao AS
SELECT KH.* FROM CUSTOMER KH
JOIN ORDERS OD
ON OD.MaKH = KH.MaKH
WHERE OD.TrangThaiDatHang = N'Đang giao'

SELECT * FROM KH_DangGiao

---- 2 Tạo PROCEDER (Thủ tục)
---- 2.1 Update du lieu khach hang
CREATE PROCEDURE Proc_Customer (
	@MaKH CHAR(50),
	@TenKH VARCHAR(50),
	@Email VARCHAR(50),
	@SoDT VARCHAR(50),
	@DiaChi VARCHAR(50)
)
AS
BEGIN
    SELECT *
	FROM dbo.CUSTOMER
	WHERE @MaKH = MaKH

	UPDATE dbo.CUSTOMER
	SET TenKH = @TenKH, Email = @Email, SoDT = @SoDT, DiaChi = @DiaChi
	WHERE MaKH = @MaKH
END
GO 
EXECUTE dbo.Proc_Customer @MaKH = 'KH0006',  -- char(50)
                          @TenKH = 'Nguyen Tai', -- varchar(50)
                          @Email = 'tai@gmail.com', -- varchar(50)
                          @SoDT = '9112347',  -- varchar(50)
                          @DiaChi = 'Cam Le' -- varchar(50)
 
SELECT * FROM dbo.CUSTOMER
GO 

---- 2.2 Delete san pham trong db
CREATE PROCEDURE Proc_DeProduct (
	@MaSP CHAR(50)
)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM dbo.PRODUCT WHERE MaSP = @MaSP)
	BEGIN
	    PRINT 'MaSP khong ton tai'
	END

	DELETE FROM dbo.PRODUCT
	WHERE MaSP = @MaSP
END
GO 
EXECUTE dbo.Proc_DeProduct @MaSP = 'SP005' -- char(50)
SELECT * FROM dbo.PRODUCT
GO 

---- 2.3 Thong ke tong so luong ban hàng cua 1 san pham bat ky
CREATE PROCEDURE Proc_TKProduct (
	@MaSP CHAR(50)
)
AS
BEGIN
    SELECT pd.MaSP, pd.TenSP, SUM(od.SoLuong) AS Total_Product
	FROM dbo.PRODUCT pd LEFT JOIN dbo.ORDER_DETAIL od
	ON od.MaSP = pd.MaSP
	WHERE pd.MaSP = @MaSP
	GROUP BY pd.MaSP, pd.TenSP
END
GO
EXECUTE dbo.Proc_TKProduct @MaSP = 'SP001' -- char(50)

SELECT * FROM dbo.PRODUCT
SELECT * FROM dbo.ORDER_DETAIL
--2.4 Tạo một SP có tên là Add_Order để thêm một bản ghi mới vào bảng order với điều kiện 
--phải thực hiện kiểm tra tính 
--hợp lệ của dữ liệu được bổ sung, với nguyên tắc là không được 
--trùng khóa chính và đảm bảo toàn vẹn dữ liệu tham chiếu đến
--các bảng có liên quan

create proc SP_AddOrder @MaDH VARCHAR (10),
					   @MaKH VARCHAR (10),
					   @MaPTTT VARCHAR (10),
					   @NgayDat DATE,	
					   @TrangThaiDatHang NVARCHAR(100),
					   @TongTien INT
as
begin
	--Ktra trung khoa chinh
	if exists (select *from ORDERS where MaDH=@MaDH) 
	begin	
		print 'Trung khoa chinh'
		return 
	end

	--Ktra su ton tai cua MaKH
	if not exists(select *from CUSTOMER where MaKH=@MaKH)
	begin
		print @MaKH + ' ' + 'Chua ton tai trong bang CUSTOMER'
		return
	end

	--Ktra su ton tai cua MaPTTT
	if not exists(select *from PAYMENT where MaPTTT=@MaPTTT)
	begin
		print @MaPTTT + ' ' + 'Chua ton tai trong bang PAYMENT'
		return
	end

	 INSERT INTO ORDERS VALUES
	( @MaDH, @MaKH, @MaPTTT, @NgayDat,@TrangThaiDatHang,@TongTien)
end
go

exec SP_AddOrder 'DH0006', 'KH0007', 'TT005',  '2021-05-25',    N'Đã giao',     277000
go

--2.5 Sử dụng Cursor để đưa các sản phẩm có mô tả là "Bánh ngọt" sẽ có giá sản phẩm đồng giá là 1000 
Declare BanhNgot1K cursor for select MoTa,GiaSP from dbo.PRODUCT

open BanhNgot1K

declare @MoTa NVARCHAR(225)
declare @GiaSP int

fetch next from BanhNgot1K into @MoTa, @GiaSP

while @@FETCH_STATUS=0
begin
	if @MoTa= N'Bánh ngọt'
	begin
		update dbo.PRODUCT set GiaSP=1000 where MoTa=@MoTa
	end

	fetch next from BanhNgot1K into @MoTa, @GiaSP
end
close BanhNgot1K
deallocate BanhNgot1K


select*from dbo.PRODUCT
---- 3 Tạo FUNCION (Hàm)
-- 3.1 Viết hàm trả về 1 bảng với các thông tin MaKH, TenKH,Email,SoDT,DiaChi của khách hàng có trong bảng ORDERS
create function udf_customer()
returns table as
return 
(
    select DISTINCT CUSTOMER.MaKH, TenKH,Email,SoDT,DiaChi  
	from dbo.CUSTOMER join dbo.ORDERS 
	on  CUSTOMER.MaKH = ORDERS.MaKH		
)

select * from dbo.udf_customer();

-- 3.2 Viết hàm trả về 1 giá trị những đơn hàng từ 1000000 trở lên
create function udf_hoadon
(
  @ThanhTien int
  )
  returns bit
  as 
  begin 
  declare @hoadon bit;
  if @ThanhTien >= 1000000
     set @hoadon =1 
	 else 
	 set @hoadon = 0;
	 return @hoadon;
  end

select * from 
(select *, dbo.udf_hoadon(ThanhTien) as HoaDon from ORDER_DETAIL ) as a
 where HoaDon = 1;
 -- 3.3 tạo hàm có tên UF_SELECTallCUSTOMR dùng để trả về bảng Customer để xem được tất cả thông tin của khách hàng
CREATE FUNCTION UF_SELECTallCUSTOMR()
RETURNS TABLE 
AS RETURN SELECT*FROM dbo.CUSTOMER
GO

SELECT*FROM UF_SELECTallCUSTOMR()