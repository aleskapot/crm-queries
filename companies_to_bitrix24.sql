SELECT -- top 25
       -- CONVERT(UNIQUEIDENTIFIER, org._IDRRef) as uuid,  -- Cast
       org._Description                 as 'Название компании',
       org._Fld2203                     as 'Полное название компании',
       CASE
           WHEN org._Fld7766 LIKE N'Поставщик%' THEN N'Поставщик'
           WHEN org._Fld7766 LIKE N'Покупатель%' THEN N'Клиент'
           ELSE org._Fld7766
           END                          AS 'Тип компании',
       N'Производство'                  as 'Сфера деятельности',
       'RUB'                            as 'Валюта',
       org._Fld2202                     as 'Комментарий',
       COALESCE(org._Fld2182, '')       as 'ИНН',
       COALESCE(org._Fld2184, '')       as 'КПП',
       TRIM(COALESCE(org._Fld2187, '')) as 'ОГРН',
       COALESCE(t_em.content, '')       as 'Рабочий e-mail',
       COALESCE(t_ph.content, '')       as 'Рабочий телефон',
       COALESCE(t_cph.content, '')      as 'Мобильный телефон',
       COALESCE(t_web.content, '')      as 'Корпоративный сайт',
       COALESCE(t_addr.content, '')     as 'Адрес',
       N'Организация'                   as 'Реквизит: Шаблон',
       org._Description                 as 'Реквизит: Название',
       N'Юридический адрес'             as 'Реквизит (Россия): Адрес - тип'
-- COALESCE(t_cont.content, '') as 'Контакт',
-- COALESCE(t_empl.employee_name, '') as 'Другой контакт'
-- COALESCE(t_empl.employee_contacts, '')
FROM [CRM30].[dbo].[_Reference118] org
         LEFT JOIN (SELECT em._Reference118_IDRRef                                                 as id,
                           STRING_AGG(TRIM(em._Fld2217), ', ') WITHIN GROUP (ORDER BY em._Fld2217) as content
                    FROM [CRM30].[dbo].[_Reference118_VT2213] em
                    WHERE em._Fld2216RRef = 0x829E8C89A55BE7E711E686FF14CEB868
                    GROUP BY em._Reference118_IDRRef) t_em ON org._IDRRef = t_em.id
         LEFT JOIN (SELECT ph._Reference118_IDRRef                                                 as id,
                           STRING_AGG(TRIM(ph._Fld2217), ', ') WITHIN GROUP (ORDER BY ph._Fld2217) as content
                    FROM [CRM30].[dbo].[_Reference118_VT2213] ph
                    WHERE ph._Fld2216RRef = 0x829E8C89A55BE7E711E686FF14CEB869
                    GROUP BY ph._Reference118_IDRRef) t_ph ON org._IDRRef = t_ph.id
         LEFT JOIN (SELECT cph._Reference118_IDRRef                                                  as id,
                           STRING_AGG(TRIM(cph._Fld2217), ', ') WITHIN GROUP (ORDER BY cph._Fld2217) as content
                    FROM [CRM30].[dbo].[_Reference118_VT2213] cph
                    WHERE cph._Fld2216RRef = 0x829E8C89A55BE7E711E686FF14CEB86E
                    GROUP BY cph._Reference118_IDRRef) t_cph ON org._IDRRef = t_cph.id
         LEFT JOIN (SELECT web._Reference118_IDRRef                                                  as id,
                           STRING_AGG(TRIM(web._Fld2217), ', ') WITHIN GROUP (ORDER BY web._Fld2217) as content
                    FROM [CRM30].[dbo].[_Reference118_VT2213] web
                    WHERE web._Fld2216RRef = 0x829E8C89A55BE7E711E686FF14CEB86A
                    GROUP BY web._Reference118_IDRRef) t_web ON org._IDRRef = t_web.id
         LEFT JOIN (SELECT addr._Reference118_IDRRef as id,
                           TRIM(MAX(addr._Fld2217))  as content
                    FROM [CRM30].[dbo].[_Reference118_VT2213] addr
                    WHERE addr._Fld2216RRef = 0x866F7824AF3CC6F011E68EB8A562CFB2
                    GROUP BY addr._Reference118_IDRRef) t_addr ON org._IDRRef = t_addr.id
--     LEFT JOIN (
--         SELECT
--             cont._OwnerIDRRef as id,
--             STRING_AGG(TRIM(NULLIF(cont._Description, '')), ', ') as content
--             -- MIN(cont._Description) as content
--         FROM [CRM30].[dbo].[_Reference103] cont
--         WHERE cont._Marked = 0
--         GROUP BY
--             cont._OwnerIDRRef
--     ) t_cont ON org._IDRRef = t_cont.id
--          LEFT JOIN (SELECT empl._OwnerIDRRef,
--                            empl._Description                                 as employee_name,
--                            STRING_AGG(TRIM(NULLIF(cont._Fld1857, '')), ', ') as employee_contacts
--                     FROM [CRM30].[dbo].[_Reference103] empl
--                              LEFT JOIN [CRM30].[dbo].[_Reference103_VT1853] cont
--                                        on empl._IDRRef = cont._Reference103_IDRRef
--                     WHERE 1 = 1
--                       AND empl._Marked = 0
--                       AND empl._Description <> '-'
--                     GROUP BY empl._OwnerIDRRef,
--                              empl._Description) t_empl on org._IDRRef = t_empl._OwnerIDRRef
WHERE 1 = 1
  AND org._Marked = 0
-- AND org._Description = 'Compony_Name'
    AND LEN(TRIM(COALESCE(org._Fld2187, ''))) > 13
ORDER BY org._IDRRef
-- OFFSET 10 ROWS -- Skip 10 rows
-- FETCH NEXT 10 ROWS ONLY; -- Return the next 5 rows