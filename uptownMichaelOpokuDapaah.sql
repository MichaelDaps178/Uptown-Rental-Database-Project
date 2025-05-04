select *from customer;

select *from instrument;


select *from maintenance;

select * from rental;

select *from tier;

select *from staff;

select tier.rental_tier, SUM(daily_rentalfee)
from tier inner join instrument
on tier.rental_tier = instrument.rental_tier
join rental on rental.serial_num = instrument.serial_num
group by tier.rental_tier;