rm difference
time psql -U postgres -d assignment2 -h localhost -f testing.sql > quer
diff quer quer_anuj > difference
subl difference