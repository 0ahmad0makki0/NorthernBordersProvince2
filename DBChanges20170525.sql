CREATE TABLE RuleType
(
	RuleType_Id bigint IDENTITY(1,1) PRIMARY KEY,
	Title nvarchar(MAX)
)
GO
CREATE TABLE RuleSubType
(
	RuleSubType_Id bigint IDENTITY(1,1) PRIMARY KEY,
	RuleType_Id bigint,
	Title nvarchar(MAX),
	FOREIGN KEY (RuleType_Id) REFERENCES RuleType(RuleType_Id) ON DELETE CASCADE
)
GO
CREATE TABLE Nationality
(
	Nationality_Id bigint IDENTITY(1,1) PRIMARY KEY,
	Title nvarchar(MAX)
)
GO
INSERT INTO Nationality VALUES(N'(€Ì— „Õœœ)')
INSERT INTO Nationality VALUES(N'√ÀÌÊ»Ì«')
INSERT INTO Nationality VALUES(N'√–—»ÌÃ«‰')
INSERT INTO Nationality VALUES(N'√—„Ì‰Ì«')
INSERT INTO Nationality VALUES(N'√—Ê»«')
INSERT INTO Nationality VALUES(N'≈—Ì —Ì«')
INSERT INTO Nationality VALUES(N'≈”»«‰Ì«')
INSERT INTO Nationality VALUES(N'√” —«·Ì«')
INSERT INTO Nationality VALUES(N'≈”—«∆Ì·')
INSERT INTO Nationality VALUES(N'√›€«‰” «‰')
INSERT INTO Nationality VALUES(N'≈ﬁ·Ì„ «·„ÕÌÿ «·Â‰œÌ «·»—Ìÿ«‰Ì')
INSERT INTO Nationality VALUES(N'√·»«‰Ì«')
INSERT INTO Nationality VALUES(N'√·„«‰Ì«')
INSERT INTO Nationality VALUES(N'√‰ Ì€Ê« Ê»—»Êœ«')
INSERT INTO Nationality VALUES(N'√‰œÊ—«')
INSERT INTO Nationality VALUES(N'√‰œÊ‰Ì”Ì«')
INSERT INTO Nationality VALUES(N'√‰€Ê·«')
INSERT INTO Nationality VALUES(N'√‰€Ì·«')
INSERT INTO Nationality VALUES(N'√Ê—Ê€Ê«Ì')
INSERT INTO Nationality VALUES(N'√Ê“»ﬂ” «‰')
INSERT INTO Nationality VALUES(N'√Ê€‰œ«')
INSERT INTO Nationality VALUES(N'√Êﬂ—«‰Ì«')
INSERT INTO Nationality VALUES(N'√Ì—·‰œ«')
INSERT INTO Nationality VALUES(N'√Ì”·‰œ«')
INSERT INTO Nationality VALUES(N'≈Ìÿ«·Ì«')
INSERT INTO Nationality VALUES(N'«” Ê‰Ì«')
INSERT INTO Nationality VALUES(N'«·√—Ã‰ Ì‰')
INSERT INTO Nationality VALUES(N'«·√—œ‰')
INSERT INTO Nationality VALUES(N'«·√ﬁ«·Ì„ «·Ã‰Ê»Ì… «·›—‰”Ì…')
INSERT INTO Nationality VALUES(N'«·≈„«—«  «·⁄—»Ì… «·„ Õœ…')
INSERT INTO Nationality VALUES(N'«·« Õ«œ «·—Ê”Ì')
INSERT INTO Nationality VALUES(N'«·«ﬂÊ«œÊ—')
INSERT INTO Nationality VALUES(N'«·»Õ—Ì‰')
INSERT INTO Nationality VALUES(N'«·»—«“Ì·')
INSERT INTO Nationality VALUES(N'«·»— €«·')
INSERT INTO Nationality VALUES(N'«·»Ê”‰… Ê«·Â—”ﬂ')
INSERT INTO Nationality VALUES(N'«·Ã“«∆—')
INSERT INTO Nationality VALUES(N'«·Ã„«ÂÌ—Ì… «·⁄—»Ì… «··Ì»Ì…')
INSERT INTO Nationality VALUES(N'«·œ‰„«—ﬂ')
INSERT INTO Nationality VALUES(N'«·—√” «·√Œ÷—')
INSERT INTO Nationality VALUES(N'«·”·›«œÊ—')
INSERT INTO Nationality VALUES(N'«·”‰€«·')
INSERT INTO Nationality VALUES(N'«·”ÊÌœ')
INSERT INTO Nationality VALUES(N'«·’Õ—«¡ «·€—»Ì…')
INSERT INTO Nationality VALUES(N'«·’Ê„«·')
INSERT INTO Nationality VALUES(N'«·’Ì‰')
INSERT INTO Nationality VALUES(N'«·⁄—«ﬁ')
INSERT INTO Nationality VALUES(N'«·€«»Ê‰')
INSERT INTO Nationality VALUES(N'«·›·»Ì‰')
INSERT INTO Nationality VALUES(N'«·ﬁ«—… «·ﬁÿ»Ì… «·Ã‰Ê»Ì…')
INSERT INTO Nationality VALUES(N'«·ﬂ«„Ì—Ê‰')
INSERT INTO Nationality VALUES(N'«·ﬂ—”Ì «·—”Ê·Ì (œÊ·… «·›« Ìﬂ«‰)')
INSERT INTO Nationality VALUES(N'«·ﬂÊ‰€Ê')
INSERT INTO Nationality VALUES(N'«·ﬂÊ‰€Ê° Ã„ÂÊ—Ì… «·ﬂÊ‰€Ê «·œÌ„ﬁ—«ÿÌ…')
INSERT INTO Nationality VALUES(N'«·ﬂÊÌ ')
INSERT INTO Nationality VALUES(N'«·„ﬂ”Ìﬂ')
INSERT INTO Nationality VALUES(N'«·„„·ﬂ… «·⁄—»Ì… «·”⁄ÊœÌ…')
INSERT INTO Nationality VALUES(N'«·„„·ﬂ… «·„ Õœ…')
INSERT INTO Nationality VALUES(N'«·‰—ÊÌÃ')
INSERT INTO Nationality VALUES(N'«·‰„”«')
INSERT INTO Nationality VALUES(N'«·‰ÌÃ—')
INSERT INTO Nationality VALUES(N'«·Â‰œ')
INSERT INTO Nationality VALUES(N'«·Ê·«Ì«  «·„ Õœ…')
INSERT INTO Nationality VALUES(N'«·Ì«»«‰')
INSERT INTO Nationality VALUES(N'»«»Ê« €Ì‰Ì« «·ÃœÌœ…')
INSERT INTO Nationality VALUES(N'»«—«€Ê«Ì')
INSERT INTO Nationality VALUES(N'»«ﬂ” «‰')
INSERT INTO Nationality VALUES(N'»«·«Ê')
INSERT INTO Nationality VALUES(N'»—»«œÊ”')
INSERT INTO Nationality VALUES(N'»—„Êœ«')
INSERT INTO Nationality VALUES(N'»—Ê‰«Ì œ«— «·”·«„')
INSERT INTO Nationality VALUES(N'»·ÃÌﬂ«')
INSERT INTO Nationality VALUES(N'»·€«—Ì«')
INSERT INTO Nationality VALUES(N'»·Ì“')
INSERT INTO Nationality VALUES(N'»‰«„«')
INSERT INTO Nationality VALUES(N'»‰€·«œÌ‘')
INSERT INTO Nationality VALUES(N'»‰Ì‰')
INSERT INTO Nationality VALUES(N'»Ê «‰')
INSERT INTO Nationality VALUES(N'»Ê ”Ê«‰«')
INSERT INTO Nationality VALUES(N'»Ê— Ê—ÌﬂÊ')
INSERT INTO Nationality VALUES(N'»Ê—ﬂÌ‰« ›«”Ê')
INSERT INTO Nationality VALUES(N'»Ê—Ê‰œÌ')
INSERT INTO Nationality VALUES(N'»Ê·‰œ«')
INSERT INTO Nationality VALUES(N'»Ê·Ì›Ì«')
INSERT INTO Nationality VALUES(N'»Ê·Ì‰Ì“Ì« «·›—‰”Ì…')
INSERT INTO Nationality VALUES(N'»Ì ﬂÌ—‰')
INSERT INTO Nationality VALUES(N'»Ì—Ê')
INSERT INTO Nationality VALUES(N' «Ì·«‰œ')
INSERT INTO Nationality VALUES(N' «ÌÊ«‰° „ﬁ«ÿ⁄… ’Ì‰Ì…')
INSERT INTO Nationality VALUES(N' —ﬂ„«‰” «‰')
INSERT INTO Nationality VALUES(N' —ﬂÌ«')
INSERT INTO Nationality VALUES(N' —Ì‰Ìœ«œ Ê Ê»«€Ê')
INSERT INTO Nationality VALUES(N' ‘«œ')
INSERT INTO Nationality VALUES(N' ‘Ì·Ì')
INSERT INTO Nationality VALUES(N' Ê€Ê')
INSERT INTO Nationality VALUES(N' Ê›«·Ê')
INSERT INTO Nationality VALUES(N' ÊﬂÌ·«Ê')
INSERT INTO Nationality VALUES(N' Ê‰”')
INSERT INTO Nationality VALUES(N' Ê‰€«')
INSERT INTO Nationality VALUES(N' Ì„Ê— «·‘—ﬁÌ…')
INSERT INTO Nationality VALUES(N'Ã«„«Ìﬂ«')
INSERT INTO Nationality VALUES(N'Ã»· ÿ«—ﬁ')
INSERT INTO Nationality VALUES(N'Ã—Ì‰·«‰œ')
INSERT INTO Nationality VALUES(N'Ã“— ¬·«‰œ')
INSERT INTO Nationality VALUES(N'Ã“— «·√‰ Ì· «·ÂÊ·‰œÌ…')
INSERT INTO Nationality VALUES(N'Ã“— «·»Â«„«')
INSERT INTO Nationality VALUES(N'Ã“— «·⁄–—«¡ «·√„Ì—ﬂÌ…°')
INSERT INTO Nationality VALUES(N'Ã“— «·⁄–—«¡ «·»—Ìÿ«‰Ì…')
INSERT INTO Nationality VALUES(N'Ã“— «·ﬁ„—')
INSERT INTO Nationality VALUES(N'Ã“— «·„«·œÌ›')
INSERT INTO Nationality VALUES(N'Ã“— «·Ê·«Ì«  «·„ Õœ… «·»⁄Ìœ… «·’€Ì—…')
INSERT INTO Nationality VALUES(N'Ã“—  —ﬂ” Êﬂ«ÌﬂÊ”')
INSERT INTO Nationality VALUES(N'Ã“— ”·Ì„«‰')
INSERT INTO Nationality VALUES(N'Ã“— ›«—Ê')
INSERT INTO Nationality VALUES(N'Ã“— ›Êﬂ·«‰œ („«·›Ì‰«”)')
INSERT INTO Nationality VALUES(N'Ã“— ﬂ«Ì„«‰')
INSERT INTO Nationality VALUES(N'Ã“— ﬂÊﬂ')
INSERT INTO Nationality VALUES(N'Ã“— „«—‘«·')
INSERT INTO Nationality VALUES(N'Ã“— „«—Ì«‰« «·‘„«·Ì…')
INSERT INTO Nationality VALUES(N'Ã“Ì—… ¬Ì· √Ê› „«‰')
INSERT INTO Nationality VALUES(N'Ã“Ì—… »Ê›ÌÂ')
INSERT INTO Nationality VALUES(N'Ã“Ì—… ﬂ—Ì”„«”')
INSERT INTO Nationality VALUES(N'Ã“Ì—… ‰Ê—›Ê·ﬂ')
INSERT INTO Nationality VALUES(N'Ã“Ì—… ÂÌ—œ ÊÃ“— „«ﬂœÊ‰«·œ')
INSERT INTO Nationality VALUES(N'Ã„⁄ ‘„·')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì… √›—ÌﬁÌ« «·Ê”ÿÏ')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì… ≈Ì—«‰ «·≈”·«„Ì…° „‰')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì… «· ‘Ìﬂ')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì… «·œÊ„Ì‰Ìﬂ«‰')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì…  ‰“«‰Ì« «·„ Õœ…')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì… ﬂÊ—Ì«')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì… ﬂÊ—Ì« «·‘⁄»Ì… «·œÌ„ﬁ—«ÿÌ…° „‰')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì… ·«Ê «·œÌ„ﬁ—«ÿÌ… «·‘⁄»Ì…')
INSERT INTO Nationality VALUES(N'Ã„ÂÊ—Ì… „Ê·œÊ›«')
INSERT INTO Nationality VALUES(N'Ã‰Ê» √›—ÌﬁÌ«')
INSERT INTO Nationality VALUES(N'ÃÊ—ÃÌ«')
INSERT INTO Nationality VALUES(N'ÃÊ—ÃÌ« «·Ã‰Ê»Ì… ÊÃ“— ”«‰œÊÌ ‘ «·Ã‰Ê»Ì…')
INSERT INTO Nationality VALUES(N'ÃÊÌ«‰« «·›—‰”Ì…')
INSERT INTO Nationality VALUES(N'ÃÌ»Ê Ì')
INSERT INTO Nationality VALUES(N'ÃÌ—”Ì')
INSERT INTO Nationality VALUES(N'œÊ„Ì‰Ìﬂ«')
INSERT INTO Nationality VALUES(N'—Ê«‰œ«')
INSERT INTO Nationality VALUES(N'—Ê”Ì« «·»Ì÷«¡')
INSERT INTO Nationality VALUES(N'—Ê„«‰Ì«')
INSERT INTO Nationality VALUES(N'“«„»Ì«')
INSERT INTO Nationality VALUES(N'“Ì„»«»ÊÌ')
INSERT INTO Nationality VALUES(N'”«„Ê«')
INSERT INTO Nationality VALUES(N'”«„Ê« «·√„—ÌﬂÌ…')
INSERT INTO Nationality VALUES(N'”«‰ »Ì«— Ê„Ìﬂ·Ê‰')
INSERT INTO Nationality VALUES(N'”«‰  Ê„Ì Ê»—Ì‰”Ì»Ì')
INSERT INTO Nationality VALUES(N'”«‰ „«—Ì‰Ê')
INSERT INTO Nationality VALUES(N'”«‰  ›‰”‰  ÊÃ“— €—Ì‰«œÌ‰')
INSERT INTO Nationality VALUES(N'”«‰  ﬂÌ ” Ê‰Ì›Ì”')
INSERT INTO Nationality VALUES(N'”«‰  ·Ê”Ì«')
INSERT INTO Nationality VALUES(N'”«‰  ÂÌ·Ì‰«')
INSERT INTO Nationality VALUES(N'”—Ì ·«‰ﬂ«')
INSERT INTO Nationality VALUES(N'”›«·»«—œ')
INSERT INTO Nationality VALUES(N'”·Ê›«ﬂÌ«')
INSERT INTO Nationality VALUES(N'”·Ê›Ì‰Ì«')
INSERT INTO Nationality VALUES(N'”‰€«›Ê—…')
INSERT INTO Nationality VALUES(N'”Ê«“Ì·«‰œ')
INSERT INTO Nationality VALUES(N'”Êœ«‰')
INSERT INTO Nationality VALUES(N'”Ê—Ì«')
INSERT INTO Nationality VALUES(N'”Ê—Ì‰«„')
INSERT INTO Nationality VALUES(N'”ÊÌ”—«')
INSERT INTO Nationality VALUES(N'”Ì—«·ÌÊ‰')
INSERT INTO Nationality VALUES(N'”Ì‘Ì·')
INSERT INTO Nationality VALUES(N'’—»Ì« Ê«·Ã»· «·√”Êœ')
INSERT INTO Nationality VALUES(N'ÿ«ÃÌﬂ” «‰')
INSERT INTO Nationality VALUES(N'⁄„«‰')
INSERT INTO Nationality VALUES(N'€«„»Ì«')
INSERT INTO Nationality VALUES(N'€«‰«')
INSERT INTO Nationality VALUES(N'€—Ì‰«œ«')
INSERT INTO Nationality VALUES(N'€Ê« Ì„«·«')
INSERT INTO Nationality VALUES(N'€Ê«œ·Ê»')
INSERT INTO Nationality VALUES(N'€Ê«„')
INSERT INTO Nationality VALUES(N'€Ì«‰«')
INSERT INTO Nationality VALUES(N'€Ì—‰”Ì')
INSERT INTO Nationality VALUES(N'€Ì‰Ì«')
INSERT INTO Nationality VALUES(N'€Ì‰Ì« «·«” Ê«∆Ì…')
INSERT INTO Nationality VALUES(N'€Ì‰Ì« »Ì”«Ê')
INSERT INTO Nationality VALUES(N'›«‰Ê« Ê')
INSERT INTO Nationality VALUES(N'›—‰”«')
INSERT INTO Nationality VALUES(N'›·”ÿÌ‰')
INSERT INTO Nationality VALUES(N'›‰“ÊÌ·«')
INSERT INTO Nationality VALUES(N'›‰·‰œ«')
INSERT INTO Nationality VALUES(N'›ÌÃÌ')
INSERT INTO Nationality VALUES(N'›ÌÌ  ‰«„')
INSERT INTO Nationality VALUES(N'ﬁ»—’')
INSERT INTO Nationality VALUES(N'ﬁ—€Ì“” «‰')
INSERT INTO Nationality VALUES(N'ﬁÿ—')
INSERT INTO Nationality VALUES(N'ﬂ«“«Œ” «‰')
INSERT INTO Nationality VALUES(N'ﬂ«·ÌœÊ‰Ì« «·ÃœÌœ…')
INSERT INTO Nationality VALUES(N'ﬂ—Ê« Ì«')
INSERT INTO Nationality VALUES(N'ﬂ„»ÊœÌ«')
INSERT INTO Nationality VALUES(N'ﬂ‰œ«')
INSERT INTO Nationality VALUES(N'ﬂÊ»«')
INSERT INTO Nationality VALUES(N'ﬂÊ  œÌ›Ê«—')
INSERT INTO Nationality VALUES(N'ﬂÊ” «—Ìﬂ«')
INSERT INTO Nationality VALUES(N'ﬂÊﬂÊ” (ﬂÌ·Ì‰€) Ã“—')
INSERT INTO Nationality VALUES(N'ﬂÊ·Ê„»Ì«')
INSERT INTO Nationality VALUES(N'ﬂÌ—Ì»« Ì')
INSERT INTO Nationality VALUES(N'ﬂÌ‰Ì«')
INSERT INTO Nationality VALUES(N'·« ›Ì«')
INSERT INTO Nationality VALUES(N'·»‰«‰')
INSERT INTO Nationality VALUES(N'·Êﬂ”„»Ê—€')
INSERT INTO Nationality VALUES(N'·Ì»Ì—Ì«')
INSERT INTO Nationality VALUES(N'·Ì Ê«‰Ì«')
INSERT INTO Nationality VALUES(N'·ÌŒ ‰‘ «Ì‰')
INSERT INTO Nationality VALUES(N'·Ì”Ê Ê')
INSERT INTO Nationality VALUES(N'„«— Ì‰Ìﬂ')
INSERT INTO Nationality VALUES(N'„«ﬂ«Ê')
INSERT INTO Nationality VALUES(N'„«·ÿ«')
INSERT INTO Nationality VALUES(N'„«·Ì')
INSERT INTO Nationality VALUES(N'„«·Ì“Ì«')
INSERT INTO Nationality VALUES(N'„«ÌÊ ')
INSERT INTO Nationality VALUES(N'„œ€‘ﬁ—')
INSERT INTO Nationality VALUES(N'„’—')
INSERT INTO Nationality VALUES(N'„€—»Ì')
INSERT INTO Nationality VALUES(N'„ﬁœÊ‰Ì«° Ã„ÂÊ—Ì… ÌÊ€Ê”·«›Ì« «·”«»ﬁ…')
INSERT INTO Nationality VALUES(N'„·«ÊÌ')
INSERT INTO Nationality VALUES(N'„‰€Ê·Ì«')
INSERT INTO Nationality VALUES(N'„Ê—Ì «‰Ì«')
INSERT INTO Nationality VALUES(N'„Ê—Ì‘ÌÊ”')
INSERT INTO Nationality VALUES(N'„Ê“„»Ìﬁ')
INSERT INTO Nationality VALUES(N'„Ê‰«ﬂÊ')
INSERT INTO Nationality VALUES(N'„Ê‰ ”Ì—« ')
INSERT INTO Nationality VALUES(N'„Ì«‰„«—')
INSERT INTO Nationality VALUES(N'‰«„Ì»Ì«')
INSERT INTO Nationality VALUES(N'‰«Ê—Ê')
INSERT INTO Nationality VALUES(N'‰Ì»«·')
INSERT INTO Nationality VALUES(N'‰ÌÃÌ—Ì«')
INSERT INTO Nationality VALUES(N'‰Ìﬂ«—«€Ê«')
INSERT INTO Nationality VALUES(N'‰ÌÊ“Ì·‰œ«')
INSERT INTO Nationality VALUES(N'‰ÌÊÌ')
INSERT INTO Nationality VALUES(N'Â«Ì Ì')
INSERT INTO Nationality VALUES(N'Â‰œÊ—«”')
INSERT INTO Nationality VALUES(N'Â‰€«—Ì«')
INSERT INTO Nationality VALUES(N'ÂÊ·‰œ«')
INSERT INTO Nationality VALUES(N'ÂÊ‰€ ﬂÊ‰€')
INSERT INTO Nationality VALUES(N'Ê«·Ì” Ê›Ê Ê‰«')
INSERT INTO Nationality VALUES(N'Ê·«Ì«  „Ìﬂ—Ê‰Ì“Ì« «·„ÊÕœ… „‰')
INSERT INTO Nationality VALUES(N'Ì„‰Ì')
INSERT INTO Nationality VALUES(N'ÌÊ‰«‰')
GO
ALTER TABLE RuleData
ADD RuleSubType_Id bigint,
	Occupation nvarchar(MAX),
	Nationality_Id bigint,
	FOREIGN KEY (RuleSubType_Id) REFERENCES RuleSubType(RuleSubType_Id),
	FOREIGN KEY (Nationality_Id) REFERENCES Nationality(Nationality_Id)
