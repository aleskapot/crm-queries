SELECT -- top 100
       CASE
           WHEN empl._Fld1850RRef = 0xA5BA88039F4BFE3C463072DC5545798F THEN N'г-н'
           WHEN empl._Fld1850RRef = 0x90B3BFE98C983A0F4C9791EDF293AC4B THEN N'г-жа'
           ELSE ''
           END                                                                   AS 'Обращение',
       trim(empl._Fld1838)                                                       as 'Имя',
       trim(empl._Fld1845)                                                       as 'Фамилия',
       trim(empl._Fld1841)                                                       as 'Отчество',
       trim(empl._Description)                                                   as 'Имя, Фамилия',
       org._Description                                                          as 'Компания',
       N'CRM-форма'                                                              as 'Источник',
       N'нет'                                                                    as 'Экспорт',
       N'да'                                                                     as 'Доступен для всех',
       -- empl.*,
       COALESCE((SELECT top 1 c._Fld1857
                 FROM [CRM30].[dbo].[_Reference103_VT1853] c
                 WHERE empl._IDRRef = c._Reference103_IDRRef
                   AND c._Fld1856RRef = 0x829E8C89A55BE7E711E686FF14CEB873), '') as 'Мобильный телефон',
       COALESCE((SELECT top 1 c._Fld1857
                 FROM [CRM30].[dbo].[_Reference103_VT1853] c
                 WHERE empl._IDRRef = c._Reference103_IDRRef
                   AND c._Fld1856RRef = 0x829E8C89A55BE7E711E686FF14CEB875), '') as 'Рабочий телефон',
       COALESCE((SELECT top 1 c._Fld1857
                 FROM [CRM30].[dbo].[_Reference103_VT1853] c
                 WHERE empl._IDRRef = c._Reference103_IDRRef
                   AND c._Fld1856RRef = 0x829E8C89A55BE7E711E686FF14CEB874), '') as 'Рабочий e-mail',
       COALESCE((SELECT top 1 c._Fld1857
                 FROM [CRM30].[dbo].[_Reference103_VT1853] c
                 WHERE empl._IDRRef = c._Reference103_IDRRef
                   AND c._Fld1856RRef = 0xBA97005056C0000811EE74ED6E57C169), '') as 'Другой e-mail',
       COALESCE((SELECT top 1 pos._Description
                 FROM [CRM30].[dbo].[_Reference26] pos
                 WHERE empl._Fld1837RRef = pos._IDRRef
                   AND pos._Marked = 0), '')                                     as 'Должность',
       COALESCE(org._Fld2182, '')                                                as 'ИНН'
FROM [CRM30].[dbo].[_Reference103] empl
         JOIN [CRM30].[dbo].[_Reference118] org on empl._OwnerIDRRef = org._IDRRef
-- LEFT JOIN [CRM30].[dbo].[_Reference103_VT1853] cont
-- on empl._IDRRef = cont._Reference103_IDRRef
WHERE 1 = 1
  AND empl._Marked = 0
  AND empl._Description <> '-'
-- AND empl._OwnerIDRRef = 0x866F7824AF3CC6F011E68EBB6813DE2A