# Источники лидов (с органикой)
WITH LASTPAIDCLICK AS (
    SELECT
        S.VISITOR_ID,
        S.VISIT_DATE,
        L.CREATED_AT,
        L.LEAD_ID,
        L.STATUS_ID,
        L.AMOUNT,
        S.SOURCE AS UTM_SOURCE,
        S.MEDIUM AS UTM_MEDIUM,
        S.CAMPAIGN AS UTM_CAMPAIGN,
        to_char(S.VISIT_DATE, 'YYYY-MM-DD') AS VISIT_DATES,
        row_number()
            OVER (PARTITION BY S.VISITOR_ID ORDER BY S.VISIT_DATE DESC)
            AS RW
    FROM SESSIONS AS S
    FULL JOIN LEADS AS L ON S.VISITOR_ID = L.VISITOR_ID
)
SELECT
    count(SUB.VISITOR_ID) as visitors,
    SUB.UTM_SOURCE,
    count(SUB.LEAD_ID) as leads,
    sum(SUB.AMOUNT) as revenue
FROM SESSIONS AS S
LEFT JOIN LEADS AS L
    ON S.VISITOR_ID = L.VISITOR_ID
LEFT JOIN LASTPAIDCLICK AS SUB
    ON S.VISITOR_ID = SUB.VISITOR_ID
WHERE RW = 1
GROUP BY
    SUB.UTM_SOURCE
ORDER BY
    visitors
    
 #	Источники лидов (без органики)

    WITH LASTPAIDCLICK AS (
    SELECT
        S.VISITOR_ID,
        S.VISIT_DATE,
        L.CREATED_AT,
        L.LEAD_ID,
        L.STATUS_ID,
        L.AMOUNT,
        S.SOURCE AS UTM_SOURCE,
        S.MEDIUM AS UTM_MEDIUM,
        S.CAMPAIGN AS UTM_CAMPAIGN,
        to_char(S.VISIT_DATE, 'YYYY-MM-DD') AS VISIT_DATES,
        row_number()
            OVER (PARTITION BY S.VISITOR_ID ORDER BY S.VISIT_DATE DESC)
            AS RW
    FROM SESSIONS AS S
    FULL JOIN LEADS AS L ON S.VISITOR_ID = L.VISITOR_ID
    WHERE S.MEDIUM != 'organic'
)
SELECT
    count(SUB.VISITOR_ID) as visitors,
    SUB.UTM_SOURCE,
    count(SUB.LEAD_ID) as leads,
    sum(SUB.AMOUNT) as revenue
FROM SESSIONS AS S
LEFT JOIN LEADS AS L
    ON S.VISITOR_ID = L.VISITOR_ID
LEFT JOIN LASTPAIDCLICK AS SUB
    ON S.VISITOR_ID = SUB.VISITOR_ID
WHERE RW = 1
GROUP BY
    SUB.UTM_SOURCE
ORDER BY
    visitors
    
#Выручка от источников (с органикой)
WITH LASTPAIDCLICK AS (
    SELECT
        S.VISITOR_ID,
        S.VISIT_DATE,
        L.CREATED_AT,
        L.LEAD_ID,
        L.STATUS_ID,
        L.AMOUNT,
        S.SOURCE AS UTM_SOURCE,
        S.MEDIUM AS UTM_MEDIUM,
        S.CAMPAIGN AS UTM_CAMPAIGN,
        to_char(S.VISIT_DATE, 'YYYY-MM-DD') AS VISIT_DATES,
        row_number()
            OVER (PARTITION BY S.VISITOR_ID ORDER BY S.VISIT_DATE DESC)
            AS RW
    FROM SESSIONS AS S
    FULL JOIN LEADS AS L ON S.VISITOR_ID = L.VISITOR_ID
)
SELECT
    count(SUB.VISITOR_ID) as visitors,
    SUB.UTM_SOURCE,
    count(SUB.LEAD_ID) as leads,
    sum(SUB.AMOUNT) as revenue
FROM SESSIONS AS S
LEFT JOIN LEADS AS L
    ON S.VISITOR_ID = L.VISITOR_ID
LEFT JOIN LASTPAIDCLICK AS SUB
    ON S.VISITOR_ID = SUB.VISITOR_ID
WHERE RW = 1
GROUP BY
    SUB.UTM_SOURCE
ORDER BY
    visitors
    
# Доход от источников (без органики)
WITH LASTPAIDCLICK AS (
    SELECT
        S.VISITOR_ID,
        S.VISIT_DATE,
        L.CREATED_AT,
        L.LEAD_ID,
        L.STATUS_ID,
        L.AMOUNT,
        S.SOURCE AS UTM_SOURCE,
        S.MEDIUM AS UTM_MEDIUM,
        S.CAMPAIGN AS UTM_CAMPAIGN,
        to_char(S.VISIT_DATE, 'YYYY-MM-DD') AS VISIT_DATES,
        row_number()
            OVER (PARTITION BY S.VISITOR_ID ORDER BY S.VISIT_DATE DESC)
            AS RW
    FROM SESSIONS AS S
    FULL JOIN LEADS AS L ON S.VISITOR_ID = L.VISITOR_ID
    WHERE S.MEDIUM != 'organic'
)
SELECT
    count(SUB.VISITOR_ID) as visitors,
    SUB.UTM_SOURCE,
    count(SUB.LEAD_ID) as leads,
    sum(SUB.AMOUNT) as revenue
FROM SESSIONS AS S
LEFT JOIN LEADS AS L
    ON S.VISITOR_ID = L.VISITOR_ID
LEFT JOIN LASTPAIDCLICK AS SUB
    ON S.VISITOR_ID = SUB.VISITOR_ID
WHERE RW = 1
GROUP BY
    SUB.UTM_SOURCE
ORDER BY
    visitors
