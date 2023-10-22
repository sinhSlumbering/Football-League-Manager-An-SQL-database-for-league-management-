-- matches started per league
create view player_match_starts_per_league as
select
    league_id,
    player_id,
    count(match_id) as starts
from
    starts natural
    join matches
group by
    league_id,
    player_id;

-- matches started total
create view player_match_starts as
select
    player_id,
    count(match_id) as starts
from
    starts
group by
    player_id;

-- mateches played total
create view player_matches_played as
select
    player_id,
    count(match_id) as matches_played
from
    (
        select
            player_id,
            match_id
        from
            starts
        union
        select
            player_id,
            match_id
        from
            substitutions
        where
            in_out = 'I'
    )
group by
    player_id;

-- matches played per league
create view player_matches_played_per_league as
select
    player_id,
    league_id,
    count(match_id) as matches_played
from
    (
        select
            st.player_id as player_id,
            st.match_id as match_id,
            m.league_id as league_id
        from
            starts as st
            join matches as m on m.match_id = st.match_id
        union
        select
            sb.player_id as player_id,
            sb.match_id as match_id,
            m1.league_id as league_id
        from
            substitutions as sb
            join matches as m1 on m1.match_id = sb.match_id
        where
            in_out = 'I'
    )
group by
    league_id,
    player_id;

-- total shots per player
create view total_shots_per_player as
select
    s.shot_taker,
    count(s.shot_id) as shots
from
    (
        select
            shot_taker,
            shot_id
        from
            shots
        where
            shot_result <> 'OG'
    ) as s
group by
    shot_taker;

-- player shots per match
create view player_shots_per_match as
select
    s.shot_taker,
    s.match_id,
    count(s.shot_id) as shots
from
    (
        select
            shot_taker,
            shot_id,
            match_id
        from
            shots
        where
            shot_result <> 'OG'
    ) as s
group by
    s.match_id,
    s.shot_taker;

--player shots per league
create view player_shots_per_league as
select
    s.shot_taker,
    s.league_id,
    count(s.shot_id) as shots
from
    (
        select
            shots.shot_taker as shot_taker,
            shots.shot_id as shot_id,
            matches.league_id as league_id
        from
            shots
            join matches on matches.match_id = shots.match_id
        where
            shot_result <> 'OG'
    ) as s
group by
    s.league_id,
    s.shot_taker;

-- total goals per player
create view total_goals_per_player as
select
    s.shot_taker,
    count(s.shot_id) as goals
from
    (
        select
            shot_taker,
            shot_id
        from
            shots
        where
            shot_result = 'G'
            or shot_result = 'PG'
    ) as s
group by
    shot_taker;

--player goals per match
create view player_goals_per_match as
select
    s.shot_taker,
    s.match_id,
    count(s.shot_id) as goals
from
    (
        select
            shot_taker,
            shot_id,
            match_id
        from
            shots
        where
            shot_result = 'G'
            or shot_result = 'PG'
    ) as s
group by
    s.match_id,
    s.shot_taker;

--player goals per league
create view player_goals_per_league as
select
    s.shot_taker,
    s.league_id,
    count(s.shot_id) as goals
from
    (
        select
            shots.shot_taker as shot_taker,
            shots.shot_id as shot_id,
            matches.league_id as league_id
        from
            shots
            join matches on matches.match_id = shots.match_id
        where
            shot_result = 'G'
            or shot_result = 'PG'
    ) as s
group by
    s.league_id,
    s.shot_taker;

-- total misses per player
create view total_misses_per_player as
select
    s.shot_taker,
    count(s.shot_id) as misses
from
    (
        select
            shot_taker,
            shot_id
        from
            shots
        where
            shot_result = 'M'
            or shot_result = 'PM'
    ) as s
group by
    shot_taker;

--player misses per match
create view player_misses_per_match as
select
    s.shot_taker,
    s.match_id,
    count(s.shot_id) as misses
