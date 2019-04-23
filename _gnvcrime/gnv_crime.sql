
select hour, count(*) from crime_hour group by hour;

create view crime_hour as select offense_date, strftime('%H', offense_date) as hour from crime; 