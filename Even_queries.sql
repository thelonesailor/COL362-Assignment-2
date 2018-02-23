--2--

select player_name ,Extract (years from age('2018-02-12',dob)) as player_age 
from (select * from player where bowling_skill='Legbreak googly') as Legbreaks where Extract (years from age('2018-02-12',dob))>=28 
order by player_age desc,player_name asc;

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

--8--

-----innings separate
select match_id,total_runs
from (
	select match_id,sum(runs_scored) as total_runs
from ball_by_ball Natural JOIN batsman_scored
group by match_id) as match_total
order by match_id asc;

-- select player_name,number
-- from(
-- 	select player_out as player_id, count(player_out) as number
-- 	from (select * from wicket_taken where kind_out='run out') as run_out_table
-- 	group by (player_out)) as player_run_out Natural Join player
-- order by number desc,player_name asc;

-- select player_name,number from

--10--

--with 0's as well
select * from
(select player_name,COALESCE(number,0) as number
from(
	select player_out as player_id, count(player_out) as number
	from (select * from wicket_taken where kind_out='run out') as run_out_table
	group by (player_id)) as player_run_out  Natural Right Outer Join player) as player_run_out
order by number desc,player_name asc;

--12--

select name,number
from(select team_id,count(match_id) as number
from(select match_id,man_of_the_match as player_id
from  match) as match_MoM Natural Join player_match
group by team_id) as teamid_MoM_count Natural Join team
order by name asc;

--14--

select venue
from (select venue,count(venue) as count_venue
from(select venue
from match
where win_type='wickets') as venue_list
group by venue
order by(count_venue) DESC, venue asc) as venue_count;

--16--

--roll vs role
select player.player_name as player_name,team.name as name
from (select player_id,team_id
from (select * from player_match where roll='CaptainKeeper') as player_match_CK
Natural Join match
where match_winner=team_id) as win_CK,player,team
where win_CK.player_id=player.player_id and win_CK.team_id=team.team_id
order by player_name asc,name asc;

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