from
    (
        select
            shot_taker,
            shot_id,
            match_id
        from
            shots
        where
            shot_result = 'M'
            or shot_result = 'PM'
    ) as s
group by
    s.match_id,
    s.shot_taker;

--player misses per league
create view player_misses_per_league as
select
    s.shot_taker,
    s.league_id,
    count(s.shot_id) as misses
from
    (
        select
            shots.shot_taker as shot_taker,
            shots.shot_id as shot_id,
            matches.league_id as league_id
        from
            shots
            join matches on matches.match_id = shots.match_id
        where
            shot_result = 'M'
            or shot_result = 'PM'
    ) as s
group by
    s.league_id,
    s.shot_taker;

-- total assits per player
create view total_assists_per_player as
select
    s.assister,
    count(s.shot_id) as assists
from
    (
        select
            assister,
            shot_id
        from
            shots
        where
            shot_result = 'G'
    ) as s
group by
    s.assister;

--player assists per match
create view player_assists_per_match as
select
    s.assister,
    s.match_id,
    count(s.shot_id) as assits
from
    (
        select
            assister,
            shot_id,
            match_id
        from
            shots
        where
            shot_result = 'G'
    ) as s
group by
    s.match_id,
    s.assister;

--player assists per league
create view player_assists_per_league as
select
    s.assister,
    s.league_id,
    count(s.shot_id) as assits
from
    (
        select
            shots.assister as assister,
            shots.shot_id as shot_id,
            matches.league_id as league_id
        from
            shots
            join matches on matches.match_id = shots.match_id
        where
            shot_result = 'G'
    ) as s
group by
    s.league_id,
    s.assister;

-- creations per league
create view creations_per_league as with A (
    shot_id,
    match_id,
    assister,
    league_id,
    assister_team,
    shot_benifits
) as (
    select
        s.shot_id as shot_id,
        s.match_id as match_id,
        s.assister as assister,
        m.league_id as league_id,
        r.team_id as assister_team,
        CASE
            when shot_result = 'OG' then IIF(team_1 = r.team_id, team_2, team_1)
            else r.team_id
        END as shot_benifits
    from
        shots as s natural
        join matches as m
        join rosters as r on (
            s.assister = r.player_id
            and m.league_id = r.league_id
        )
    where
        shot_benifits = r.team_id
)
select
    league_id,
    assister,
    count(shot_id) as creations
from
    A
group by
    league_id,
    assister;

-- creations per match
create view creations_per_match as with A (
    shot_id,
    match_id,
    assister,
    league_id,
    assister_team,
    shot_benifits
) as (
    select
        s.shot_id as shot_id,
        s.match_id as match_id,
        s.assister as assister,
        m.league_id as league_id,
        r.team_id as assister_team,
        CASE
            when shot_result = 'OG' then IIF(team_1 = r.team_id, team_2, team_1)
            else r.team_id
        END as shot_benifits
    from
        shots as s natural
        join matches as m
        join rosters as r on (
            s.assister = r.player_id
            and m.league_id = r.league_id
        )
    where
        shot_benifits = r.team_id
)
select
    match_id,
    assister,
    count(shot_id) as creations
from
    A
group by
    match_id,
    assister;

-- creations per match
create view creations_total as with A (
    shot_id,
    match_id,
    assister,
    league_id,
    assister_team,
    shot_benifits
) as (
    select
        s.shot_id as shot_id,
        s.match_id as match_id,
        s.assister as assister,
        m.league_id as league_id,
        r.team_id as assister_team,
        CASE
            when shot_result = 'OG' then IIF(team_1 = r.team_id, team_2, team_1)
            else r.team_id
        END as shot_benifits
    from
        shots as s natural
        join matches as m
        join rosters as r on (
            s.assister = r.player_id
            and m.league_id = r.league_id
        )
    where
        shot_benifits = r.team_id
)
select
    assister,
    count(shot_id) as creations
from
    A
group by
    assister;

