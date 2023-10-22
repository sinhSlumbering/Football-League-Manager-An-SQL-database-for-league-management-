create view player_matches as
select
    match_id,
    league_id,
    r.player_id,
    r.team_id
from
    rosters as r
    left join matches as m on (
        m.league_id = r.league_id
        and (
            m.team_1 = r.team_id
            or m.team_2 = r.team_id
        )
    )
order by
    match_id;

create table temp_tab (match_id) CREATE TABLE starts (
    match_id INTEGER,
    player_id INTEGER check (player_id in (select player_id from player_matches as pm where  pm.match_id = match_id)),
    position_id varchar (3),
    CONSTRAINT fk_starts_player FOREIGN KEY (player_id) REFERENCES players (player_id),
    CONSTRAINT fk_start_position FOREIGN KEY (position_id) REFERENCES positions (position_id),
    CONSTRAINT fk_start_match FOREIGN KEY (match_id) REFERENCES matches (match_id),
    CONSTRAINT pk_starts PRIMARY KEY (player_id, match_id)
);

create function checkPlayer(
    match_id INTEGER,
    player_id INTEGER
)
returns varchar(1)
as 
begin
    if (player_id in (
        select player_id from player_matches 
        as pm where  pm.match_id = match_id))
        return 'T'
    return 'F
end


CREATE ROLE loggers;
GRANT INSERT ON shots TO loggers;

CREATE ROLE match_officials;
GRANT INSERT ON shots TO match_officials;
GRANT INSERt
