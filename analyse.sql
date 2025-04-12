-- modify table name
RENAME TABLE updated_gov_debt.wb_data TO updated_gov_debt.reserves_to_debt

SELECT *
FROM updated_gov_debt.reserves_to_debt

-- Five top and bottom countries regarding the reserves-to-debt ratio in 2023
(
SELECT country_name, y_2023,
'Highest' AS reserves_debt
FROM updated_gov_debt.reserves_to_debt
WHERE y_2023 != 0
ORDER BY y_2023 DESC
LIMIT 5
) 
UNION ALL
(
SELECT country_name, y_2023,
'Lowest' AS reserves_debt
FROM updated_gov_debt.reserves_to_debt
WHERE y_2023 != 0
ORDER BY y_2023 ASC
LIMIT 5
)

-- Show trends over time for top 5
WITH top_five AS (
SELECT country_name, y_2023
FROM updated_gov_debt.reserves_to_debt
WHERE y_2023 != 0
ORDER BY y_2023 DESC
LIMIT 5
) 
SELECT
  r.country_name,
  COALESCE(NULLIF(r.y_2007, 0), 'NA') AS y_2007, -- if y_2010 equals 0,put NULL. Then COALESCE says - put there rather NA
  COALESCE(NULLIF(r.y_2008, 0), 'NA') AS y_2008,
  COALESCE(NULLIF(r.y_2009, 0), 'NA') AS y_2009,
  COALESCE(NULLIF(r.y_2010, 0), 'NA') AS y_2010,
  COALESCE(NULLIF(r.y_2011, 0), 'NA') AS y_2011,
  r.y_2015, r.y_2016, r.y_2017, r.y_2018,
  r.y_2019, r.y_2020, r.y_2021, r.y_2022,
  r.y_2023
FROM updated_gov_debt.reserves_to_debt AS r
JOIN top_five AS t
  ON r.country_name = t.country_name
ORDER BY r.y_2023 DESC;



SELECT 
  country_name,
  y_2023 AS y_23,
  ROUND((
    y_2007 + y_2008 + y_2009 + y_2010 + y_2011 +
    y_2012 + y_2013 + y_2014 + y_2015 + y_2016 +
    y_2017 + y_2018 + y_2019 + y_2020 + y_2021 +
    y_2022 + y_2023
  ) / 17, 2) AS avg_07_23
FROM updated_gov_debt.reserves_to_debt
WHERE country_name IN (
  'Albania', 'Belarus', 'Bosnia and Herzegovina',
  'Moldova', 'Montenegro', 'North Macedonia', 'Serbia', 'Ukraine'
)
ORDER BY y_2023 DESC;