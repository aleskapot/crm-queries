SELECT CONVERT(UNIQUEIDENTIFIER, org._IDRRef) as uuid,  -- Cast to canonical form
       org._Description                       as short_name,
       org._Fld2203                           as full_name,
       NULLIF(org._Fld2182, '')               as inn,
       NULLIF(org._Fld2184, '')               as kpp,
       t_req.requsites,
       t_empl.employee_name,
       t_empl.employee_contacts
FROM [CRM30].[dbo].[_Reference118] org
    LEFT JOIN (
    SELECT
    req._Reference118_IDRRef, STRING_AGG(req._Fld2217, ' | ') WITHIN GROUP (ORDER BY req._Fld2217 ASC) as requsites
    FROM [CRM30].[dbo].[_Reference118_VT2213] req
    GROUP BY
    req._Reference118_IDRRef
    ) t_req
ON org._IDRRef = t_req._Reference118_IDRRef
    LEFT JOIN (
    SELECT
    empl._OwnerIDRRef,
    empl._Description as employee_name,
    STRING_AGG(NULLIF (cont._Fld1857, ''), ' | ') as employee_contacts
    FROM [CRM30].[dbo].[_Reference103] empl
    LEFT JOIN [CRM30].[dbo].[_Reference103_VT1853] cont on empl._IDRRef = cont._Reference103_IDRRef
    WHERE 1=1
    AND empl._Marked = 0
    AND empl._Description <> '-'
    GROUP BY
    empl._OwnerIDRRef,
    empl._Description
    ) t_empl on t_empl._OwnerIDRRef = org._IDRRef
WHERE 1=1
-- AND org._Description LIKE '%COMPANY_NAME%'