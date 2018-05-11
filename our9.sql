with bs as(    SELECT match_id,over_id,ball_id,innings_no,(runs_scored+er) as runs_scored    from(SELECT match_id,over_id,ball_id,innings_no,coalesce(extra_runs, 0) as er,coalesce(runs_scored, 0)as runs_scored    FROM batsman_scored natural full outer join extra_runs)as t6)select match_id,maximum_runs,player_name from(select match_id,over_id,maximum_runs,player_name from(select match_id,over_id,overruns2 as maximum_runs,bowler from (SELECT t1.match_id as match_id,over_id,innings_no,overruns2 from (select match_id,over_id,innings_no,SUM(runs_scored) as overruns2  from bs group by match_id,over_id,innings_no order by match_id,over_id) as t1,(select match_id,MAX(overruns) as mor from (select match_id,over_id,innings_no,SUM(runs_scored) as overruns from bs group by match_id,over_id,innings_no order by match_id,over_id) as t3 group by match_id) as t2 where t1.match_id = t2.match_id and t1.overruns2=t2.mor order by t1.match_id asc,over_id asc) as t4 natural join (select match_id,over_id,innings_no,bowler from ball_by_ball group by match_id,over_id,innings_no,bowler order by match_id asc,over_id asc) as t5 order by match_id asc,over_id asc) as t6,player where player_id=bowler order by match_id asc,over_id asc)as t8;