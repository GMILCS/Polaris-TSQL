USE [Polaris]
GO

/****** Object:  Table [Polaris].[SILS_Hold_Inactivations]    Script Date: 18/03/2021 2:38:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Polaris].[SILS_Hold_Inactivations](
	[SysholdrequestID] [int] NOT NULL,
	[DateInactivated] [datetime] NULL,
	[DateRestored] [datetime] NULL
) ON [PRIMARY]
GO

