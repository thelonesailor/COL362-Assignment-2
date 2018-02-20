rm -f dump.txt
touch dump.txt
chmod 777 dump.txt
time psql -d postgres -f assignment2_2015CS10667_2015CS10435.sql >> dump.txt
