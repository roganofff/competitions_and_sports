-- migrate:up

create extension if not exists "uuid-ossp";

create schema if not exists crud_api;

drop table if exists crud_api.competitions, crud_api.sports, crud_api.stages, crud_api.competitions_sports, cascade;

create table crud_api.competitions
(
	id			uuid primary key default uuid_generate_v4(),
	comp_name	text,
	comp_start	date,
	comp_end	date
);

create table crud_api.sports
(
	id			uuid primary key default uuid_generate_v4(),
	sport_name	text,
	description text
);

create table crud_api.stages
(
	id			uuid primary key default uuid_generate_v4(),
	comp_id		uuid references crud_api.competitions(id),
	sport_id	uuid references crud_api.sports(id),
	stage_name	text,
	stage_date	date,
	place		text
);

create table crud_api.competitions_sports
(
	competition_id	uuid references crud_api.competitions(id),
	sport_id		uuid references crud_api.sports(id),
	primary key (competition_id, sport_id)
);


insert into crud_api.competitions (comp_name, comp_start, comp_end)
values	('Olympic Games', '2021.07.23', '2021.08.08'),
		('Mr. World Wide', '2022.02.03', '2022.02.10'),
		('ESports World Cup', '2007.07.07', '2007.07.21'),
		('Всероссийские соревнования по радиоспорту', '2024.03.28', '2024.04.02');

insert into crud_api.sports (sport_name, description)
values	('Basketball', 'Кидаем мячик в колечки.'),
		('Football', 'Пинаем мячик в ворота.'),
		('Athletics', 'Бегит, атжумання.'),
		('Powerlifting', 'Light weight.'),
		('Counter-Strike 1.6', 'Нажимаем на ЛКМ.'),
		('Defense Of The Ancients 1', 'Нажимаем на ПКМ.'),
		('Warcraft 3', 'Опять работа.'),
		('Цифровая схемотехника', 'Паяем эммитерный повторитель.');

insert into crud_api.competitions_sports (competition_id, sport_id)
values	((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Basketball')),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Football')),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Athletics')),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Powerlifting')),
		((select id from crud_api.competitions where comp_name='Mr. World Wide'),
		(select id from crud_api.sports where sport_name='Powerlifting')),
		((select id from crud_api.competitions where comp_name='Mr. World Wide'),
		(select id from crud_api.sports where sport_name='Athletics')),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Counter-Strike 1.6')),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Defense Of The Ancients 1')),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Warcraft 3')),
		((select id from crud_api.competitions where comp_name='Всероссийские соревнования по радиоспорту'),
		(select id from crud_api.sports where sport_name='Warcraft 3')),
		((select id from crud_api.competitions where comp_name='Всероссийские соревнования по радиоспорту'),
		(select id from crud_api.sports where sport_name='Цифровая схемотехника'));

insert into crud_api.stages (comp_id, sport_id, stage_name, stage_date, place)
values	((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Basketball'),
		'Quarter Finals', '2020.07.07', 'Japan, Tokyo'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Basketball'),
		'Semi Finals', '2020.07.08', 'Japan, Tokyo'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Basketball'),
		'Grand Final', '2020.07.09', 'Japan, Tokyo'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Football'),
		'Quarter Finals', '2020.07.11', 'Japan, Kyoto'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Football'),
		'Semi Finals', '2020.07.12', 'Japan, Kyoto'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Football'),
		'Grand Final', '2020.07.13', 'Japan, Kyoto'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Athletics'),
		'Semi Finals, 5000m', '2020.07.10', 'Japan, Yokohama'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Athletics'),
		'Grand Final, 10.000m', '2020.07.11', 'Japan, Yokohama'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Powerlifting'),
		'Men''s 96kg', '2020.07.15', 'Japan, Tokyo'),
		((select id from crud_api.competitions where comp_name='Olympic Games'),
		(select id from crud_api.sports where sport_name='Powerlifting'),
		'Women''s 64kg', '2020.07.16', 'Japan, Tokyo'),
		((select id from crud_api.competitions where comp_name='Mr. World Wide'),
		(select id from crud_api.sports where sport_name='Powerlifting'),
		'Women''s 59kg', '2022.02.03', 'Russia, Saransk'),
		((select id from crud_api.competitions where comp_name='Mr. World Wide'),
		(select id from crud_api.sports where sport_name='Powerlifting'),
		'Men''s 67kg', '2022.02.05', 'Russia, Saransk'),
		((select id from crud_api.competitions where comp_name='Mr. World Wide'),
		(select id from crud_api.sports where sport_name='Athletics'),
		'Semi Finals, 5000m', '2022.02.07', 'Russia, Murmansk'),
		((select id from crud_api.competitions where comp_name='Mr. World Wide'),
		(select id from crud_api.sports where sport_name='Athletics'),
		'Grand Final, 8000m', '2022.02.09', 'Russia, Murmansk'),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Counter-Strike 1.6'),
		'Quarter Finals Play-off, Blast Major', '2007.07.07', 'France, Paris'),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Counter-Strike 1.6'),
		'Semi Finals Play-off, Blast Major', '2007.07.09', 'France, Paris'),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Counter-Strike 1.6'),
		'Grand Final Play-off, Blast Major', '2007.07.10', 'France, Paris'),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Defense Of The Ancients 1'),
		'Upper Bracket Semifinals, The International 2023', '2007.07.14', 'USA, Seattle'),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Defense Of The Ancients 1'),
		'Upper Bracket Final, The International 2023', '2007.07.15', 'USA, Seattle'),
		((select id from crud_api.competitions where comp_name='ESports World Cup'),
		(select id from crud_api.sports where sport_name='Warcraft 3'),
		'Mega-Ultra-Super-Duper Grand Final', '2007.07.21', 'USA, Seattle'),
		((select id from crud_api.competitions where comp_name='Всероссийские соревнования по радиоспорту'),
		(select id from crud_api.sports where sport_name='Warcraft 3'),
		'Мега-Ультра-Супер-Дупер Гранд Финал', '2024.03.28', 'Russia, Saint-Petersburg'),
		((select id from crud_api.competitions where comp_name='Всероссийские соревнования по радиоспорту'),
		(select id from crud_api.sports where sport_name='Цифровая схемотехника'),
		'Сборка схемы К155РУ7 на время', '2024.04.01', 'Russia, Saint-Petersburg');

-- migrate:down