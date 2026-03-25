/****** Object:  Table [dbo].[Clientes]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[Num_Cli] [int] NOT NULL,
	[Empresa] [varchar](20) NOT NULL,
	[Rep_Cli] [int] NULL,
	[Limite_Credito] [money] NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[Num_Cli] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Oficinas]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Oficinas](
	[Oficina] [int] NOT NULL,
	[Ciudad] [varchar](15) NOT NULL,
	[Region] [varchar](10) NOT NULL,
	[Jef] [int] NULL,
	[Objetivo] [money] NULL,
	[Ventas] [money] NOT NULL,
 CONSTRAINT [PK_Oficinas] PRIMARY KEY CLUSTERED 
(
	[Oficina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pedidos]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pedidos](
	[Num_Pedido] [int] NOT NULL,
	[Fecha_Pedido] [date] NOT NULL,
	[Cliente] [int] NOT NULL,
	[Rep] [int] NULL,
	[Fab] [char](3) NOT NULL,
	[Producto] [char](5) NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Importe] [money] NOT NULL,
 CONSTRAINT [PK_Pedidos] PRIMARY KEY CLUSTERED 
(
	[Num_Pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Productos]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
	[Id_fab] [char](3) NOT NULL,
	[Id_producto] [char](5) NOT NULL,
	[Descripcion] [varchar](20) NOT NULL,
	[Precio] [money] NOT NULL,
	[Stock] [int] NOT NULL,
 CONSTRAINT [PK_Productos] PRIMARY KEY CLUSTERED 
(
	[Id_fab] ASC,
	[Id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Representantes]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Representantes](
	[Num_Empl] [int] NOT NULL,
	[Nombre] [varchar](16) NOT NULL,
	[Edad] [int] NULL,
	[Oficina_Rep] [int] NULL,
	[Puesto] [varchar](13) NULL,
	[Fecha_Contrato] [date] NOT NULL,
	[Jefe] [int] NULL,
	[Cuota] [money] NULL,
	[Ventas] [money] NOT NULL,
 CONSTRAINT [PK_Representantes] PRIMARY KEY CLUSTERED 
(
	[Num_Empl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2101, N'Jerandilla Ltd', 106, 65000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2102, N'Filas', 101, 65000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2103, N'Acme', 105, 50000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2105, N'AAA Inversiones', 101, 45000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2106, N'F. Lopez S.A', 102, 65000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2107, N'Ace internacional', 110, 35000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2108, N'Henche & López', 109, 55000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2109, N'Chen Asociados', 103, 25000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2111, N'JCP S.A.', 103, 50000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2112, N'Zeta Producciones', 108, 50000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2113, N'Íbero & Sagaz', 104, 20000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2114, N'Orión Ltd.', 102, 20000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2115, N'Sierras S.A', 101, 20000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2117, N'J. P. Sotoca', 106, 35000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2118, N'Mejorada Sistemas', 108, 60000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2119, N'Salomón S.A', 109, 25000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2120, N'Rico S.A', 102, 50000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2121, N'QMA Asociados', 103, 45000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2122, N'Toledo S.A', 105, 30000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2123, N'Cruz e hijos', 102, 40000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2124, N'Pascual Hermanos', 107, 40000.0000)
INSERT [dbo].[Clientes] ([Num_Cli], [Empresa], [Rep_Cli], [Limite_Credito]) VALUES (2125, N'La Cucaracha', 109, 55000.0000)
GO
INSERT [dbo].[Oficinas] ([Oficina], [Ciudad], [Region], [Jef], [Objetivo], [Ventas]) VALUES (11, N'Navarra', N'Este', 106, 575000.0000, 692637.0000)
INSERT [dbo].[Oficinas] ([Oficina], [Ciudad], [Region], [Jef], [Objetivo], [Ventas]) VALUES (12, N'Castellón ', N'Este', 104, 800000.0000, 735042.0000)
INSERT [dbo].[Oficinas] ([Oficina], [Ciudad], [Region], [Jef], [Objetivo], [Ventas]) VALUES (13, N'Almería', N'Este', 105, 350000.0000, 367911.0000)
INSERT [dbo].[Oficinas] ([Oficina], [Ciudad], [Region], [Jef], [Objetivo], [Ventas]) VALUES (21, N'León', N'Oeste', 108, 745000.0000, 835915.0000)
INSERT [dbo].[Oficinas] ([Oficina], [Ciudad], [Region], [Jef], [Objetivo], [Ventas]) VALUES (22, N'Daimiel', N'Oeste', 108, 300000.0000, 186042.0000)
GO
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112961, CAST(N'1989-12-17' AS Date), 2117, 106, N'REI', N'2A44L', 7, 31500.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112963, CAST(N'1989-12-17' AS Date), 2103, 105, N'ACI', N'41004', 28, 3276.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112975, CAST(N'1989-10-10' AS Date), 2111, 103, N'REI', N'2A44G', 6, 2100.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112979, CAST(N'1989-10-10' AS Date), 2114, 102, N'ACI', N'4100Z', 6, 15000.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112983, CAST(N'1989-12-27' AS Date), 2103, 105, N'ACI', N'41004', 6, 702.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112987, CAST(N'1989-12-31' AS Date), 2103, 105, N'ACI', N'4100Y', 11, 27500.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112989, CAST(N'1990-01-03' AS Date), 2101, 106, N'FEA', N'114  ', 6, 1458.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112992, CAST(N'1989-11-04' AS Date), 2118, 108, N'ACI', N'41002', 10, 760.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112993, CAST(N'1989-01-04' AS Date), 2106, 102, N'REI', N'2A45C', 24, 1896.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (112997, CAST(N'1990-01-08' AS Date), 2124, 107, N'BIC', N'41003', 1, 652.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113003, CAST(N'1990-01-25' AS Date), 2108, 109, N'IMM', N'779C ', 3, 5625.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113007, CAST(N'1990-01-08' AS Date), 2112, 108, N'IMM', N'773C ', 3, 2925.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113012, CAST(N'1990-01-11' AS Date), 2111, 105, N'ACI', N'41003', 35, 3745.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113013, CAST(N'1990-01-14' AS Date), 2118, 108, N'BIC', N'41003', 1, 652.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113024, CAST(N'1990-01-20' AS Date), 2114, 108, N'QSA', N'XK47 ', 20, 7100.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113027, CAST(N'1990-01-22' AS Date), 2103, 105, N'ACI', N'41002', 54, 4104.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113034, CAST(N'1990-01-29' AS Date), 2107, 110, N'REI', N'2A45C', 8, 632.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113042, CAST(N'1990-02-02' AS Date), 2113, 101, N'REI', N'2A44R', 5, 22500.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113045, CAST(N'1990-02-02' AS Date), 2112, 108, N'REI', N'2A44R', 10, 45000.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113048, CAST(N'1990-02-10' AS Date), 2120, 102, N'IMM', N'779C ', 2, 3750.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113049, CAST(N'1990-02-10' AS Date), 2118, 108, N'QSA', N'XK47 ', 2, 776.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113051, CAST(N'1990-02-10' AS Date), 2118, 108, N'QSA', N'XK47 ', 4, 1420.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113055, CAST(N'1990-02-15' AS Date), 2108, 101, N'ACI', N'4100X', 6, 150.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113057, CAST(N'1990-02-18' AS Date), 2111, 103, N'ACI', N'4100X', 24, 600.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113058, CAST(N'1990-02-23' AS Date), 2108, 109, N'FEA', N'112  ', 10, 1480.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113062, CAST(N'1990-02-24' AS Date), 2124, 107, N'FEA', N'114  ', 10, 2430.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113065, CAST(N'1990-02-27' AS Date), 2106, 102, N'QSA', N'XK47 ', 6, 2130.0000)
INSERT [dbo].[Pedidos] ([Num_Pedido], [Fecha_Pedido], [Cliente], [Rep], [Fab], [Producto], [Cantidad], [Importe]) VALUES (113069, CAST(N'1990-03-02' AS Date), 2109, 107, N'IMM', N'775C ', 22, 31350.0000)
GO
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'ACI', N'41001', N'Serie 1, cable', 55.0000, 277)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'ACI', N'41002', N'Serie 2, cable', 76.0000, 167)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'ACI', N'41003', N'Serie 3, cable', 7.0000, 207)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'ACI', N'41004', N'Serie 4. cable', 117.0000, 139)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'ACI', N'4100X', N'Zapata Grande', 25.0000, 37)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'ACI', N'4100Y', N'Zapata Pequeña', 2750.0000, 25)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'ACI', N'4100Z', N'Zapata Mediana', 2500.0000, 28)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'BIC', N'41003', N'Hélice', 652.0000, 3)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'BIC', N'41089', N'Retén ', 225.0000, 78)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'BIC', N'41672', N'Plato', 180.0000, 0)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'FEA', N'112  ', N'Huso', 148.0000, 115)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'FEA', N'114  ', N'Montura del Motor', 243.0000, 15)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'IMM', N'773C ', N'30 - kg brazo', 975.0000, 28)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'IMM', N'775C ', N'50-kg brazo', 1425.0000, 5)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'IMM', N'779C ', N'90- kg brazo', 1875.0000, 9)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'IMM', N'887H ', N'Barrilete', 54.0000, 223)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'IMM', N'887P ', N'Bulón ', 250.0000, 24)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'IMM', N'887X ', N'Brazo retén ', 475.0000, 32)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'QSA', N'XK47 ', N'Reductora', 355.0000, 38)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'QSA', N'XK48 ', N'Reductora', 134.0000, 203)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'QSA', N'XK48A', N'Reducción', 177.0000, 37)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'REI', N'2A44G', N'Hilo de Cobre', 350.0000, 14)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'REI', N'2A44L', N'Llave', 4500.0000, 12)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'REI', N'2A44R', N'Riostra', 4500.0000, 12)
INSERT [dbo].[Productos] ([Id_fab], [Id_producto], [Descripcion], [Precio], [Stock]) VALUES (N'REI', N'2A45C', N'Rueda', 79.0000, 210)
GO
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (101, N'Daniel Ruidrobo', 45, 12, N'Representante', CAST(N'1986-10-20' AS Date), 104, 300000.0000, 305673.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (102, N'Susana Santos', 48, 21, N'Representante', CAST(N'1986-12-10' AS Date), NULL, 350000.0000, 474050.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (103, N'Pablo Cruz', 29, 12, N'Representante', CAST(N'1987-03-01' AS Date), 104, 275000.0000, 286775.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (104, N'Bernardo Sánchez', 33, 12, N'Jefe Ventas', CAST(N'1987-05-19' AS Date), 106, 200000.0000, 142594.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (105, N'Bruno Arteaga', 37, 13, N'Representante', CAST(N'1988-02-12' AS Date), 104, 350000.0000, 367911.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (106, N'Samuel Clavel', 52, 11, N'VP Ventas', CAST(N'1988-06-14' AS Date), NULL, 275000.0000, 299912.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (107, N'Neus Azcárate', 49, 22, N'Representante', CAST(N'1988-11-14' AS Date), 108, 300000.0000, 186042.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (108, N'León Freire', 62, 21, N'Jefe Ventas', CAST(N'1989-10-12' AS Date), 106, 350000.0000, 361865.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (109, N'María Jiménez', 31, 11, N'Representante', CAST(N'1989-10-12' AS Date), 106, 320000.0000, 392725.0000)
INSERT [dbo].[Representantes] ([Num_Empl], [Nombre], [Edad], [Oficina_Rep], [Puesto], [Fecha_Contrato], [Jefe], [Cuota], [Ventas]) VALUES (110, N'Tomás Saz', 41, NULL, N'Representante', CAST(N'1990-01-13' AS Date), 101, NULL, 75985.0000)
GO
ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD  CONSTRAINT [FK_Clientes_Representantes] FOREIGN KEY([Rep_Cli])
REFERENCES [dbo].[Representantes] ([Num_Empl])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Clientes] CHECK CONSTRAINT [FK_Clientes_Representantes]
GO
ALTER TABLE [dbo].[Oficinas]  WITH CHECK ADD  CONSTRAINT [FK_Oficinas_Representantes] FOREIGN KEY([Jef])
REFERENCES [dbo].[Representantes] ([Num_Empl])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Oficinas] CHECK CONSTRAINT [FK_Oficinas_Representantes]
GO
ALTER TABLE [dbo].[Pedidos]  WITH CHECK ADD  CONSTRAINT [FK_Pedidos_Clientes] FOREIGN KEY([Cliente])
REFERENCES [dbo].[Clientes] ([Num_Cli])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Clientes]
GO
ALTER TABLE [dbo].[Pedidos]  WITH CHECK ADD  CONSTRAINT [FK_Pedidos_Productos] FOREIGN KEY([Fab], [Producto])
REFERENCES [dbo].[Productos] ([Id_fab], [Id_producto])
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Productos]
GO
ALTER TABLE [dbo].[Pedidos]  WITH CHECK ADD  CONSTRAINT [FK_Pedidos_Representantes] FOREIGN KEY([Rep])
REFERENCES [dbo].[Representantes] ([Num_Empl])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Representantes]
GO
ALTER TABLE [dbo].[Representantes]  WITH CHECK ADD  CONSTRAINT [FK_Representantes_Oficinas] FOREIGN KEY([Oficina_Rep])
REFERENCES [dbo].[Oficinas] ([Oficina])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Representantes] CHECK CONSTRAINT [FK_Representantes_Oficinas]
GO
ALTER TABLE [dbo].[Representantes]  WITH CHECK ADD  CONSTRAINT [FK_Representantes_Representantes] FOREIGN KEY([Jefe])
REFERENCES [dbo].[Representantes] ([Num_Empl])
GO
ALTER TABLE [dbo].[Representantes] CHECK CONSTRAINT [FK_Representantes_Representantes]
GO
/****** Object:  StoredProcedure [dbo].[agregarCliente]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[agregarCliente]
@num_cli int, @empresa varchar(20),@limite_credito money,
@obj_ventas money, @repre int, @ofi_ciudad varchar(15)
As
 begin
    /*Agrega Cliente*/
	INSERT INTO CLIENTES (Num_Cli,Empresa,Rep_Cli,Limite_Credito)
	VALUES (@num_cli,@empresa,@repre,@limite_credito)
	
	/*Actualiza el representante solicitado*/
	UPDATE REPRESENTANTES 
	SET CUOTA = CUOTA + @obj_ventas
	WHERE num_empl = @repre
	
	/*Actualiza la oficina solicitada*/
	UPDATE OFICINAS
	SET Objetivo = objetivo + @obj_ventas
	where ciudad = @ofi_ciudad
 end
   
