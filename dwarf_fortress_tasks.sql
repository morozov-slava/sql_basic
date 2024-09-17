-- 1. Получить информацию о всех гномах, которые входят в какой-либо отряд, вместе с информацией об их отрядах. 
SELECT
  dw.dwarf_id,
  dw.name,       
  dw.age,
  dw.profession,
  dw.squad_id,
  sq.name as squad_name,
  sq.mission
FROM 
  Dwarves dw
INNER JOIN
  Squads sq
ON
  dw.squad_id = sq.squad_id
  
-- 2. Найти всех гномов с профессией "miner", которые не состоят ни в одном отряде.
SELECT
  dwarf_id,
FROM 
  Dwarves dw
WHERE
  profession = 'miner'
  AND squad_id IS NOT NULL
  
-- 3. Получить все задачи с наивысшим приоритетом, которые находятся в статусе "pending".
-- (здесь не очень понятно, как идентифицировать наивысший приоритет)
-- (предположил, что те задачи, которые в данный момент времени имеют наименьшее значение по полю 'priority' являются наивысшими)
SELECT
  task_id
FROM
  Tasks
WHERE
  status = 'pending'
  AND priority = NVL(SELECT MIN(priority) FROM Tasks, 0)

-- 4. Для каждого гнома, который владеет хотя бы одним предметом, получить количество предметов, которыми он владеет.
-- (здесь не очень понятно, если предмет является общим, то мы учитываем его для каждого гнома или нет (решение без учёта общих предметов))
SELECT
  owner_id,
  count(item_id) as n_items
FROM
  Items
WHERE
  owner_id IS NOT NULL
GROUP BY
  owner_id

-- 5. Получить список всех отрядов и количество гномов в каждом отряде. Также включите в выдачу отряды без гномов.
WITH SquadComposition as (
  SELECT
     squad_id,
     count(dwarf_id) as n_dwarves_in_squad
  FROM 
    Dwarves dw
  WHERE
    squad_id IS NOT NULL
  GROUP BY
    squad_id
)
SELECT
  sq.squad_id,
  NVL(sc.n_dwarves_in_squad, 0) as n_dwarves_in_squad
FROM
  Squads sq
LEFT JOIN
  SquadComposition sc
ON
  sq.squad_id = sc.squad_id

-- 6. Получить список профессий с наибольшим количеством незавершённых задач ("pending" и "in_progress") у гномов этих профессий.
WITH NotCompletedTasks as (
  SELECT 
     assigned_to
     status
  FROM
     Tasks
  WHERE
     status IN ('pending', 'in_progress')
     AND assigned_to IS NOT NULL
) 
SELECT
  dw.profession,
  count(nct.assigned_to) as n_not_completed_tasks
FROM
  NotCompletedTasks nct
LEFT JOIN
  Dwarves dw
ON
  nct.assigned_to = dw.dwarf_id
GROUP BY
  dw.profession
ORDER BY 
  count(nct.assigned_to)

-- 7. Для каждого типа предметов узнать средний возраст гномов, владеющих этими предметами.
SELECT
  it.type,
  AVG(dw.age) as avg_dwarf_age
FROM
  Items it
LEFT JOIN
  Dwarves dw
ON
  it.owner_id = dw.dwarf_id
WHERE
  it.owner_id IS NOT NULL
GROUP BY
  it.type
  
-- 8. Найти всех гномов старше среднего возраста (по всем гномам в базе), которые не владеют никакими предметами. 
WITH DwarvesItems AS (
  SELECT
    owner_id,
    count(item_id) AS n_items
  FROM
    Items
  WHERE
    owner_id IS NOT NULL
  GROUP BY
    owner_id
) 
SELECT 
  dw.dwarf_id
FROM
(
  SELECT
     dw.dwarf_id,
     NVL(di.n_items, 0) as n_items
  FROM
     Dwarves dw
  LEFT JOIN
     DwarvesItems di
  ON
     dw.dwarf_id = di.owner_id
  WHERE
     dw.age > (SELECT AVG(age) FROM Dwarves)
)
WHERE
   n_items = 0






