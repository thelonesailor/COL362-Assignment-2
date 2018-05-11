rm -f dump_p.txt
touch dump_p.txt
chmod 777 dump_p.txt
time psql -d postgres -f create.sql
time psql -d postgres -f load.sql
time psql -d postgres -f assignment2_2015CS10667_2015CS10435.sql >> dump_p.txt