GO
/****** Object:  StoredProcedure [dbo].[agregarClientee]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[agregarClientee]
@num_cli int, @empresa varchar(20),@limite_credito money,
@obj_ventas money, @repre int, @ofi_ciudad varchar(15)
As
 begin
    /*Agrega Cliente*/
	INSERT INTO CLIENTES (Num_Cli,Empresa,Rep_Cli,Limite_Credito)
	VALUES (@num_cli,@empresa,@repre,@limite_credito)
	
	/*Actualiza el representante solicitado*/
	UPDATE REPRESENTANTES 
	SET CUOTA = CUOTA + @obj_ventas
	WHERE num_empl = @repre
	
	/*Actualiza la oficina solicitada*/
	UPDATE OFICINAS
	SET Objetivo = objetivo + @obj_ventas
	where ciudad = @ofi_ciudad
 end
GO
/****** Object:  StoredProcedure [dbo].[ConsultaGeneral]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[ConsultaGeneral]
As

begin 
	select * from Oficinas;
end
GO
/****** Object:  StoredProcedure [dbo].[consultaOficinasRegion]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[consultaOficinasRegion]
@region varchar(10)
As
begin
select ciudad, region, objetivo, ventas
from Oficinas 
where Region = @region;
end
GO
/****** Object:  StoredProcedure [dbo].[Verificarpedidos]    Script Date: 26/02/2026 09:09:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Verificarpedidos]
@fechainicial date, @fechafinal date 
as
begin
select num_pedido, Fecha_pedido, fab, Producto, importe
from Pedidos
where Fecha_Pedido between @fechainicial
and @fechafinal;
end
GO
USE [master]
GO
ALTER DATABASE [BDEJEMPLO2] SET  READ_WRITE 
GO