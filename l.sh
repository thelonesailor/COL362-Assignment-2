#!/bin/bash

fname="load.sql"
rm -f $fname
touch $fname

for f in {"ball_by_ball","batsman_scored","extra_runs","match","player_match","player","team","wicket_taken"};
do

    p="$(realpath Data/$f.csv)"
    echo "copy $f from '$p' with csv;" >> $fname;

done;
