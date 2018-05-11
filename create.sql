DROP table IF EXISTS  ball_by_ball,batsman_scored,extra_runs,match,player_match,player,team,wicket_taken;

create table ball_by_ball(
    match_id integer,
    over_id integer,
    ball_id integer,
    innings_no integer,
    team_batting integer,
    team_bowling integer,
    striker_batting_position integer,
    striker integer,
    non_striker integer,
    bowler integer,
    primary key(match_id,over_id,ball_id,innings_no)
);

create table batsman_scored(
    match_id integer,
    over_id integer,
    ball_id integer,
    runs_scored integer,
    innings_no integer,
    primary key(match_id,over_id,ball_id,innings_no)
);

create table extra_runs(
    match_id integer,
    over_id integer,
    ball_id integer,
    extra_type varchar(100),
    extra_runs integer,
    innings_no integer,
    primary key(match_id,over_id,ball_id,innings_no)
);

create table match(
    match_id integer,
    team_1 integer,
    team_2 integer,
    match_date date,
    season_id integer,
    venue varchar(100),
    toss_winner integer,
    toss_decision varchar(100),
    win_type varchar(100),
    win_margin integer,
    outcome_type varchar(100),
    match_winner integer,
    man_of_the_match integer,
    primary key(match_id)
);

create table player_match(
    match_id integer,
    player_id integer,
    roll varchar(100),
    team_id integer,
    primary key(match_id,player_id)
);

create table player(
    player_id integer,
    player_name varchar(100),
    dob date,
    batting_hand varchar(100),
    bowling_skill varchar(100),
    country_name varchar(100),
    primary key(player_id)
);

create table team(
    team_id integer,
    name varchar(100),
    primary key(team_id)
);

create table wicket_taken(
    match_id integer,
    over_id integer,
    ball_id integer,
    player_out integer,
    kind_out varchar(100),
    innings_no integer,
    primary key(match_id,over_id,ball_id,innings_no)
);
