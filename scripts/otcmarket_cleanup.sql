CREATE TABLE "otcmarket".cleaned_otcmarket AS
SELECT DISTINCT
    SECID,
    CompID,
    Symbol,
    CUSIP,
    Issue,
    Venue,
    SecType,
    Class,
    CaveatEmptor,
    TierName,
    ClosingInsideBidPrice,
    ClosingInsideBidPriceDate,
    SecurityStatus,
    SharesOutstanding,
    SharesOutstandingAsOfDate
FROM
    otcmarket.hhc390ihqgzwa4hy
WHERE
    SECID IS NOT NULL AND
    CompID IS NOT NULL AND
    Symbol IS NOT NULL AND
    CUSIP IS NOT NULL AND
    Issue IS NOT NULL AND
    Venue IS NOT NULL AND
    SecType IS NOT NULL AND
    Class IS NOT NULL AND
    CaveatEmptor IS NOT NULL AND
    TierName IS NOT NULL AND
    ClosingInsideBidPrice IS NOT NULL AND
    ClosingInsideBidPriceDate IS NOT NULL AND
    SecurityStatus IS NOT NULL AND
    SharesOutstanding IS NOT NULL AND
    SharesOutstandingAsOfDate IS NOT NULL;
