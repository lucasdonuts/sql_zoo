-- 1. How many stops are in the database.

SELECT COUNT(id)
  FROM stops;

-- 2. Find the id value for the stop 'Craiglockhart'

SELECT id
  FROM stops
  WHERE name = 'Craiglockhart';

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.

SELECT stops.id, stops.name
  FROM stops JOIN route ON stops.id = route.stop
  WHERE route.num = '4'
  AND route.company = 'LRT';

-- 4. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
  FROM route WHERE stop=149 OR stop=53
  GROUP BY company, num
  HAVING COUNT(*) > 1;

-- 5. Execute the self join shown and observe that b.stop gives all the
--    places you can get to from Craiglockhart, without changing routes.
--    Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
  FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
  WHERE a.stop = 53 AND b.stop = 149;

-- 6. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
--    If you are tired of these places try 'Fairmilehead' against 'Tollcross'.

SELECT a.company, a.num, stopa.name, stopb.name
  FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
  JOIN stops stopa ON (a.stop = stopa.id)
  JOIN stops stopb ON (b.stop = stopb.id)
  WHERE stopa.name = 'Craiglockhart'
  AND stopb.name = 'London Road';

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT a.company, a.num
  FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
  JOIN stops stopa ON stopa.id = a.stop
  JOIN stops stopb ON stopb.id = b.stop
  WHERE stopa.id = 115 AND stopb.id = 137
  GROUP BY a.company, a.num;

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT a.company, a.num
  FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
  JOIN stops stopa ON stopa.id = a.stop
  JOIN stops stopb ON stopb.id = b.stop
  WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross'
  GROUP BY a.company, a.num;

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus,
--    including 'Craiglockhart' itself, offered by the LRT company. Include the company and
--    bus no. of the relevant services.

SELECT DISTINCT stopb.name, a.company, a.num
  FROM route a JOIN route b ON a.company = b.company AND a.num = b.num
  JOIN stops stopa ON stopa.id = a.stop
  JOIN stops stopb ON stopb.id = b.stop
  WHERE a.company = 'LRT'
  AND (stopa.name = 'Craiglockhart')
  AND a.num = b.num;

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend.
--     Show the bus no. and company for the first bus, the name of the stop for the transfer,
--     and the bus no. and company for the second bus.

SELECT a.anum, a.acompany, a.middle, b.bnum, b.bcompany
  FROM
  (SELECT DISTINCT a.num AS anum, a.company AS acompany, stopb.name AS middle
     FROM route a JOIN route b ON a.num = b.num AND a.company = b.company
     JOIN stops stopa ON stopa.id = a.stop
     JOIN stops stopb ON stopb.id = b.stop
     WHERE stopa.name = 'Craiglockhart') AS a
  JOIN
  (SELECT DISTINCT b.num AS bnum, b.company AS bcompany, stopa.name AS middle
     FROM route a JOIN route b ON a.num = b.num AND a.company = b.company
     JOIN stops stopa ON stopa.id = a.stop
     JOIN stops stopb ON stopb.id = b.stop
     WHERE stopb.name = 'Lochend') AS b
  ON a.middle = b.middle
  ORDER BY a.anum, a.middle, b.bnum;