select match_id,sum(total_runs) as total_runs
from (
	(select match_id,sum(runs_scored) as total_runs
from ball_by_ball Natural JOIN batsman_scored
group by match_id)
union all
(select match_id,sum(extra_runs) as total_runs
from extra_runs
group by match_id)) as match_totalruns
group by match_id
order by match_id asc;
