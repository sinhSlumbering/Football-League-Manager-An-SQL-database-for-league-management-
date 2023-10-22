-- lists league and shot taker team with shot
With recursive A(shot_id, match_id, minute, shot_taker, assister, shot_result, team_1, team_2, league_id) as(
select shot_id, match_id, minute, shot_taker, assister, shot_result, team_1, team_2, league_id from shots natural join matches)
select shot_id, match_id, minute, shot_taker, B.name as shot_taker_name, assister, C.name as assister_name, shot_result, team_1, team_2, A.league_id as league_id, team_id as shot_taker_team, D.name shot_team from (A join rosters on (A.shot_taker=rosters.player_id and A.league_id=rosters.league_id))
join players as B on B.player_id=A.shot_taker join players as C on C.player_id = A.assister join teams as D on D.team_id = rosters.team_id;

--- OG problem fixed
select shot_id, match_id, minute, shot_taker, assister, shot_result, team_1, team_2, m.league_id as league_id, r.team_id as shot_taker_team,
CASE
    when shot_result = 'OG' then IIF(team_1=r.team_id, team_2, team_1)
    else r.team_id
END as shot_benifits
from shots natural join matches as m join rosters as r on (shots.shot_taker=r.player_id and m.league_id=r.league_id);


-- team goals per match
create view team_goals_per_match as 
with recursive A (match_id, league_id, shot_benifits) as (
select match_id, m.league_id,
CASE
    when shot_result = 'OG' then IIF(team_1=r.team_id, team_2, team_1)
    else r.team_id
END as shot_benifits
from shots natural join matches as m join rosters as r on (shots.shot_taker=r.player_id and m.league_id=r.league_id) where shot_result = 'G' or shot_result = 'OG' or shot_result ='PG'
)
select match_id, league_id, shot_benifits as team_id, count(shot_benifits) as goals from A group by match_id, shot_benifits;

--team goals per league
create view team_goals_per_league as
with recursive A (match_id, league_id, shot_benifits) as (
select match_id, m.league_id,
CASE
    when shot_result = 'OG' then IIF(team_1=r.team_id, team_2, team_1)
    else r.team_id
END as shot_benifits
from shots natural join matches as m join rosters as r on (shots.shot_taker=r.player_id and m.league_id=r.league_id) where shot_result = 'G' or shot_result = 'OG' or shot_result ='PG'
)
select league_id, shot_benifits as team_id, count(shot_benifits) as goals from A group by league_id, shot_benifits;
-- scoreline
select matches.match_id, league_id, team_1, ifnull(g1.goals, 0) as goals_1, team_2, ifnull(g2.goals, 0) as goals_2, venue, referee from matches left outer join team_goals_per_match as g1 on (g1.team_id = matches.team_1 and g1.match_id=matches.match_id)
left outer join team_goals_per_match as g2 on (g2.team_id = matches.team_2 and g2.match_id=matches.match_id);

-- shots
select shot_id, match_id, league_id, minute, shot_taker, position_id as shot_taker_pos, team_id, assister, venue, shot_result from shots as s join matches as m on m.match_id = s.match_id join rosters as r on (r.player_id=s.shot_taker and r.league_id=m.league_id)
where shot_result<>'OG';

-- team shots per leauge
create view team_shots_per_league as
with recursive A (match_id, league_id, shot_benifits) as (
select match_id, m.league_id, IIF(team_1=r.team_id, team_1, team_2) as shot_benifits
from shots natural join matches as m join rosters as r on 
(shots.shot_taker=r.player_id and m.league_id=r.league_id) 
where shot_result<>'OG' 
)
select league_id, shot_benifits as team_id, count(shot_benifits) as shots 
from A group by league_id, shot_benifits;

-- team shots per match
create view team_shots_per_match as
with recursive A (match_id, league_id, shot_benifits) as (
select match_id, m.league_id, IIF(team_1=r.team_id, team_1, team_2) as shot_benifits
from shots natural join matches as m join rosters as r on 
(shots.shot_taker=r.player_id and m.league_id=r.league_id) 
where shot_result<>'OG' 
)
select match_id, shot_benifits as team_id, count(shot_benifits) as shots 
from A group by match_id, shot_benifits;

select * from team_shots_per_match;

-- team misses per league
create view team_misses_per_league
with A(match_id, league_id, team_id, shot_result) as (
select s.match_id, m.league_id, r.team_id, s.shot_result from matches as m join shots as s on s.match_id = m.match_id
join rosters as r on r.player_id = s.shot_taker and m.league_id = r.league_id where s.shot_result = 'M'
)
select league_id, team_id, count(shot_result) as misses from A group by team_id, league_id;

-- team misses per match
create view team_misses_per_match as 
with A(match_id, league_id, team_id, shot_result) as (
select s.match_id, m.league_id, r.team_id, s.shot_result from matches as m join shots as s on s.match_id = m.match_id
join rosters as r on r.player_id = s.shot_taker and m.league_id = r.league_id where s.shot_result = 'M'
)
select match_id, league_id, team_id, count(shot_result) as misses from A group by team_id, league_id, match_id

