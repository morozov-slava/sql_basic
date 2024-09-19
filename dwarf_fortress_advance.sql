-- 1. Найдите все отряды, у которых нет лидера.
-- (в описании таблицы 'Squads' не сказано, допускается ли NULL для поля 'leader_id'. Предположим, что да для решения)
SELECT
  squad_id,
  name
FROM
  Squads
WHERE
  leader_id IS NULL

-- 2. Получите список всех гномов старше 150 лет, у которых профессия "Warrior".
SELECT 
  dwarf_id,
  name
FROM
  Dwarves
WHERE
  age > 150
  AND profession = 'Warrior'
  
-- 3. Найдите гномов, у которых есть хотя бы один предмет типа "weapon".
SELECT
  owner_id as dwarf_id
FROM
  Items
WHERE
  owner_id IS NOT NULL
  and type = 'weapon'
GROUP BY
  owner_id

-- 4. Получите количество задач для каждого гнома, сгруппировав их по статусу.
-- (не до конца было понятно, нужно ли учитывать задачи, по которым ещё не был назначен гном. Решил их не учитывать, т.к. фактически гнома по ней нет)
SELECT 
  status,
  count(task_id) as n_tasks
FROM
  Tasks
WHERE
  assigned_to IS NOT NULL
GROUP BY
  status

-- 5. Найдите все задачи, которые были назначены гномам из отряда с именем "Guardians".
SELECT
  s.squad_id,
  s.name,
  s.leader_id,
  t.task_id,
  t.description,
  t.status
FROM
  Squads s
JOIN
  Tasks t
ON
  s.leader_id = t.assigned_to
WHERE
  s.name = 'Guardians'

-- 6. Выведите всех гномов и их ближайших родственников, указав тип родственных отношений. 
SELECT 
  dwarf_id,
  related_to,
  relationship
FROM
  Relationships
WHERE
  relationship = 'Родитель'


