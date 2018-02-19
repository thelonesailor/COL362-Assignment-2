--1--

select player_name from player where batting_hand='Left-hand bat' and country_name='England' order by player_name asc;

--3--

select match_id,toss_winner from match where toss_decision='bat' order by match_id asc;

--5--

select player_name from player join (select striker from ball_by_ball group by striker)as t1 on player_id=striker order by player_name asc;

--7--

select player_name from player where batting_hand='Left-hand bat' and 30 > (SELECT EXTRACT(YEAR from AGE('2018-12-02', dob))) order by player_name asc;

--9--

select match_id,maximum_runs,player_name from
(select match_id,overruns2 as maximum_runs,bowler
from (SELECT t1.match_id,over_id,innings_no,overruns2
from (select match_id,over_id,innings_no,SUM(runs_scored) as overruns2  from batsman_scored group by match_id,over_id,innings_no order by match_id,over_id) as t1,
(select match_id,MAX(overruns) as mor from (select match_id,over_id,innings_no,SUM(runs_scored) as overruns from batsman_scored group by match_id,over_id,innings_no order by match_id,over_id) as t3 group by match_id) as t2
where t1.match_id = t2.match_id and t1.overruns2=t2.mor) as t4 natural join (select match_id,over_id,innings_no,bowler from ball_by_ball group by match_id,over_id,innings_no,bowler order by match_id,over_id) as t5 order by match_id asc) as t6,player where player_id=bowler;

--11--

select kind_out as out_type, number from (select player_out,kind_out,count(ball_id) as number from wicket_taken group by player_out,kind_out)as t1 order by number desc,out_type asc;

--13--

select venue from (select venue,num from match natural join (select match_id,count(match_id) as num from (select match_id from extra_runs where extra_type='wides') as t1 group by match_id order by num desc) as t2 order by num desc,venue asc)as t3 limit 1;

--15--

WITH t1 AS (
    SELECT match_id,over_id,ball_id,innings_no,runs_scored+er as runs
    from(
    SELECT match_id,over_id,ball_id,innings_no,coalesce(extra_runs, 0) as er,runs_scored
    FROM batsman_scored  natural left outer join (select * from extra_runs where extra_type in ('noballs','wides'))as t7)as t6
),
     t2 as(
         SELECT match_id,over_id,ball_id,innings_no
         FROM wicket_taken
         where kind_out in ('stumped','caught','lbw','caught and bowled','hit wicket','bowled')
     ),
     t3 as (
         select bowler,sum(runs) as sr
         from t1 natural join ball_by_ball group by bowler
     ),
     t4 as (
         select bowler,count(bowler) as cb
         from t2 natural join ball_by_ball group by bowler
     )
select player_name from (select player_name,avg from (select bowler,round((sr::numeric/cb),3) as avg from t3 natural join t4) as t5 join player on t5.bowler=player.player_id order by avg asc,player_name asc)as final;

--17--

with t5 as(select match_id,innings_no,striker,sum(runs_scored) as runs from (select * from ball_by_ball natural join batsman_scored) as t1 group by match_id,innings_no,striker),
t6 as(select striker,sum(runs) as runs_scored from t5 group by striker),
t7 as(select distinct striker from t5 where runs>=50),
t8 as(select striker,runs_scored from t6 where striker in (select distinct striker from t5 where runs>=50))
select player_name,runs_scored from t8,player where player_id=striker  order by runs_scored desc,player_name asc;

--19---

select match_id,venue from match where ((team_1 in (select team_id from team where name='Kolkata Knight Riders') or team_2 in (select team_id from team where name='Kolkata Knight Riders')) and match_winner not in (select team_id from team where name='Kolkata Knight Riders')) order by match_id asc;
