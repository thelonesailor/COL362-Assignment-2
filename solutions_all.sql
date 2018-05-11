--1--

select player_name from player where batting_hand='Left-hand bat' and country_name='England' order by player_name;

--2--

SELECT player_name, extract(year FROM age(CAST('2018-02-12' AS timestamp), CAST(dob AS timestamp))) AS player_age FROM player WHERE bowling_skill = 'Legbreak googly' AND extract(year FROM age(CAST('2018-02-12' AS timestamp), CAST(dob AS timestamp))) >= 28  ORDER BY player_age DESC, player_name;

--3--

select match_id,toss_winner as tw from match where toss_decision='bat' order by match_id;

--6--

select match_id,foo6.team_1, foo6.name as team_2,winning_team_name,win_margin from ((select match_id,foo3.name as team_1,team_2,winning_team_name,win_margin from ((select match_id,team_1,team_2,name as winning_team_name,win_margin from ((select match_id, team_1,team_2, match_winner, win_margin from match where win_margin>=60 order by match_id)as t1 INNER JOIN team on t1.match_winner=team_id) as foo order by win_margin,match_id) as foo1 INNER JOIN team as foo2 on foo1.team_1=foo2.team_id)as foo3) as foo4 INNER JOIN team as foo5 on foo4.team_2=foo5.team_id) as foo6;

--7--

select player_name from player where batting_hand='Left-hand bat' and dob>'1988-02-12' order by player_name;

--8--

select match_id, sum(sum) from (select match_id, sum(runs_scored) from batsman_scored group by match_id UNION ALL select match_id, sum(extra_runs) from extra_runs group by match_id order by match_id) as t1 group by match_id;

--11--

SELECT kind_out AS out_type, COUNT(*) AS number FROM wicket_taken GROUP BY kind_out ORDER BY COUNT(*) DESC, kind_out;

--12--

select t.name , count(*) from team t, match m, player_match pm where m.match_id=pm.match_id and m.man_of_the_match=pm.player_id and t.team_id=pm.team_id group by t.name order by t.name;

--13--

with x as (select m.venue, count(*) from match m, extra_runs e where m.match_id=e.match_id and e.extra_type like 'wides' group by venue order by count(*) desc, venue limit 1) select x.venue from x;

--14--

select m.venue from match m, match m1 where m.match_id=m1.match_id and ((m.toss_winner=m1.match_winner and m.toss_decision like 'field') or (m.toss_winner<>m1.match_winner and m.toss_decision like 'bat')) group by m.venue order by count(*) desc, venue;

--15--

select player_name from player where player_id in (select bowler from (select tab.bowler as bowler, (trunc(totalruns/WICKETS,3)) as batavg from (select bowler, sum(runs) as totalruns from ( select bowler, sum(extra_runs) as runs from ball_by_ball natural join extra_runs group by bowler union all select bowler, sum(runs_scored) as runs from ball_by_ball natural join batsman_scored group by bowler ) as t1 group by bowler ) as tab JOIN (select bowler, count(player_out) as WICKETS from wicket_taken natural join ball_by_ball group by bowler ) as tab2 on tab.bowler = tab2.bowler )as X  where X.batavg in (select min(batavg) from (select tab.bowler as bowler, (trunc(totalruns/WICKETS,3)) as batavg from (select bowler, sum(runs) as totalruns from ( select bowler, sum(extra_runs) as runs from ball_by_ball natural join extra_runs group by bowler union all select bowler, sum(runs_scored) as runs from ball_by_ball natural join batsman_scored group by bowler ) as t1 group by bowler ) as tab JOIN (select bowler, count(player_out) as WICKETS from wicket_taken natural join ball_by_ball group by bowler ) as tab2 on tab.bowler = tab2.bowler ) as temp) )order by player_name;

--16--

select distinct p.player_name, t.name from player_match pm, match m, player p, team t where pm.role like 'CaptainKeeper' and pm.match_id=m.match_id and pm.team_id=m.match_winner and p.player_id=pm.player_id and pm.team_id=t.team_id order by p.player_name;

--18--

with b as (with a as (select b.match_id, b.striker, sum(bs.runs_scored) from ball_by_ball b, batsman_scored bs where b.match_id=bs.match_id and b.over_id = bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no group by b.match_id, b.striker having sum(bs.runs_scored)>=100) select a.match_id, a.striker, a.sum, m.match_winner, pm.team_id from a, match m, player_match pm where a.match_id=m.match_id and a.match_id=pm.match_id and pm.player_id=a.striker and pm.team_id<>m.match_winner) select player.player_name from player, b where player.player_id=b.striker order by player.player_name;

--19--

select foo2.match_id,v from (select match_id,team.name as t2,foo1.venue as v from (select match_id,team_1 as t,venue from match where match_winner!=team_1 UNION select match_id,team_2 as t,venue from match where match_winner!=team_2) as foo1 INNER JOIN team on foo1.t=team.team_id order by match_id) as foo2 where foo2.t2='Kolkata Knight Riders' order by foo2.match_id;

