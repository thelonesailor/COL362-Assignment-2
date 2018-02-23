--1--

select player_name ,Extract (years from age('2018-02-12',dob)) as player_age 
from (select * from player where bowling_skill='Legbreak googly') as Legbreaks where Extract (years from age('2018-02-12',dob))>=28 
order by player_age desc,player_name asc;

--2--

select player_name ,Extract (years from age('2018-02-12',dob)) as player_age from player where Extract (years from age('2018-02-12',dob))>=28 order by player_age desc,player_name asc;

--3--

select match_id,toss_winner from match where toss_decision='bat' order by match_id asc;

--4--

select over_id, runs_scored
from (select over_id,innings_no, sum(runs_scored) as runs_scored
from ((select over_id,innings_no,sum(runs_scored) as runs_scored
from ball_by_ball Natural Join batsman_scored
group by (match_id,innings_no,over_id)
having match_id=335987)
union
(select over_id,innings_no,sum(extra_runs) as runs_scored
from extra_runs
group by (match_id,innings_no,over_id)
having match_id=335987) ) as accu_overscores
group by(over_id,innings_no)) as accumulated_both
where runs_scored<=7
order by runs_scored desc,over_id asc;

--5--

select player_name from player join (select striker from ball_by_ball group by striker)as t1 on player_id=striker order by player_name asc;

--6--

select match_id,team_1,name as team_2,winning_team_name,win_margin
from (select match_id,name as team_1,team_2,winning_team_name,win_margin
from (select match_id,team_1,team_2,name as winning_team_name,win_margin
from match JOIN team
on team.team_id=match.match_winner
where win_margin>=60 and win_type='runs') as complete_ids,team
where team_1=team_id) as replaced_1,team
where team_2=team_id
order by win_margin asc,match_id asc;

--7--

select player_name from player where batting_hand='Left-hand bat' and 30 > (SELECT EXTRACT(YEAR from AGE('2018-12-02', dob))) order by player_name asc;

--8--

-----innings separate
select match_id,total_runs
from (
	select match_id,sum(runs_scored) as total_runs
from ball_by_ball Natural JOIN batsman_scored
group by match_id) as match_total
order by match_id asc;

--9--

with bs as(
    SELECT match_id,over_id,ball_id,innings_no,runs_scored+er as runs_scored
    from(SELECT match_id,over_id,ball_id,innings_no,coalesce(extra_runs, 0) as er,runs_scored
    FROM batsman_scored  natural left outer join extra_runs)as t6
)
select match_id,maximum_runs,player_name from
(select match_id,over_id,maximum_runs,player_name from
(select match_id,over_id,overruns2 as maximum_runs,bowler
from (SELECT t1.match_id,over_id,innings_no,overruns2
from (select match_id,over_id,innings_no,SUM(runs_scored) as overruns2  from bs group by match_id,over_id,innings_no order by match_id,over_id) as t1,
(select match_id,MAX(overruns) as mor from (select match_id,over_id,innings_no,SUM(runs_scored) as overruns from batsman_scored group by match_id,over_id,innings_no order by match_id,over_id) as t3 group by match_id) as t2
where t1.match_id = t2.match_id and t1.overruns2=t2.mor order by t1.match_id asc,over_id asc) as t4 natural join (select match_id,over_id,innings_no,bowler from ball_by_ball group by match_id,over_id,innings_no,bowler order by match_id asc,over_id asc) as t5 order by match_id asc,over_id asc) as t6,player where player_id=bowler order by match_id asc,over_id asc)as t8;

--10--

--with 0's as well
select * from
(select player_name,COALESCE(number,0) as number
from(
	select player_out as player_id, count(player_out) as number
	from (select * from wicket_taken where kind_out='run out') as run_out_table
	group by (player_id)) as player_run_out  Natural Right Outer Join player) as player_run_out
order by number desc,player_name asc;

--11--

select kind_out as out_type, number from (select kind_out,count(ball_id) as number from wicket_taken group by kind_out)as t1 order by number desc,out_type asc;

--12--

select name,number
from(select team_id,count(match_id) as number
from(select match_id,man_of_the_match as player_id
from  match) as match_MoM Natural Join player_match
group by team_id) as teamid_MoM_count Natural Join team
order by name asc;

