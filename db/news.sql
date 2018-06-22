
drop table if exists webpage cascade;
drop type if exists vote cascade;
drop table if exists accounts cascade;
drop table if exists comments cascade;
drop table if exists votes cascade;

CREATE TYPE vote AS ENUM ('up','down','neutral');

create table webpage (
	id serial primary key,
	url varchar(255),
	time timestamp default now()
);

create table accounts(
	id serial primary key,
	account varchar(255),
	time timestamp default now(),
	display_name varchar(255),
	disabled boolean
);

create table comments (
	id serial primary key,
	comment text,
	time	timestamp default now(),
	account int references accounts(id),
	webpage int references webpage(id),
	reply  int references accounts(id)
);

create table votes(
	comment_id int references comments(id),
	account int references accounts(id),
	vote_type vote default 'neutral'
);


select c.comment, r.display_name, a.display_name, sum (case v.vote_type when 'up' then 1 when 'down' then -1 else 0 end) 
from comments c 
	left join votes v on c.id = v.comment_id
	left join accounts a on a.id = c.account
	left join accounts r on a.id = c.reply
where webpage = 1
group by c.comment, r.display_name, a.display_name, c.time
order by c.time