--20--

with z as (with a as (select b.striker, sum(bs.runs_scored) as total_runs from ball_by_ball b, batsman_scored bs, match m where b.match_id=bs.match_id and b.over_id=bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no and m.match_id=b.match_id and m.match_id=bs.match_id and m.season_id=5 group by b.striker), b as (select b.striker, b.match_id, sum(bs.runs_scored) from ball_by_ball b, batsman_scored bs, match m where b.match_id=bs.match_id and b.over_id=bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no and m.match_id=b.match_id and m.match_id=bs.match_id and m.season_id=5 group by b.striker, b.match_id), c as (select b.striker, count(*) as count from b group by b.striker) select player.player_name, round(a.total_runs,3)/round(c.count,3) as avg from player,a,c where a.striker=c.striker and player.player_id=a.striker order by avg desc,player.player_name limit 10) select z.player_name from z;

--21--

select country_name from (with w as (with x as (with z as (with a as (select b.striker, sum(bs.runs_scored) as total_runs from ball_by_ball b, batsman_scored bs, match m where b.match_id=bs.match_id and b.over_id=bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no and m.match_id=b.match_id and m.match_id=bs.match_id group by b.striker), b as (select b.striker, b.match_id, sum(bs.runs_scored) from ball_by_ball b, batsman_scored bs, match m where b.match_id=bs.match_id and b.over_id=bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no and m.match_id=b.match_id and m.match_id=bs.match_id group by b.striker, b.match_id), c as (select b.striker, count(*) as count from b group by b.striker) select player.player_name, round(a.total_runs,3)/round(c.count,3) as avg from player, a, c where a.striker=c.striker and player.player_id=a.striker order by avg desc,player.player_name) select z.player_name, z.avg, player.country_name from z, player where z.player_name = player.player_name) select x.country_name, sum(x.avg) as total from x group by x.country_name), y as (select p.country_name, count(*) as denom from player p group by p.country_name) select w.country_name, round(round(w.total,3)/round(y.denom,3),3) as cba from w,y where y.country_name=w.country_name order by cba desc,y.country_name limit 5) as t;

--following are the solutions for queries that could have multiple interpretations--

--4--

--Extra runs considered and innings wise runs added together for a match--
select over_id, sum(sum) as runs_scored from (select match_id,over_id, sum(extra_runs) from extra_runs group by match_id,over_id having match_id=335987 UNION ALL select match_id,over_id, sum(runs_scored) from batsman_scored group by match_id,over_id having match_id=335987) as foo group by foo.match_id, foo.over_id having sum(foo.sum)<=7 order by runs_scored desc, over_id;

--Extra runs considered and innings wise runs kept separate for a match--
select over_id, sum(sum) as runs_scored from (select match_id,over_id,innings_no,sum(extra_runs) from extra_runs group by match_id,over_id,innings_no having match_id=335987 UNION ALL select match_id,over_id,innings_no,sum(runs_scored) from batsman_scored group by match_id,over_id,innings_no having match_id=335987) as foo group by foo.match_id, foo.over_id, foo.innings_no having sum(sum)<=7 order by runs_scored desc, over_id;

--5--

--Names not repeated--
select distinct(player_name) from ((select player_id,player_name from player) as t1 INNER JOIN (select player_out from wicket_taken where kind_out='bowled') as t2 on t1.player_id=t2.player_out) as t3 order by player_name;

--Names repeated--
select player_name from ((select player_id,player_name from player) as t1 INNER JOIN (select player_out from wicket_taken where kind_out='bowled') as t2 on t1.player_id=t2.player_out) as t3 order by player_name;

--9--

--matchwise maximum runs--

select foo3.match_id, foo3.truns as maximum_runs, player.player_name from (select distinct foo2.match_id, foo2.innings_no, foo2.over_id, foo2.truns,ball_by_ball.bowler  from (select match_id, innings_no, over_id, sum(runs) as truns from(select match_id,innings_no, over_id, sum(runs_scored) as runs from batsman_scored group by match_id,innings_no, over_id union ALL select match_id,innings_no, over_id, sum(extra_runs) as runs from extra_runs group by match_id,innings_no, over_id) as foo group by match_id, innings_no, over_id ) as foo2 join ball_by_ball on foo2.match_id=ball_by_ball.match_id and foo2.innings_no=ball_by_ball.innings_no and foo2.over_id=ball_by_ball.over_id where (foo2.match_id, foo2.truns) in (select match_id, max(truns) as runs from (select match_id, innings_no, over_id, sum(runs) as truns from (select match_id,innings_no, over_id, sum(runs_scored) as runs from batsman_scored group by match_id,innings_no, over_id union ALL select match_id,innings_no, over_id, sum(extra_runs) as runs from extra_runs group by match_id,innings_no, over_id) as foo group by match_id, innings_no, over_id) as foo2 group by match_id) ) as foo3 join player on foo3.bowler=player.player_id order by foo3.match_id, foo3.over_id;