GO
UPDATE RuleData SET RuleSubType_Id = NULL, Occupation = '', Nationality_Id = 1
GO
CREATE PROCEDURE [dbo].[sp_GetRuleTypes](@Search nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleType_Id bigint,
		RuleType_Id_string nvarchar(MAX),
		Title nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	rt.RuleType_Id,
			REPLACE(STR(CAST(rt.RuleType_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			rt.Title
	FROM	RuleType rt
	WHERE	(
				@Search = 'Empty%%^^&*(('
				OR
				(CAST(rt.RuleType_Id as nvarchar(MAX)) LIKE @Search + '%')
				OR
				(rt.Title LIKE '%' + @Search + '%')
			)

	SELECT * FROM @RESULTS
END
GO
INSERT INTO ProvisionsMonitoringPage VALUES(N'≈⁄œ«œ«  √‰Ê«⁄ «·ﬁ÷«Ì«')
INSERT INTO ProvisionsMonitoringPage VALUES(N'≈⁄œ«œ«  «·√‰Ê«⁄ «·›—⁄Ì… ··ﬁ÷«Ì«')
INSERT INTO ProvisionsMonitoringPage VALUES(N' ﬁ—Ì— ⁄œœ «·√Õﬂ«„ »«·›∆« ')
GO
INSERT INTO ProvisionsMonitoringPageRole VALUES(7,1)
INSERT INTO ProvisionsMonitoringPageRole VALUES(7,2)
INSERT INTO ProvisionsMonitoringPageRole VALUES(7,3)
INSERT INTO ProvisionsMonitoringPageRole VALUES(7,4)
INSERT INTO ProvisionsMonitoringPageRole VALUES(8,1)
INSERT INTO ProvisionsMonitoringPageRole VALUES(8,2)
INSERT INTO ProvisionsMonitoringPageRole VALUES(8,3)
INSERT INTO ProvisionsMonitoringPageRole VALUES(8,4)
INSERT INTO ProvisionsMonitoringPageRole VALUES(9,1)
GO
INSERT INTO ProvisionsMonitoringUserRole
SELECT	1,
		pr.ProvisionsMonitoringPageRole_Id
FROM	ProvisionsMonitoringPageRole pr
WHERE	NOT EXISTS (SELECT * FROM ProvisionsMonitoringUserRole ur WHERE ur.ProvisionsMonitoringUser_Id = 1 AND ur.ProvisionsMonitoringPageRole_Id = pr.ProvisionsMonitoringPageRole_Id)
GO
CREATE PROCEDURE [dbo].[sp_GetRuleSubTypes](@Search nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleSubType_Id bigint,
		RuleSubType_Id_string nvarchar(MAX),
		RTTitle nvarchar(MAX),
		Title nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	rst.RuleSubType_Id,
			REPLACE(STR(CAST(rst.RuleSubType_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			rt.Title,
			rst.Title
	FROM	RuleSubType rst INNER JOIN
			RuleType rt ON rst.RuleType_Id = rt.RuleType_Id
	WHERE	(
				@Search = 'Empty%%^^&*(('
				OR
				(CAST(rst.RuleSubType_Id as nvarchar(MAX)) LIKE @Search + '%')
				OR
				(rt.Title LIKE '%' + @Search + '%')
				OR
				(rst.Title LIKE '%' + @Search + '%')
			)

	SELECT * FROM @RESULTS
END
GO
CREATE PROCEDURE [dbo].[sp_GetRuleTypesForSelect]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleType_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--«·—Ã«¡ «·≈Œ Ì«—--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT RuleType_Id,
			Title
	FROM	RuleType
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END
GO
CREATE PROCEDURE [dbo].[sp_GetRuleSubTypesForSelect](@RuleType_Id bigint)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleSubType_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--«·—Ã«¡ «·≈Œ Ì«—--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT RuleSubType_Id,
			Title
	FROM	RuleSubType
	WHERE	RuleType_Id = @RuleType_Id
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END
GO
ALTER PROCEDURE [dbo].[sp_GetRuleData](@Search nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleData_Id bigint,
		RuleData_Id_string nvarchar(MAX),
		CaseNumber nvarchar(MAX),
		IssuedLetterNumber nvarchar(MAX),
		IssuedLetterDate_string nvarchar(MAX),
		IssuedLetterDate date,
		AccusedName nvarchar(MAX),
		AccusedSSN nvarchar(MAX),
		RuleTypeTitle nvarchar(MAX),
		LegalDecisionNumber nvarchar(MAX),
		LegalDecisionDate_string nvarchar(MAX),
		LegalDecisionDate date,
		SupportingDecisionNumber nvarchar(MAX),
		SupportingDecisionDate_string nvarchar(MAX),
		SupportingDecisionDate date,
		RuleStatus_Id bigint,
		RuleStatusTitle nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	rd.RuleData_Id,
			REPLACE(STR(CAST(rd.RuleData_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			rd.CaseNumber,
			rd.IssuedLetterNumber,
			dbo.fn_GetHijiriDate(rd.IssuedLetterDate),
			rd.IssuedLetterDate,
			rd.AccusedName,
			rd.AccusedSSN,
			ISNULL(rt.Title + N' - ' + rst.Title,''),
			rd.LegalDecisionNumber,
			dbo.fn_GetHijiriDate(rd.LegalDecisionDate),
			rd.LegalDecisionDate,
			rd.SupportingDecisionNumber,
			dbo.fn_GetHijiriDate(rd.SupportingDecisionDate),
			rd.SupportingDecisionDate,
			s.RuleStatus_Id,
			s.Title
	FROM	RuleData rd INNER JOIN
			RuleStatus s ON s.RuleStatus_Id = rd.RuleStatus_Id LEFT OUTER JOIN
			RuleSubType rst ON rst.RuleSubType_Id = rd.RuleSubType_Id LEFT OUTER JOIN
			RuleType rt ON rst.RuleType_Id = rt.RuleType_Id
	WHERE	(
				@Search = 'Empty%%^^&*(('
				OR
				(CAST(rd.RuleData_Id as nvarchar(MAX)) LIKE @Search + '%')
				OR
				(rd.CaseNumber LIKE @Search + '%')
				OR
				(rd.IssuedLetterNumber LIKE @Search + '%')
				OR
				(rd.AccusedName LIKE '%' + @Search + '%')
				OR
				(rd.LegalDecisionNumber LIKE @Search + '%')
				OR
				(rd.SupportingDecisionNumber LIKE @Search + '%')
				OR
				(s.Title LIKE @Search + '%')
				OR
				(ISNULL(rt.Title + N' - ' + rst.Title,'') LIKE '%' + @Search + '%')
			)

	SELECT * FROM @RESULTS ORDER BY RuleData_Id
END
GO
CREATE PROCEDURE sp_GetRuleDataReportByGrouping
(
	@GroupBy bigint,
	@DateFrom date,
	@DateTo date
)
As
BEGIN
	
	--@GroupBy: 1:RuleStatus, 2:RuleType, 3:Occupation, 4:Nationality

	DECLARE @RESULTS TABLE
	(
		Title nvarchar(MAX),
		NumberOfRules bigint
	)

	IF @GroupBy = 1
	BEGIN
		INSERT INTO @RESULTS
		SELECT		TOP 100 PERCENT
					rs.Title,
					COUNT(rd.RuleData_Id)
		FROM		RuleData rd INNER JOIN
					RuleStatus rs ON rd.RuleStatus_Id = rs.RuleStatus_Id
		WHERE		(
						(@DateFrom IS NULL AND @DateTo IS NULL)
						OR
						(@DateFrom IS NULL AND @DateTo IS NOT NULL AND rd.IssuedLetterDate BETWEEN GETDATE()-21000 AND @DateTo)
						OR
						(@DateFrom IS NOT NULL AND @DateTo IS NULL AND rd.IssuedLetterDate BETWEEN @DateFrom AND GETDATE()+21000)
						OR
						(@DateFrom IS NOT NULL AND @DateFrom IS NOT NULL AND rd.IssuedLetterDate BETWEEN @DateFrom AND @DateTo)
					)
		GROUP BY	rs.Title
		ORDER BY	rs.Title
	END
	ELSE IF @GroupBy = 2
	BEGIN
		INSERT INTO @RESULTS
		SELECT		TOP 100 PERCENT
					ISNULL(rt.Title + ' - ' + rst.Title,N'(€Ì— „Õœœ)'),
					COUNT(rd.RuleData_Id)
		FROM		RuleData rd LEFT OUTER JOIN
					RuleSubType rst ON rd.RuleSubType_Id = rst.RuleSubType_Id LEFT OUTER JOIN
					RuleType rt ON rt.RuleType_Id = rst.RuleType_Id
		WHERE		(
						(@DateFrom IS NULL AND @DateTo IS NULL)
						OR
						(@DateFrom IS NULL AND @DateTo IS NOT NULL AND rd.IssuedLetterDate BETWEEN GETDATE()-21000 AND @DateTo)
						OR
						(@DateFrom IS NOT NULL AND @DateTo IS NULL AND rd.IssuedLetterDate BETWEEN @DateFrom AND GETDATE()+21000)
						OR
						(@DateFrom IS NOT NULL AND @DateFrom IS NOT NULL AND rd.IssuedLetterDate BETWEEN @DateFrom AND @DateTo)
					)
		GROUP BY	ISNULL(rt.Title + ' - ' + rst.Title,N'(€Ì— „Õœœ)')
		ORDER BY	ISNULL(rt.Title + ' - ' + rst.Title,N'(€Ì— „Õœœ)')
	END
	ELSE IF @GroupBy = 3
	BEGIN
		INSERT INTO @RESULTS
		SELECT		TOP 100 PERCENT
					CASE WHEN rd.Occupation = '' THEN N'(€Ì— „Õœœ)' ELSE rd.Occupation END,
					COUNT(rd.RuleData_Id)
		FROM		RuleData rd
		WHERE		(
						(@DateFrom IS NULL AND @DateTo IS NULL)
						OR
						(@DateFrom IS NULL AND @DateTo IS NOT NULL AND rd.IssuedLetterDate BETWEEN GETDATE()-21000 AND @DateTo)
						OR
						(@DateFrom IS NOT NULL AND @DateTo IS NULL AND rd.IssuedLetterDate BETWEEN @DateFrom AND GETDATE()+21000)
						OR
						(@DateFrom IS NOT NULL AND @DateFrom IS NOT NULL AND rd.IssuedLetterDate BETWEEN @DateFrom AND @DateTo)
					)
		GROUP BY	CASE WHEN rd.Occupation = '' THEN N'(€Ì— „Õœœ)' ELSE rd.Occupation END
		ORDER BY	CASE WHEN rd.Occupation = '' THEN N'(€Ì— „Õœœ)' ELSE rd.Occupation END
	END
	ELSE IF @GroupBy = 4
	BEGIN
		INSERT INTO @RESULTS
		SELECT		TOP 100 PERCENT
					n.Title,
					COUNT(rd.RuleData_Id)
		FROM		RuleData rd INNER JOIN
					Nationality n ON rd.Nationality_Id = n.Nationality_Id
		WHERE		(
						(@DateFrom IS NULL AND @DateTo IS NULL)
						OR
						(@DateFrom IS NULL AND @DateTo IS NOT NULL AND rd.IssuedLetterDate BETWEEN GETDATE()-21000 AND @DateTo)
						OR
						(@DateFrom IS NOT NULL AND @DateTo IS NULL AND rd.IssuedLetterDate BETWEEN @DateFrom AND GETDATE()+21000)
						OR
						(@DateFrom IS NOT NULL AND @DateFrom IS NOT NULL AND rd.IssuedLetterDate BETWEEN @DateFrom AND @DateTo)
					)
		GROUP BY	n.Title
		ORDER BY	n.Title
	END

	SELECT * FROM @RESULTS
END
GO
CREATE PROCEDURE [dbo].[sp_GetNationalitiesForSelect]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		Nationality_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--«·—Ã«¡ «·≈Œ Ì«—--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT Nationality_Id,
			Title
	FROM	Nationality
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END
GO
ALTER PROCEDURE [dbo].[sp_GetRuleDataReport]
(
	@CaseNumber nvarchar(MAX),
	@RuleSubType_Id bigint,
	@IssuedLetterNumber nvarchar(MAX),
	@IssuedLetterDateFrom date,
	@IssuedLetterDateTo date,
	@AccusedName nvarchar(MAX),
	@Nationality_Id bigint,
	@AccusedSSN nvarchar(MAX),
	@Occupation nvarchar(MAX),
	@LegalDecisionNumber nvarchar(MAX),
	@LegalDecisionDateFrom date,
	@LegalDecisionDateTo date,
	@SupportingDecisionNumber nvarchar(MAX),
	@SupportingDecisionDateFrom date,
	@SupportingDecisionDateTo date,
	@RuleStatus_Id bigint
)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleDate_Id bigint,
		RuleDate_Id_string nvarchar(MAX),
		CaseNumber nvarchar(MAX),
		RuleTypeTitle nvarchar(MAX),
		IssuedLetterNumber nvarchar(MAX),
		IssuedLetterDate date,
		IssuedLetterDate_string nvarchar(MAX),
		AccusedName nvarchar(MAX),
		NationalityTitle nvarchar(MAX),
		AccusedSSN nvarchar(MAX),
		Occupation nvarchar(MAX),
		LegalDecisionNumber nvarchar(MAX),
		LegalDecisionDate date,
		LegalDecisionDate_string nvarchar(MAX),
		SupportingDecisionNumber nvarchar(MAX),
		SupportingDecisionDate date,
		SupportingDecisionDate_string nvarchar(MAX),
		RuleStatusTitle nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	pd.RuleData_Id,
			REPLACE(STR(CAST(pd.RuleData_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			pd.CaseNumber,
			ISNULL(rt.Title + ' - ' + rst.Title,''),
			pd.IssuedLetterNumber,
			pd.IssuedLetterDate,
			dbo.fn_GetHijiriDate(pd.IssuedLetterDate),
			pd.AccusedName,
			n.Title,
			pd.AccusedSSN,
			pd.Occupation,
			pd.LegalDecisionNumber,
			pd.LegalDecisionDate,
			dbo.fn_GetHijiriDate(pd.LegalDecisionDate),
			pd.SupportingDecisionNumber,
			pd.SupportingDecisionDate,
			dbo.fn_GetHijiriDate(pd.SupportingDecisionDate),
			el.Title
	FROM	RuleData pd INNER JOIN
			RuleStatus el ON pd.RuleStatus_Id = el.RuleStatus_Id INNER JOIN
			Nationality n ON n.Nationality_Id = pd.Nationality_Id LEFT OUTER JOIN
			RuleSubType rst ON pd.RuleSubType_Id = rst.RuleSubType_Id LEFT OUTER JOIN
			RuleType rt ON rst.RuleType_Id = rt.RuleType_Id
	WHERE	(@CaseNumber = '' OR pd.CaseNumber LIKE @CaseNumber + '%')
	AND		(@RuleSubType_Id = 0 OR rst.RuleSubType_Id = @RuleSubType_Id)
	AND		(@Occupation = '' OR pd.Occupation LIKE '%' + @Occupation + '%')
	AND		(@Nationality_Id = 0 OR n.Nationality_Id = @Nationality_Id)
	AND		(@IssuedLetterNumber = '' OR pd.IssuedLetterNumber LIKE @IssuedLetterNumber + '%')
	AND		(
				(@IssuedLetterDateFrom IS NULL AND @IssuedLetterDateTo IS NULL)
				OR
				(@IssuedLetterDateFrom IS NULL AND @IssuedLetterDateTo IS NOT NULL AND pd.IssuedLetterDate BETWEEN GETDATE()-21000 AND @IssuedLetterDateTo)
				OR
				(@IssuedLetterDateFrom IS NOT NULL AND @IssuedLetterDateTo IS NULL AND pd.IssuedLetterDate BETWEEN @IssuedLetterDateFrom AND GETDATE()+21000)
				OR
				(@IssuedLetterDateFrom IS NOT NULL AND @IssuedLetterDateFrom IS NOT NULL AND pd.IssuedLetterDate BETWEEN @IssuedLetterDateFrom AND @IssuedLetterDateTo)
			)
	AND		(@AccusedName = '' OR pd.AccusedName LIKE '%' + @AccusedName + '%')
	AND		(@AccusedSSN = '' OR pd.AccusedSSN LIKE @AccusedSSN + '%')
	AND		(@LegalDecisionNumber = '' OR pd.LegalDecisionNumber LIKE @LegalDecisionNumber + '%')
	AND		(
				(@LegalDecisionDateFrom IS NULL AND @LegalDecisionDateTo IS NULL)
				OR
				(@LegalDecisionDateFrom IS NULL AND @LegalDecisionDateTo IS NOT NULL AND pd.LegalDecisionDate BETWEEN GETDATE()-21000 AND @LegalDecisionDateTo)
				OR
				(@LegalDecisionDateFrom IS NOT NULL AND @LegalDecisionDateTo IS NULL AND pd.LegalDecisionDate BETWEEN @LegalDecisionDateFrom AND GETDATE()+21000)
				OR
				(@LegalDecisionDateFrom IS NOT NULL AND @LegalDecisionDateTo IS NOT NULL AND pd.LegalDecisionDate BETWEEN @LegalDecisionDateFrom AND @LegalDecisionDateTo)
			)
	AND		(@SupportingDecisionNumber = '' OR pd.SupportingDecisionNumber LIKE @SupportingDecisionNumber + '%')
	AND		(@LegalDecisionNumber = '' OR pd.LegalDecisionNumber LIKE @LegalDecisionNumber + '%')
	AND		(
				(@SupportingDecisionDateFrom IS NULL AND @LegalDecisionDateTo IS NULL)
				OR
				(@SupportingDecisionDateFrom IS NULL AND @LegalDecisionDateTo IS NOT NULL AND pd.SupportingDecisionDate BETWEEN GETDATE()-21000 AND @SupportingDecisionDateTo)
				OR
				(@SupportingDecisionDateFrom IS NOT NULL AND @LegalDecisionDateTo IS NULL AND pd.SupportingDecisionDate BETWEEN @SupportingDecisionDateFrom AND GETDATE()+21000)
				OR
				(@SupportingDecisionDateFrom IS NOT NULL AND @LegalDecisionDateTo IS NOT NULL AND pd.SupportingDecisionDate BETWEEN @SupportingDecisionDateFrom AND @SupportingDecisionDateTo)
			)
	AND		(@RuleStatus_Id = 0 OR pd.RuleStatus_Id = @RuleStatus_Id)

	SELECT * FROM @RESULTS
END
GO
CREATE PROCEDURE [dbo].[sp_GetRuleTypeForFilter]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleType_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--«·ﬂ·--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT RuleType_Id,
			Title
	FROM	RuleType
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END
GO
CREATE PROCEDURE [dbo].[sp_GetRuleSubTypeForFilter](@RuleType_Id bigint)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleSubType_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--«·ﬂ·--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT RuleSubType_Id,
			Title
	FROM	RuleSubType
	WHERE	RuleType_Id = @RuleType_Id
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END
GO
CREATE PROCEDURE [dbo].[sp_GetNationalityForFilter]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		Nationality_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--«·ﬂ·--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT Nationality_Id,
			Title
	FROM	Nationality
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END
GO