--13--

select venue from (select venue,num from match natural join (select match_id,count(match_id) as num from (select match_id from extra_runs where extra_type='wides') as t1 group by match_id order by num desc) as t2 order by num desc,venue asc)as t3 limit 1;

--14--

select venue
from (select venue,count(venue) as count_venue
from(select venue
from match
where win_type='wickets') as venue_list
group by venue
order by(count_venue) DESC, venue asc) as venue_count;

--15--

WITH t1 AS (SELECT match_id,over_id,ball_id,innings_no,runs_scored+er as runs
    from(SELECT match_id,over_id,ball_id,innings_no,coalesce(extra_runs, 0) as er,runs_scored
    FROM batsman_scored  natural left outer join extra_runs)as t6),
     t2 as(SELECT match_id,over_id,ball_id,innings_no FROM wicket_taken),
     t3 as (select bowler,sum(runs) as sr from t1 natural join ball_by_ball group by bowler),
     t4 as (select bowler,count(bowler) as cb from t2 natural join ball_by_ball group by bowler),
     t5 as(select bowler,round((sr::numeric/cb),3) as avg from t3 natural join t4),
     t6 as(select Min(avg) as minavg from t5),
     t7 as(select bowler,avg from t5 where avg in (select * from t6))
select player_name from (select player_name,avg from t7 join player on t7.bowler=player.player_id order by avg asc,player_name asc)as final order by player_name asc;

--16--

select player.player_name as player_name,team.name as name
from (select player_id,team_id
from (select * from player_match where roll='CaptainKeeper') as player_match_CK
Natural Join match
where match_winner=team_id) as win_CK,player,team
where win_CK.player_id=player.player_id and win_CK.team_id=team.team_id
order by player_name asc,name asc;

--17--

with t5 as(select match_id,innings_no,striker,sum(runs_scored) as runs from (select * from ball_by_ball natural join batsman_scored) as t1 group by match_id,innings_no,striker),
t6 as(select striker,sum(runs) as runs_scored from t5 group by striker),
t7 as(select distinct striker from t5 where runs>=50),
t8 as(select striker,runs_scored from t6 where striker in (select distinct striker from t5 where runs>=50))
select player_name,runs_scored from t8,player where player_id=striker  order by runs_scored desc,player_name asc;

--18--

select (player_name)
 from (select player_id
 from (select *
 from (select *
 from (select striker as player_id,match_id,sum(runs_scored) as players_run_in_match
 from (select * from ball_by_ball Natural Join batsman_scored) as run_per_ball_batsman
 group by (player_id,match_id) ) as player_match_score
 where players_run_in_match>=100) as player_match_century
 Natural Join player_match) as player_match_team Natural Join match
 where team_id <> match_winner) as id_final Natural Join player
 order by player_name asc;
--19---

select match_id,venue from match where ((team_1 in (select team_id from team where name='Kolkata Knight Riders') or team_2 in (select team_id from team where name='Kolkata Knight Riders')) and match_winner not in (select team_id from team where name='Kolkata Knight Riders')) order by match_id asc;

--20--

select player_name
from (select player_id,round(avg(innings_run),3) as batsman_avg
from (select striker as player_id,match_id,innings_no,sum(runs_scored) as innings_run
from (select *
from (select *
from (select match_id from match where season_id=5) as required_matches
Natural Join ball_by_ball ) as match_ball_map Natural Join batsman_scored) as batsman_ball_match
group by (player_id,match_id,innings_no)) as player_inning_score
group by player_id) as player_avg Natural Join player
order by batsman_avg desc, player_name asc
limit 10;

--21--

select country_name
from (select country_name,round(avg(batsman_avg),3) as batting_avg
from (select player_id,avg(innings_run) as batsman_avg
from (select striker as player_id,match_id,innings_no,sum(runs_scored) as innings_run
from (select *
from (select *
from (select match_id from match) as required_matches
Natural Join ball_by_ball ) as match_ball_map Natural Join batsman_scored) as batsman_ball_match
group by (player_id,match_id,innings_no)) as player_inning_score
group by player_id) as player_avg Natural Join player
group by country_name
order by batting_avg desc,country_name asc) as country_batting_avg
limit 5;