-- goalkeepers per match
create view gk_per_match as
select s.match_id, r.team_id, s.player_id from starts as s join matches as m on m.match_id = s.match_id 
join rosters as r on (r.league_id=m.league_id and r.player_id = s.player_id)
where s.position_id = 'GK';

-- goalkeepers per match
create view gk_per_match as
select s.match_id, r.team_id, s.player_id from starts as s join matches as m on m.match_id = s.match_id join rosters as r on (r.league_id=m.league_id and r.player_id = s.player_id)
where s.position_id = 'GK';

create view saves as
with A (shot_id, match_id, league_id, gk_team) as(
select s.shot_id as shot_id, s.match_id as match_id, m.league_id as league_id, IIF(r.team_id  = m.team_1, m.team_2, m.team_1) as gk_team
from shots as s natural join matches as m join rosters as r on (s.shot_taker=r.player_id and m.league_id=r.league_id)
where s.shot_result = 'S' or s.shot_result = 'PS'
)
select A.shot_id as shot_id, A.match_id as match_id, A.league_id as league_id, A.gk_team, gkm.player_id as gk from A join gk_per_match as gkm where (A.gk_team = gkm.team_id and A.match_id = gkm.match_id);

create view total_saves_per_player as
select gk as player_id, COUNT(shot_id) as saves from saves group by gk;

create view saves_per_league as
select gk as player_id, league_id, count(shot_id) as saves from saves group by league_id, gk;

create view saves_per_match as
select gk as player_id, match_id, count(shot_id) as saves from saves group by match_id, gk;






-- overall player data
create view overall_player_data as 
select p.player_id, p.name, p.birthdate, p.nationality, coalesce(pd.matches_played,0) as matches_played, coalesce(ms.matches_started,0) as matches_started,
 coalesce(gpp.goals,0) as goals, coalesce(ap.assists,0) as assists, coalesce(cp.creations, 0) as creations, coalesce(mp.misses,0) as misses,
coalesce(sp.shots,0) as shots, coalesce(svp.saves,0) as saves
from players as p
left join player_matches_played as pd on p.player_id = pd.player_id
left join player_match_starts as ms on p.player_id = ms.player_id
left join total_goals_per_player as gpp on p.player_id = gpp.shot_taker
left join total_assists_per_player as ap on p.player_id = ap.assister
left join creations_total as cp on p.player_id = cp.assister
left join total_misses_per_player as mp on p.player_id = mp.shot_taker
left join total_shots_per_player as sp on p.player_id = sp.shot_taker
left join total_saves_per_player as svp on p.player_id = svp.player_id;

--player data per leauge
select r.league_id, p.player_id, p.name, p.birthdate, p.nationality, coalesce(pd.matches_played,0) as matches_played, coalesce(ms.starts,0) as matches_started,
 coalesce(gpp.goals,0) as goals, coalesce(ap.assists,0) as assists, coalesce(cp.creations, 0) as creations, coalesce(mp.misses,0) as misses,
coalesce(sp.shots,0) as shots, coalesce(svp.saves,0) as saves
from players as p
left join rosters as r on p.player_id = r.player_id
left join player_matches_played_per_league as pd on p.player_id = pd.player_id and p.player_id = r.player_id 
left join player_matches_starts_per_league as ms on p.player_id = ms.player_id and p.player_id = r.player_id
left join player_goals_per_league as gpp on p.player_id = gpp.shot_taker and p.player_id = r.player_id
left join player_assists_per_league as ap on p.player_id = ap.assister and p.player_id = r.player_id
left join creations_per_league as cp on p.player_id = cp.assister and p.player_id = r.player_id
left join player_misses_per_league as mp on p.player_id = mp.shot_taker and p.player_id = r.player_id
left join player_shots_per_league as sp on p.player_id = sp.shot_taker and p.player_id = r.player_id
left join saves_per_match as svp on p.player_id = svp.player_id and p.player_id = r.player_id;