-- match results
create view match_results as
with A(match_id, league_id, team_1, team_1_gls, team_2, team_2_gls) as(
select matches.match_id as match_id, matches.league_id as league_id, team_1, IFNULL(t.goals, 0) as team_1_gls, team_2, ifnull(t1.goals, 0) as team_2_gls 
from matches left outer join team_goals_per_match as t on matches.match_id = t.match_id and t.team_id = matches.team_1
left outer join team_goals_per_match as t1 on t1.match_id = matches.match_id and t1.team_id = matches.team_2)
select *, IIF(team_1_gls>team_2_gls, 'W', IIF(team_1_gls=team_2_gls, 'D', 'L')) as team_1_res 
, IIF(team_2_gls>team_1_gls, 'W', IIF(team_2_gls=team_1_gls, 'D', 'L')) as team_2_res 
from A;


-- wins
create view wins as
with A(match_id, league_id, team_id, result) as(
select match_id, league_id, team_1 as team_id, team_1_res as result from match_results
where team_1_res = 'W' 
union
select match_id, league_id, team_2 as team_id, team_2_res as result from match_results
where team_2_res = 'W'
)
select lt.league_id, lt.team_id, count(result) as wins from league_teams as lt left join A on (lt.league_id=A.league_id
and lt.team_id=A.team_id) group by A.team_id;

-- losses
create view losses as
with A(match_id, league_id, team_id, result) as(
select match_id, league_id, team_1 as team_id, team_1_res as result from match_results
where team_1_res = 'L' 
union
select match_id, league_id, team_2 as team_id, team_2_res as result from match_results
where team_2_res = 'L'
)
select league_id, team_id, count(result) as losses from league_teams as lt left join A on (lt.league_id=A.league_id
and lt.team_id=A.team_id) group by A.team_id;

--draws (does not work)
create view draws as
with A(match_id, league_id, team_id, result) as(
select match_id, league_id, team_1 as team_id, team_1_res as result from match_results
where team_1_res = 'D' 
union
select match_id, league_id, team_2 as team_id, team_2_res as result from match_results
where team_2_res = 'D'
)
select lt.league_id, lt.team_id, count(result) as draws from league_teams as lt left join A on (lt.league_id=A.league_id
and lt.team_id=A.team_id) group by A.team_id;

--matches played per league
create view matches_played_per_league as
with A(team_id, match_id, league_id) as(
select team_2 as team_id, match_id, league_id from matches
union
select team_1 as team_id, match_id, league_id from matches
)
select team_id, league_id, count(match_id) as matches_played from A group by league_id, team_id;

-- eternal league tables
Create view league_tables as
select lt.league_id, t.name, t.code, t.city, lt.team_id, ifnull(matches_played, 0) as matches_played, ifnull(wins, 0) as wins, ifnull(draws,0) as draws, ifnull(losses,0) as losses, 3*ifnull(wins,0)+ifnull(draws,0) as points
, ifnull(shots,0) as shots, ifnull(goals,0)as goals, ifnull(misses, 0) as misses, ifnull(shots,0)-ifnull(misses, 0) as shots_on_goal
from league_teams as lt 
left join wins on (lt.league_id = wins.league_id and lt.team_id = wins.team_id)
left join draws on (lt.league_id = draws.league_id and lt.team_id = draws.team_id) 
left join losses on (lt.league_id = losses.league_id and lt.team_id = losses.team_id)
left join team_shots_per_league as spl on (lt.league_id = spl.league_id and lt.team_id = spl.team_id)
left join team_goals_per_league as gpl on (lt.league_id = gpl.league_id and lt.team_id = gpl.team_id)
left join team_misses_per_league as mpl on (lt.league_id = mpl.league_id and lt.team_id = mpl.team_id)
left join team_matches_played_per_league as mp on (lt.league_id =mp.league_id and lt.team_id=mp.team_id)
join teams as t on t.team_id = lt.team_id;

-- match stats
create view match_stats as
select mr.match_id, mr.league_id, mr.team_1, t1.code as t1_code, t1.name as t1_name, t1.city as t1_city, mr.team_1_gls, 
mr.team_2, t2.code as t2_code, t2.name as t2_name, t2.city as t2_city, mr.team_2_gls, mr.team_1_res, mr.team_2_res,
ifnull(tm.misses, 0) as team_1_misses, ifnull(tm1.misses, 0) as team_2_misses,
ifnull(tg.goals, 0) as team_1_goals, ifnull(tg1.goals, 0) as team_2_goals,
ifnull(ts.shots, 0) as team_1_shots, ifnull(ts1.shots, 0) as team_2_shots,
ifnull(ts.shots, 0)-ifnull(tm.misses, 0) as team_1_shots_on_target, ifnull(ts1.shots, 0)-ifnull(tm1.misses, 0) as team_2_shots_on_target
from match_results as mr 
left join team_misses_per_match as tm on (mr.team_1 = tm.team_id and mr.match_id=tm.match_id)
left join team_misses_per_match as tm1 on (mr.team_2 = tm1.team_id and mr.match_id=tm1.match_id)
left join team_goals_per_match as tg on (mr.team_1 = tg.team_id and mr.match_id=tg.match_id)
left join team_goals_per_match as tg1 on (mr.team_2 = tg1.team_id and mr.match_id=tg1.match_id)
left join team_shots_per_match as ts on (mr.team_1 = ts.team_id and mr.match_id=ts.match_id)
left join team_shots_per_match as ts1 on (mr.team_2 = ts1.team_id and mr.match_id=ts1.match_id)
join teams as t1 on t1.team_id = mr.team_1
join teams as t2 on t2.team_id = mr.team_2

