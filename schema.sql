-- the dudes
CREATE TABLE players(
    player_id INTEGER PRIMARY KEY,
    name varchar(255) NOT NULL,
    birthdate date,
    nationality varchar(255)
); 

CREATE TABLE referees(
    referee_id INTEGER PRIMARY KEY,
    name varchar(255),
    nationality varchar(255)
);

CREATE TABLE coaches(
    coach_id INTEGER PRIMARY KEY,
    name varchar(255),
    nationality varchar(255)
);

--stadium
CREATE TABLE stadiums(
    stadium_id INTEGER PRIMARY KEY  ,
    name varchar(255),
    address varchar(255),
    capacity NUMERIC 
);

-- teams
CREATE TABLE teams(
    team_id INTEGER PRIMARY KEY  ,
    name varchar(255),
    code varchar(255),
    city varchar(255),
    address varchar(255)
);

-- leagues the idea is even if a league increments to a new season we give it a new id to stop juggling 2 primary keys everywhere
CREATE TABLE leagues(
    league_id INTEGER PRIMARY KEY,
    name varchar(255),
    country varchar(255),
    start_date date,
    end_date date 
);

-- position for shortening data, realize we might need one for nationality too but hey it's a start
CREATE TABLE positions(
    position_id varchar(3) PRIMARY KEY,
    position_desc varchar(255)
);

-- will record data of each team per season, now the stats can be derived, no clue what to do in this case
-- do we go with a view and derive stats or do we keep em in the table explicitly
CREATE TABLE league_teams(
    league_id INTEGER,
    team_id INTEGER,
    CONSTRAINT fk_league_team_league
        FOREIGN KEY (league_id)
        REFERENCES leagues(league_id),
    CONSTRAINT fk_league_team_team
        FOREIGN KEY (team_id)
        REFERENCES teams(team_id),
    CONSTRAINT pk_league_teams PRIMARY KEY (league_id, team_id)
);

-- this will keep track of who plays for what team in what season. thus letting us not give a shit about
-- transfers
CREATE TABLE rosters(
    player_id INTEGER,
    team_id INTEGER,
    league_id INTEGER,
    position_id varchar(3),
    CONSTRAINT fk_roster_league
        FOREIGN KEY (league_id)
        REFERENCES leagues(league_id),
    CONSTRAINT fk_roster_team
       FOREIGN KEY (team_id)
       REFERENCES teams(team_id),
    CONSTRAINT fk_roster_player
        FOREIGN KEY (player_id)
        REFERENCES players(player_id),
    CONSTRAINT fk_roster_position
        FOREIGN KEY (position_id)
        REFERENCES positions(position_id),
    CONSTRAINT pk_roster PRIMARY KEY (player_id, league_id)
);

-- who coaches what
CREATE TABLE team_coach(
    team_id INTEGER,
    coach_id INTEGER,
    league_id INTEGER,
    CONSTRAINT fk_team_coach_league
        FOREIGN KEY (league_id)
        REFERENCES leagues(league_id),
    CONSTRAINT fk_team_coach_team
        FOREIGN KEY (team_id)
        REFERENCES teams(team_id),
    CONSTRAINT fk_team_coach_coach
        FOREIGN KEY (coach_id)
        REFERENCES coaches(coach_id),
    CONSTRAINT pk_team_coach PRIMARY KEY (coach_id, league_id)
);

-- loging matches
CREATE TABLE matches(
    match_id INTEGER PRIMARY KEY,
    league_id INTEGER,
    team_1 INTEGER,
    team_2 INTEGER,
    venue INTEGER,
    referee INTEGER,
    CONSTRAINT fk_matches_league
        FOREIGN KEY (league_id)
        REFERENCES leagues(league_id),
    CONSTRAINT fk_match_team_1_team
        FOREIGN KEY (team_1)
        REFERENCES teams(team_id),
    CONSTRAINT fk_match_team_2_team
        FOREIGN KEY (team_2)
        REFERENCES teams(team_id),
    CONSTRAINT fk_match_venue
        FOREIGN KEY (venue)
        REFERENCES stadiums(stadium_id),
    CONSTRAINT fk_match_referee
        FOREIGN KEY (referee)
        REFERENCES referees(referee_id),    
    CONSTRAINT chk_team_1_cannot_equal_team_2 CHECK (team_1<>team_2)
);

-- niggas who play in a match. useful for calculating appearances
CREATE TABLE starts(
    match_id INTEGER,
    player_id INTEGER,
    position_id varchar(3),
    CONSTRAINT fk_starts_player
        FOREIGN KEY (player_id)
        REFERENCES players(player_id),
    CONSTRAINT fk_start_position
        FOREIGN KEY (position_id)
        REFERENCES positions(position_id),
    CONSTRAINT fk_start_match
        FOREIGN KEY (match_id)
        REFERENCES matches(match_id),
    CONSTRAINT pk_starts PRIMARY KEY(player_id, match_id)
);

-- who got subbed in/out
CREATE TABLE substitutions(
    match_id INTEGER ,
    player_id INTEGER,
    minute NUMERIC,
    in_out CHARACTER(1),
    CONSTRAINT fk_sub_player
        FOREIGN KEY (player_id)
        REFERENCES players(player_id),
    CONSTRAINT fk_sub_match
        FOREIGN KEY (match_id)
        REFERENCES matches(match_id),
    CONSTRAINT chk_sub_type CHECK (in_out IN ('I', 'O')),
    CONSTRAINT pk_subs PRIMARY KEY(player_id, match_id)
);

-- what can be the outcomes of a shot
CREATE TABLE shot_types(
    shot_type CHARACTER(5) PRIMARY KEY,
    -- G, M, P, OW
    shot_description varchar(255)
);

-- stats calculated per shot ;-; I am sorry can't find a better and easier way to log stats
CREATE TABLE shots(
    shot_id INTEGER PRIMARY KEY,
    match_id INTEGER,
    minute INTEGER,
    shot_taker INTEGER,
    assister INTEGER,
    shot_result CHARACTER(5),
    CONSTRAINT fk_shottaker_player
        FOREIGN KEY (shot_taker)
        REFERENCES players(player_id),
    CONSTRAINT fk_assister_player
        FOREIGN KEY (assister)
        REFERENCES players(player_id),
    CONSTRAINT fk_shot_match
        FOREIGN KEY (match_id)
        REFERENCES matches(match_id),
    CONSTRAINT fk_shot_type 
        FOREIGN KEY (shot_result)
        REFERENCES shot_types(shot_type)
);