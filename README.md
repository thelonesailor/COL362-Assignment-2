# COL362-Assignment-2
To create database:
1. l.sh
2. create.sql
3. load.sql
To run queries:
1. r.sh


with t5 as(select match_id,innings_no,striker,sum(runs_scored) as runs from (select * from ball_by_ball natural join batsman_scored) as t1 group by match_id,innings_no,striker),
t9 as(select match_id,innings_no,striker,runs from t5 where runs>=50),
select player_name,runs_scored from t9,player where player_id=striker  order by runs_scored desc,player_name asc;