--innings wise maximum runs per match, match_id can be repeated--


select m2id as match_id, r2 as maximum_runs, player_name from (select m2id,o1id,i2,r2 from ((select match_id as m1id,over_id as o1id,innings_no as i1,sum(sum) as r1 from (select match_id,over_id,innings_no,sum(runs_scored) from batsman_scored group by match_id,over_id,innings_no UNION ALL select match_id,over_id,innings_no,sum(extra_runs) from extra_runs group by match_id,over_id,innings_no order by match_id) as foo group by foo.match_id,foo.over_id,foo.innings_no order by match_id) as T1 INNER JOIN (select match_id as m2id,innings_no as i2,max(sum) as r2 from (select match_id,over_id,innings_no,sum(sum) from (select match_id,over_id,innings_no,sum(runs_scored) from batsman_scored group by match_id,over_id,innings_no UNION ALL select match_id,over_id,innings_no,sum(extra_runs) from extra_runs group by match_id,over_id,innings_no order by match_id) as foo group by foo.match_id,foo.over_id,foo.innings_no order by match_id)as foo2 group by match_id,innings_no order by match_id) as T2 on T1.m1id=T2.m2id and T1.i1=T2.i2 and T1.r1=T2.r2) as Tfin) as x1 INNER JOIN (select distinct p3.match_id,p3.over_id,p3.innings_no,p3.player_name from ((select match_id,over_id,innings_no,bowler from ball_by_ball) as p1 INNER JOIN (select player_id,player_name from player)as p2 on p1.bowler=p2.player_id)as p3) as x2 on x1.m2id=x2.match_id and x1.o1id=x2.over_id and x1.i2=x2.innings_no order by m2id,o1id;


--10--

--0 run outs not included--
select player_name,count as number from (select player_out,count(kind_out) from wicket_taken group by player_out,kind_out having kind_out='run out') as t1 INNER JOIN (select player_id,player_name from player) as t2 ON t1.player_out=t2.player_id order by count desc, player_name;

--NULL/0 run outs included--
select distinct foo2.player_name,foo2.count as number from ((select foo.id1,foo.count from ((select player_out as id1 from wicket_taken) as t1 LEFT JOIN (select player_out,count(kind_out) from wicket_taken group by player_out,kind_out having kind_out='run out') as t2 on t1.id1=t2.player_out) as foo) as x1 INNER JOIN (select player_id,player_name from player) as x2 ON x1.id1=x2.player_id) as foo2 order by count desc,player_name; 

--NULL/0 runs included, using player table (instead of wicket_taken table)--
select distinct foo2.player_name,foo2.count as number from ((select foo.id1,foo.count from ((select player_id as id1 from player) as t1 LEFT JOIN (select player_out,count(kind_out) from wicket_taken group by player_out,kind_out having kind_out='run out') as t2 on t1.id1=t2.player_out) as foo) as x1 INNER JOIN (select player_id,player_name from player) as x2 ON x1.id1=x2.player_id) as foo2 order by count desc,player_name;

--17--
--matchwise total--
with a as (select b.match_id, b.striker, sum(bs.runs_scored) as total from ball_by_ball b, batsman_scored bs where b.match_id=bs.match_id and b.over_id = bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no group by b.match_id, b.striker having sum(bs.runs_scored)>=50) select p.player_name, a.total from player p, a where a.striker=p.player_id order by a.total desc, p.player_name;

--inningwise total--
with a as (select b.match_id, b.striker, sum(bs.runs_scored) as total from ball_by_ball b, batsman_scored bs where b.match_id=bs.match_id and b.over_id = bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no group by b.match_id, b.striker,b.innings_no having sum(bs.runs_scored)>=50) select p.player_name, a.total from player p, a where a.striker=p.player_id order by a.total desc, p.player_name;

--choose players who have scored at least 50 in an innings once in their careers, then output the runs scored by them in all the matches

with b1 as (with a as (select b.match_id, b.striker, sum(bs.runs_scored) as total from ball_by_ball b, batsman_scored bs where b.match_id=bs.match_id and b.over_id = bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no group by b.match_id, b.striker having sum(bs.runs_scored)>=50) select distinct p.player_name from player p, a where a.striker=p.player_id), c as (select b.match_id, b.striker, sum(bs.runs_scored) as total from ball_by_ball b, batsman_scored bs where b.match_id=bs.match_id and b.over_id = bs.over_id and b.ball_id=bs.ball_id and b.innings_no=bs.innings_no group by b.match_id, b.striker) select b1.player_name, c.total from b1, c, player p where b1.player_name like p.player_name and p.player_id=c.striker order by c.total desc, b1.player_name;
