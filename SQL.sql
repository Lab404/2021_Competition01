USE [master]
GO
/****** Object:  Database [DepChatBot2]    Script Date: 2021/5/12 下午 04:05:33 ******/
CREATE DATABASE [DepChatBot2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DepChatBot2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DepChatBot2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DepChatBot2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DepChatBot2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [DepChatBot2] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DepChatBot2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DepChatBot2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DepChatBot2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DepChatBot2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DepChatBot2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DepChatBot2] SET ARITHABORT OFF 
GO
ALTER DATABASE [DepChatBot2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DepChatBot2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DepChatBot2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DepChatBot2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DepChatBot2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DepChatBot2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DepChatBot2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DepChatBot2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DepChatBot2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DepChatBot2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DepChatBot2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DepChatBot2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DepChatBot2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DepChatBot2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DepChatBot2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DepChatBot2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DepChatBot2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DepChatBot2] SET RECOVERY FULL 
GO
ALTER DATABASE [DepChatBot2] SET  MULTI_USER 
GO
ALTER DATABASE [DepChatBot2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DepChatBot2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DepChatBot2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DepChatBot2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DepChatBot2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DepChatBot2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DepChatBot2', N'ON'
GO
ALTER DATABASE [DepChatBot2] SET QUERY_STORE = OFF
GO
USE [DepChatBot2]
GO
/****** Object:  Table [dbo].[Case_Socialworker]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Case_Socialworker](
	[Case_Id] [int] IDENTITY(1,1) NOT NULL,
	[AssistClass] [int] NULL,
	[Student_id] [int] NULL,
	[Socialworker_id] [int] NULL,
	[Case_content] [nvarchar](max) NULL,
	[Case_requestTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Case_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Case_Student]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Case_Student](
	[Case_Id] [int] IDENTITY(1,1) NOT NULL,
	[AssistClass] [int] NULL,
	[Student_id] [int] NULL,
	[Socialworker_id] [int] NULL,
	[Case_content] [nvarchar](max) NULL,
	[Case_requestTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Case_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Record]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Record](
	[Case_Id] [int] IDENTITY(1,1) NOT NULL,
	[AssistClass] [int] NULL,
	[Socialworker_Id] [int] NULL,
	[Student_Id] [int] NULL,
	[Student_content] [nvarchar](max) NULL,
	[Student_requestTime] [datetime] NULL,
	[Socialworker_content] [nvarchar](max) NULL,
	[Socialworker_RequestTime] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Case_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SatisfactionRequest]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SatisfactionRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SocialWorker_id] [int] NULL,
	[Student_id] [int] NULL,
	[AssistClass] [int] NULL,
	[Satisfaction] [int] NULL,
	[Attitude] [int] NULL,
	[AssistTime] [int] NULL,
	[Profession] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Scale]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Scale](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Student_Id] [int] NULL,
	[Scale_total] [int] NULL,
	[RequestTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[School]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[School](
	[School_Id] [int] IDENTITY(1,1) NOT NULL,
	[School_name] [nvarchar](50) NULL,
	[School_address] [nvarchar](50) NULL,
	[School_phnumber] [nvarchar](50) NULL,
	[School_manager] [nvarchar](50) NULL,
	[School_account] [nvarchar](50) NULL,
	[School_password] [nvarchar](50) NULL,
	[Identifier] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[School_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Service]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User] [varchar](50) NOT NULL,
	[SearchWiki] [varchar](50) NOT NULL,
	[Short_Service] [varchar](50) NOT NULL,
	[Report_Service] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Short_record]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Short_record](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User] [varchar](50) NULL,
	[SocialWoker_ID] [varchar](50) NULL,
	[Context] [varchar](50) NULL,
	[Date] [varchar](50) NULL,
	[Topic] [varchar](50) NULL,
	[Word_nm] [varchar](50) NULL,
 CONSTRAINT [PK__Short_re__3214EC278184EBE8] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Short_record2]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Short_record2](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User] [varchar](50) NOT NULL,
	[SocialWoker_ID] [varchar](50) NOT NULL,
	[Context] [varchar](5000) NOT NULL,
	[Date] [varchar](500) NOT NULL,
	[Topic] [varchar](50) NOT NULL,
	[Word_nm] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShortFeedback]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShortFeedback](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Socialworker_Id] [int] NOT NULL,
	[Judgment_Score] [int] NULL,
	[Student_Id] [int] NULL,
	[Assist] [int] NULL,
	[CaseID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Socialworker]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Socialworker](
	[Socialworker_Id] [int] IDENTITY(1,1) NOT NULL,
	[Socialworker_Email] [nvarchar](50) NULL,
	[School_id] [int] NULL,
	[Socialworker_name] [nvarchar](50) NULL,
	[Socialworker_gender] [int] NULL,
	[Socialworker_birthday] [date] NULL,
	[Socialworker_IDnumber] [nvarchar](50) NULL,
	[Socialworker_AuthCode] [nvarchar](50) NULL,
	[Socialworker_account] [nvarchar](50) NULL,
	[Socialworker_password] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Socialworker_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[Student_Id] [int] IDENTITY(1,1) NOT NULL,
	[School_id] [int] NULL,
	[Student_token] [nvarchar](max) NULL,
	[Student_Email] [nvarchar](50) NULL,
	[Student_name] [nvarchar](50) NULL,
	[Student_gender] [int] NULL,
	[Student_birthday] [nvarchar](50) NULL,
	[Student_guardian_name] [nvarchar](50) NULL,
	[Student_guardian_phnumber] [nvarchar](50) NULL,
	[Student_teacher] [nvarchar](50) NULL,
	[Student_class] [nvarchar](50) NULL,
	[Student_IDNumber] [nvarchar](50) NULL,
	[Socialworker_id] [int] NULL,
	[Student_userID] [nvarchar](50) NULL,
	[Counseling] [int] NULL,
	[LineId] [nvarchar](max) NULL,
 CONSTRAINT [PK__Student__A2F4E98C704A0A37] PRIMARY KEY CLUSTERED 
(
	[Student_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[Start_date] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserTest]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserTest](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[uid] [varchar](50) NOT NULL,
	[event] [varchar](500) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Verification]    Script Date: 2021/5/12 下午 04:05:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Verification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[School_Id] [int] NULL,
	[Socialworker_Id] [int] NULL,
	[Verification] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Record] ON 

INSERT [dbo].[Record] ([Case_Id], [AssistClass], [Socialworker_Id], [Student_Id], [Student_content], [Student_requestTime], [Socialworker_content], [Socialworker_RequestTime]) VALUES (1, 0, 1, 9, N'132456', CAST(N'2021-01-27T15:39:00.000' AS DateTime), N'121312313', NULL)
INSERT [dbo].[Record] ([Case_Id], [AssistClass], [Socialworker_Id], [Student_Id], [Student_content], [Student_requestTime], [Socialworker_content], [Socialworker_RequestTime]) VALUES (2, 0, 1, 9, N'test', CAST(N'2021-02-04T00:19:00.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Record] ([Case_Id], [AssistClass], [Socialworker_Id], [Student_Id], [Student_content], [Student_requestTime], [Socialworker_content], [Socialworker_RequestTime]) VALUES (3, 0, 1, 9, N'Test2', CAST(N'2021-02-04T00:47:00.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Record] ([Case_Id], [AssistClass], [Socialworker_Id], [Student_Id], [Student_content], [Student_requestTime], [Socialworker_content], [Socialworker_RequestTime]) VALUES (4, 0, 1, 9, N'Test3', CAST(N'2021-02-04T00:50:00.000' AS DateTime), N'Heelleoel', CAST(N'2021-02-04T15:17:00.0000000' AS DateTime2))
INSERT [dbo].[Record] ([Case_Id], [AssistClass], [Socialworker_Id], [Student_Id], [Student_content], [Student_requestTime], [Socialworker_content], [Socialworker_RequestTime]) VALUES (5, 0, 1, 9, N'Testt', CAST(N'2021-02-08T21:20:00.000' AS DateTime), N'Hello World', CAST(N'2021-02-20T21:29:00.0000000' AS DateTime2))
INSERT [dbo].[Record] ([Case_Id], [AssistClass], [Socialworker_Id], [Student_Id], [Student_content], [Student_requestTime], [Socialworker_content], [Socialworker_RequestTime]) VALUES (6, 0, 1, 9, N'Grgf', CAST(N'2021-02-08T21:26:00.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Record] ([Case_Id], [AssistClass], [Socialworker_Id], [Student_Id], [Student_content], [Student_requestTime], [Socialworker_content], [Socialworker_RequestTime]) VALUES (7, 0, 1, 9, N'Gdgd', CAST(N'2021-02-08T21:30:00.000' AS DateTime), N'TESR123', CAST(N'2021-02-20T18:39:00.0000000' AS DateTime2))
INSERT [dbo].[Record] ([Case_Id], [AssistClass], [Socialworker_Id], [Student_Id], [Student_content], [Student_requestTime], [Socialworker_content], [Socialworker_RequestTime]) VALUES (8, 0, 1, 9, N'Test222', CAST(N'2021-02-09T16:04:00.000' AS DateTime), N'12345', CAST(N'2021-02-20T18:25:00.0000000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Record] OFF
GO
SET IDENTITY_INSERT [dbo].[Scale] ON 

INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (1, 3, -18, CAST(N'2021-02-02T01:15:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (2, 3, -18, CAST(N'2021-02-02T01:18:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (3, 3, -18, CAST(N'2021-02-02T01:26:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (4, 3, -18, CAST(N'2021-02-02T01:33:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (5, 3, -18, CAST(N'2021-02-02T01:45:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (6, 3, -18, CAST(N'2021-02-02T01:54:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (7, 3, -18, CAST(N'2021-02-02T01:56:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (8, 3, -18, CAST(N'2021-02-02T14:43:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (9, 3, -18, CAST(N'2021-02-02T14:48:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (10, 3, -18, CAST(N'2021-02-02T14:51:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (11, 3, -18, CAST(N'2021-02-02T14:52:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (12, 3, -18, CAST(N'2021-02-02T14:53:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (13, 3, -16, CAST(N'2021-02-02T14:59:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (14, 3, -18, CAST(N'2021-02-02T16:48:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (15, 3, -18, CAST(N'2021-02-02T16:49:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (16, 9, -18, CAST(N'2021-02-04T00:59:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (17, 9, -18, CAST(N'2021-02-04T01:00:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (18, 9, -18, CAST(N'2021-02-04T01:00:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (19, 9, -18, CAST(N'2021-02-04T01:01:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (20, 9, -18, CAST(N'2021-02-04T01:02:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (21, 9, -18, CAST(N'2021-02-04T01:03:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (22, 9, -18, CAST(N'2021-02-04T01:06:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (23, 9, -18, CAST(N'2021-02-04T01:12:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (24, 9, -18, CAST(N'2021-02-08T20:57:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (25, 9, -18, CAST(N'2021-02-08T20:59:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (26, 9, -18, CAST(N'2021-02-08T21:00:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (27, 9, -18, CAST(N'2021-02-08T21:05:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (28, 9, -18, CAST(N'2021-02-08T21:10:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (29, 9, -18, CAST(N'2021-02-09T15:58:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (30, 9, -18, CAST(N'2021-02-09T16:00:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (31, 9, -18, CAST(N'2021-02-20T15:02:00.000' AS DateTime))
INSERT [dbo].[Scale] ([Id], [Student_Id], [Scale_total], [RequestTime]) VALUES (32, 9, -18, CAST(N'2021-02-20T15:03:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Scale] OFF
GO
SET IDENTITY_INSERT [dbo].[School] ON 

INSERT [dbo].[School] ([School_Id], [School_name], [School_address], [School_phnumber], [School_manager], [School_account], [School_password], [Identifier]) VALUES (1, N'國立虎尾科技大學', N' 632雲林縣虎尾鎮文化路64號', N'05 631 5000', N'覺文郁', N'a123', N'a123', N'123456')
SET IDENTITY_INSERT [dbo].[School] OFF
GO
SET IDENTITY_INSERT [dbo].[Service] ON 

INSERT [dbo].[Service] ([ID], [User], [SearchWiki], [Short_Service], [Report_Service]) VALUES (7, N'2', N'0', N'0', N'0')
INSERT [dbo].[Service] ([ID], [User], [SearchWiki], [Short_Service], [Report_Service]) VALUES (9, N'9', N'0', N'0', N'0')
INSERT [dbo].[Service] ([ID], [User], [SearchWiki], [Short_Service], [Report_Service]) VALUES (10, N'4', N'1', N'0', N'0')
INSERT [dbo].[Service] ([ID], [User], [SearchWiki], [Short_Service], [Report_Service]) VALUES (11, N'5', N'1', N'0', N'0')
INSERT [dbo].[Service] ([ID], [User], [SearchWiki], [Short_Service], [Report_Service]) VALUES (12, N'56', N'1', N'0', N'0')
INSERT [dbo].[Service] ([ID], [User], [SearchWiki], [Short_Service], [Report_Service]) VALUES (13, N'7', N'1', N'0', N'0')
SET IDENTITY_INSERT [dbo].[Service] OFF
GO
SET IDENTITY_INSERT [dbo].[Short_record] ON 

INSERT [dbo].[Short_record] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (1, N'2', N'', N'測試2測試3', N'2021年1月25日', N'', N'2')
INSERT [dbo].[Short_record] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (2, N'2', N'', N'最近台灣的疫情好像又變嚴重了', N'2021年1月25日', N'', N'1')
INSERT [dbo].[Short_record] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (3, N'2', N'', N'最近台灣的疫情又變嚴重了', N'2021年1月25日', N'', N'1')
SET IDENTITY_INSERT [dbo].[Short_record] OFF
GO
SET IDENTITY_INSERT [dbo].[Short_record2] ON 

INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (1, N'2', N'', N'最近台灣的疫情又變嚴重了可能是因為境外移入的病患變多了', N'2021年1月26日', N'COVID', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (2, N'9', N'', N'', N'2021年2月4日', N'', N'0')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (3, N'9', N'', N'', N'2021年2月9日', N'', N'0')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (4, N'9', N'', N'最近工作壓力很大', N'2021年2月9日', N'', N'1')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (5, N'9', N'', N'最近工作壓力很大老闆最近給我的工作量很多 我又不是很喜歡做上次有一個客戶說要做網頁老闆又很我行我素 我只能配合他最後老闆說要自己想辦法我也就只能盡量在時間內完成 但是好累', N'2021年2月9日', N'工作', N'6')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (6, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做常常加班到很晚才回家', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (7, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (8, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做常常加班到很晚才回家', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (9, N'9', N'', N'常常加班到很晚才回家常常加班到很晚才回家最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'4')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (10, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (11, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (12, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (13, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (14, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (15, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (16, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (17, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (18, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (19, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (20, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (21, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (22, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (23, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (24, N'9', N'', N'最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月10日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (25, N'9', N'', N'最近工作壓力好大 工作量比較多可能是因為過年期間人力短缺 常常需要我們加班最近工作壓力好大 老闆常常弄一堆事情叫我做最近工作壓力好大 老闆常常弄一堆事情叫我做', N'2021年2月15日', N'工作', N'4')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (26, N'9', N'', N'最近工作壓力好大。老闆都叫我做很多事情可能是因為最近案子比較多，客戶的需求也比較廣', N'2021年2月15日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (27, N'9', N'', N'最近工作壓力好大。老闆都叫我做很多事情可能是因為最近案子比較多，客戶的需求也比較廣', N'2021年2月15日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (28, N'9', N'', N'最近工作壓力好大。老闆都叫我做很多事情可能是因為最近案子比較多，客戶的需求也比較廣', N'2021年2月15日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (29, N'9', N'', N'最近工作壓力好大。老闆都叫我做很多事情可能是因為最近案子比較多，客戶的需求也比較廣', N'2021年2月15日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (30, N'9', N'', N'最近工作壓力好大。老闆都叫我做很多事情可能是因為最近案子比較多，客戶的需求也比較廣', N'2021年2月15日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (31, N'9', N'', N'最近工作壓力好大。老闆都叫我做很多事情可能是因為最近案子比較多，客戶的需求也比較廣', N'2021年2月15日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (32, N'9', N'', N'最近工作壓力好大。老闆都叫我做很多事情可能是因為最近案子比較多，客戶的需求也比較廣', N'2021年2月15日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (33, N'9', N'', N'最近工作壓力好大。老闆都叫我做很多事情可能是因為最近案子比較多，客戶的需求也比較廣', N'2021年2月15日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (34, N'9', N'', N'最近要開學了 壓力好大不知道和同學相處會不會融洽 好緊張到一個新的環境要重新適應真的很恐怖希望新的同學可以跟我好好相處', N'2021年2月15日', N'', N'4')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (35, N'9', N'', N'明天就要開學了好緊張 不知道新同學好不好相處踏入新環境感覺好緊張 希望可以多交到幾個好朋友', N'2021年2月15日', N'', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (37, N'9', N'', N'最近和女友常常因為做愛的問題爭吵有時候下班回家很累了 他還是想做愛 甚至自己騎上來但是我還是很喜歡跟他做愛 我們不只在床上', N'2021年2月15日', N'', N'3')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (38, N'9', N'', N'最近換了一個工作，同事間感覺很多摩擦，老闆對我的態度也不好，但是又不敢換工作。像是一個案子我和同事常常意見不同，搞得大家都很不開心，可是他也沒有要妥協的意思。', N'2021年2月20日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (39, N'9', N'', N'', N'2021年2月20日', N'', N'0')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (40, N'9', N'', N'最近換了一個工作，同事間感覺很多摩擦，老闆對我的態度也不好，但是又不敢換工作。像是一個案子我和同事常常意見不同，搞得大家都很不開心，可是他也沒有要妥協的意思。', N'2021年2月20日', N'工作', N'2')
INSERT [dbo].[Short_record2] ([ID], [User], [SocialWoker_ID], [Context], [Date], [Topic], [Word_nm]) VALUES (41, N'9', N'', N'最近換了一個工作，同事間感覺很多摩擦，老闆對我的態度也不好，但是又不敢換工作。像是一個案子我和同事常常意見不同，搞得大家都很不開心，可是他也沒有要妥協的意思。', N'2021年2月20日', N'工作', N'2')
SET IDENTITY_INSERT [dbo].[Short_record2] OFF
GO
SET IDENTITY_INSERT [dbo].[ShortFeedback] ON 

INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (1, 1, 0, 9, 0, NULL)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (2, 1, 0, 9, 1, NULL)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (3, 1, 0, 9, 0, NULL)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (4, 1, 0, 9, 0, NULL)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (5, 2, 1, 3, 1, NULL)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (6, 1, 1, 9, 0, NULL)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (7, 2, 1, 3, 0, NULL)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (8, 2, 1, 9, 0, NULL)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (9, 2, 1, 9, 0, 31)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (11, 2, 1, 9, 0, 30)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (12, 2, 1, 9, 0, 32)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (13, 2, 1, 9, 0, 33)
INSERT [dbo].[ShortFeedback] ([Id], [Socialworker_Id], [Judgment_Score], [Student_Id], [Assist], [CaseID]) VALUES (14, 2, 1, 9, 0, 40)
SET IDENTITY_INSERT [dbo].[ShortFeedback] OFF
GO
SET IDENTITY_INSERT [dbo].[Socialworker] ON 

INSERT [dbo].[Socialworker] ([Socialworker_Id], [Socialworker_Email], [School_id], [Socialworker_name], [Socialworker_gender], [Socialworker_birthday], [Socialworker_IDnumber], [Socialworker_AuthCode], [Socialworker_account], [Socialworker_password]) VALUES (1, N'10863103@gm.nfu.edu.tw', 1, N'eria', 0, CAST(N'1986-07-05' AS Date), N'123456', N'a123', N'a123', N'a123')
INSERT [dbo].[Socialworker] ([Socialworker_Id], [Socialworker_Email], [School_id], [Socialworker_name], [Socialworker_gender], [Socialworker_birthday], [Socialworker_IDnumber], [Socialworker_AuthCode], [Socialworker_account], [Socialworker_password]) VALUES (2, N'10863103@gm.nfu.edu.tw', 1, N'jack', 0, CAST(N'1993-05-06' AS Date), N'123456', N'a1234', N'a1234', N'a1234')
SET IDENTITY_INSERT [dbo].[Socialworker] OFF
GO
SET IDENTITY_INSERT [dbo].[Student] ON 

INSERT [dbo].[Student] ([Student_Id], [School_id], [Student_token], [Student_Email], [Student_name], [Student_gender], [Student_birthday], [Student_guardian_name], [Student_guardian_phnumber], [Student_teacher], [Student_class], [Student_IDNumber], [Socialworker_id], [Student_userID], [Counseling], [LineId]) VALUES (3, 1, N'eyJhbGciOiJIUzI1NiJ9.41NVp-n5o8eYrGnJl4MlCn1WKnSG68FrgT81dlXO8yD_qBPHbjLmQ3EcbppltWuTPGnzgUO-tjcRzaG02o4mYucd4DYxZ505U9Io51HxxmQl2St0U-SMdNu54sn6uqNnIcfKnj81KlfmilPVF0IH1f3LsvoNMsxwv1qdJeMooMI.9dwFOk6iW9YkQhRiRvYDjqRGZOOvGZbWFKg78vOKIw8', N's32154104@yahoo.com.tw', N'安宏', 0, N'1997-07-05', N'A', N'0912515154', N'AB', N'A', N'10655646', 2, N'U98f85fa7160ccbf0bdf25fc61f13edc1', 0, N'6546545158541')
INSERT [dbo].[Student] ([Student_Id], [School_id], [Student_token], [Student_Email], [Student_name], [Student_gender], [Student_birthday], [Student_guardian_name], [Student_guardian_phnumber], [Student_teacher], [Student_class], [Student_IDNumber], [Socialworker_id], [Student_userID], [Counseling], [LineId]) VALUES (9, 1, N'eyJhbGciOiJIUzI1NiJ9.Y2IjufJiOJXWATrIwsxl4S0_IaduOtbJKO5Wy3GGSTLoEIYxi40xx-9qIxbLMK7mCKRCwOIl-l3WklDR76ZEuW36piKh5flSXQKrFZt56Tx5JoBeuvdcU9llzeFXp5rtrPaaFeh6SYsRomiMg4aXdCExBoy2H3xitfCHU5WDjoU.bPhzEK54jL5ZKI3AklSnE2z28zQRt33zeqLdW5O4ilI', N's32154104@yahoo.com.tw', N'安宏', 0, N'1997-07-05', N'A', N'0986456', N'AB', N'A', N'1654477', 1, N'U98f85fa7160ccbf0bdf25fc61f13edcf', 0, N'4232453')
INSERT [dbo].[Student] ([Student_Id], [School_id], [Student_token], [Student_Email], [Student_name], [Student_gender], [Student_birthday], [Student_guardian_name], [Student_guardian_phnumber], [Student_teacher], [Student_class], [Student_IDNumber], [Socialworker_id], [Student_userID], [Counseling], [LineId]) VALUES (10, 1, N'eyJhbGciOiJIUzI1NiJ9.Y2IjufJiOJXWATrIwsxl4S0_IaduOtbJKO5Wy3GGSTLoEIYxi40xx-9qIxbLMK7mCKRCwOIl-l3WklDR76ZEuW36piKh5flSXQKrFZt56Tx5JoBeuvdcU9llzeFXp5rtrPaaFeh6SYsRomiMg4aXdCExBoy2H3xitfCHU5WDjoU.bPhzEK54jL5ZKI3AklSnE2z28zQRt33zeqLdW5O4ilo', N's32154104@yahoo.com.tw', N'王大明', 0, N'1997-07-05', N'A', N'0986456', N'AB', N'A', N'1654477', 1, N'U98f85fa7160ccbf0bdf25fc61f13edch', 0, N'4232453')
INSERT [dbo].[Student] ([Student_Id], [School_id], [Student_token], [Student_Email], [Student_name], [Student_gender], [Student_birthday], [Student_guardian_name], [Student_guardian_phnumber], [Student_teacher], [Student_class], [Student_IDNumber], [Socialworker_id], [Student_userID], [Counseling], [LineId]) VALUES (11, 1, N'eyJhbGciOiJIUzI1NiJ9.NNkM4TeYa93Lt9UNOA-M3UOyOCLNiVTFyQmrGpd4CCOB7sVE_x-nOqiSMKCk-Bg3tGQYpT885waHM4O5L2rfZ8UZcjdrj1UG_87-BPYKIMRROqWDkEShdWzXCicIHgXj9vHtDopQH2hGnO_9dLkMbyrg0JY3gBF1GpAotpJboP8.IIPNvIKGUR9wQT1XO-TG-2MRPrS-tbeVYxpDhsniaB0', N'weiu30795344@gmail.com', N'Wiwi(邱韋銘)', 0, N'0880318', N'邱韋銘', N'0919794175', N'許乙清', N'四資工四乙', N'40643257', 1, N'U5ad003a52df92a8b2a22212669c698f8', 0, N'30795344')
SET IDENTITY_INSERT [dbo].[Student] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([ID], [UserID], [Start_date]) VALUES (3, N'U98f85fa7160ccbf0bdf25fc61f13edcf', N'2021年1月26日')
INSERT [dbo].[User] ([ID], [UserID], [Start_date]) VALUES (4, N'U538327e10210a21ad3d58f6f7afb8efe', N'2021年2月22日')
INSERT [dbo].[User] ([ID], [UserID], [Start_date]) VALUES (5, N'U5ad003a52df92a8b2a22212669c698f8', N'2021年5月11日')
INSERT [dbo].[User] ([ID], [UserID], [Start_date]) VALUES (6, N'U5ad003a52df92a8b2a22212669c698f8', N'2021年5月11日')
INSERT [dbo].[User] ([ID], [UserID], [Start_date]) VALUES (7, N'Uc998de380f6b8153fc4023a122f32841', N'2021年5月11日')
SET IDENTITY_INSERT [dbo].[User] OFF
GO
SET IDENTITY_INSERT [dbo].[UserTest] ON 

INSERT [dbo].[UserTest] ([ID], [uid], [event]) VALUES (1, N'U98f85fa7160ccbf0bdf25fc61f13edcf', N'{"message": {"id": "13424967241480", "text": "\u6aa2\u6e2c\u6182\u9b31\u60c5\u7dd2", "type": "text"}, "mode": "active", "replyToken": "287db618ea38455eafcdfc19b5e99a8d", "source": {"type": "user", "userId": "U98f85fa7160ccbf0bdf25fc61f13edcf"}, "timestamp": 1611296200158, "type": "message"}')
SET IDENTITY_INSERT [dbo].[UserTest] OFF
GO
SET IDENTITY_INSERT [dbo].[Verification] ON 

INSERT [dbo].[Verification] ([Id], [School_Id], [Socialworker_Id], [Verification]) VALUES (1, 1, 1, N'bq422727')
INSERT [dbo].[Verification] ([Id], [School_Id], [Socialworker_Id], [Verification]) VALUES (1001, 1, 1, N'ns638939')
INSERT [dbo].[Verification] ([Id], [School_Id], [Socialworker_Id], [Verification]) VALUES (1002, 1, 1, N'uq204863')
SET IDENTITY_INSERT [dbo].[Verification] OFF
GO
USE [master]
GO
ALTER DATABASE [DepChatBot2] SET  READ_WRITE 
GO
