"""Module contains SQL queries."""
GET_COMPETITIONS = """
with
    stages_json as (
        select
            comp_id,
            sport_id,
            coalesce(jsonb_agg(jsonb_build_object(
                'id', id, 'stage name', stage_name,
                'stage date', stage_date, 'place', place))
                filter (where id is not null), '[]') as stages
            from crud_api.stages
            group by comp_id, sport_id
)
select
    c.id,
    c.comp_name as \"competition name\",
    c.comp_start as \"competition start\",
    c.comp_end as \"competition end\",
        coalesce(jsonb_agg(jsonb_build_object(
        'sport_id', s.id, 'sport name', s.sport_name,
        'description', s.description, 'stages', st.stages))
        filter (where s.id is not null), '[]') as sports
    from crud_api.competitions c
    left join crud_api.competitions_sports cs on cs.competition_id = c.id
    left join crud_api.sports s on cs.sport_id = s.id
    left join stages_json st on cs.competition_id = st.comp_id
        and cs.sport_id = st.sport_id
    group by c.id;
"""


INSERT_COMPETITION = """
insert into crud_api.competitions (comp_name, comp_start, comp_end)
    values  ({comp_name}, {comp_start}, {comp_end})
    returning id;
"""


UPDATE_COMPETITION = """
update crud_api.competitions
set
    comp_name = {comp_name},
    comp_start = {comp_start},
    comp_end = {comp_end}
where id = {id_}
returning id;
"""


DELETE_COMPETITION_LINKS_SPORTS = """
delete from crud_api.competitions_sports where competition_id = {id_}
returning competition_id;
"""


DELETE_COMPETITION_LINKS_STAGES = """
delete from crud_api.stages where comp_id = {id_}
returning comp_id;
"""


DELETE_COMPETITION = """
delete from crud_api.competitions where id = {id_}
returning id;
"""
