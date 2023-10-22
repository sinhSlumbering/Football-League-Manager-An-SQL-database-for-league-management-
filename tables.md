# Players
$$
\begin{center}
\begin{tabular}{|c|c|c|c|}
\hline
player_id& name& birthdate& nationality \\ 
\hline\hline
1 & 'Mohammed Salah' & '1992-06-15' & 'Egyptian' \\
2 & 'Thiago Alcantara' & '1991-04-11' & 'Spanish' \\
3 & 'Alisson Becker' & '1992-10-2' & 'Brazilian' \\
4 & 'Daniel Iversen' & '1997-07-19' & 'Danish' \\
5 & 'James Maddison' & '1996-11-23' & 'English' \\
6 & 'Jamie Vardy' & '1987-01-11' & 'English' \\
7 & 'Jose Sa' & '1993-01-17' & 'Portuguese' \\
8 & 'Hwang Hee-chan' & '1996-01-26' & 'South Korean' \\
9 & 'Adama Traore' & '1996-01-25' & 'Spanish' \\
10 & 'Kelechi Promise Iheanacho' & '1996-10-03' & 'Nigerian' \\
\end{tabular}
\end{center}
$$

# referees
$$
\begin{center}
\begin{tabular}{|c|c|c|}
\hline
referee_id & name & nationality \\ 
\hline\hline
1 & 'Michael Oliver' & 'English' \\
2 & 'Stuart Atwell' & 'English' \\
\end{tabular}
\end{center}
$$

# coaches
$$
\begin{center}
\begin{tabular}{|c|c|c|}
\hline
coach_id & name & nationality \\ 
\hline\hline
1 & 'Jurgen Klopp' & 'German' \\
2 & 'Brendan Rodgers' & 'Irish' \\
3 & 'Julen Lopetegui' & 'Spanish' \\
$$
# stadiums

$$
\begin{center}
\begin{tabular}{|c|c|c|c|}
\hline
stadium_id & name & address & capacity \\ 
\hline\hline
1 & 'Anfield' & 'Anfield Rd & Anfield & Liverpool L4 0TH & United Kingdom' & 53394 \\
2 & 'King Power Stadium' & 'Filbert Wy & Leicester LE2 7FL & United Kingdom' & 32261 \\
3 & 'Molineux Stadium' & 'Waterloo Rd & Wolverhampton WV1 4QR & United Kingdom' & 32050 \\
\end{tabular}
\end{center}
$$

# teams
$$
\begin{center}
\begin{tabular}{|c|c|c|c|c|}
\hline
team_id & name & code & city & address \\ 
\hline\hline
1 & 'Liverpool FC' & 'LIV' & 'Liverpool' & 'Anfield Rd & Anfield & Liverpool L4 0TH & United Kingdom' \\
2 & 'Leicester City FC' & 'LEI' & 'Leicester' & 'Filbert Wy & Leicester LE2 7FL & United Kingdom' \\
3 & 'Wolverhampton Wanderers FC' & 'WOL' &'Wolverhampton' & 'Waterloo Rd & Wolverhampton WV1 4QR & United Kingdom' \\
\end{tabular}
\end{center}
$$

# leagues

$$
\begin{center}
\begin{tabular}{|c|c|c|c|c|}
\hline
league_id & name & country & start_date & end_date \\ 
\hline\hline
1 & 'Premier League 22/23' & 'England' & '2022-08-06' & '2023-05-28' \\
\end{tabular}
\end{center}
$$
 
 
# positions
$$
\begin{center}
\begin{tabular}{|c|c|}
\hline
position_id & position_desc \\ 
\hline\hline
'GK' & 'Goalkeeper' \\
'DF' & 'Defender' \\
'MF' & 'Midfielder' \\
'FW' & 'Forward' \\
'SUB' & 'Substitution' \\
\end{tabular}
\end{center}
$$
 
 
# league_teams
$$
\begin{center}
\begin{tabular}{|c|c|}
\hline
league_id & team_id \\ 
\hline\hline
1 & 1 \\ 1 & 2 \\ 1 &3 \\
\end{tabular}
\end{center}
$$


# rosters
$$
\begin{center}
\begin{tabular}{|c|c|c|c|}
\hline
player_id & team_id & league_id & position_id \\ 
\hline\hline
1 & 1 & 1 & 'FW' \\
2 & 1 & 1 & 'MF' \\
3 & 1 & 1 & 'GK' \\
4 & 2 & 1 & 'GK' \\
5 & 2 & 1 & 'MF' \\
6 & 2 & 1 & 'FW' \\
7 & 3 & 1 & 'GK' \\
8 & 3 & 1 & 'FW' \\
9 & 3 & 1 & 'MF' \\
10 & 2 & 1 & 'FW' \\
\end{tabular}
\end{center}
$$


# team_coach
$$
\begin{center}
\begin{tabular}{|c|c|c|}
\hline
team_id & coach_id & league_id \\ 
\hline\hline
1 & 1 & 1 \\
2 & 2 & 1 \\
3 & 3 & 1 \\
\end{tabular}
\end{center}
$$



# matches
$$
 \begin{center}
\begin{tabular}{|c|c|c|c|c|c|}
\hline
match_id & league_id & team_1 & team_2 & venue & referee \\ 
\hline\hline
1 & 1 & 1 & 2 & 1 & 1 \\
2 & 1 & 2 & 3 & 2 & 1 \\
3 & 1 & 1 & 3 & 1 & 2 \\
\end{tabular}
\end{center}
$$


# starts
$$
 \begin{center}
\begin{tabular}{|c|c|c|}
\hline
match_id & player_id & position_id \\ 
\hline\hline
1 & 1 & 'FW' \\
1 & 2 & 'MF' \\
1 & 3 & 'GK' \\
1 & 4 & 'GK' \\
1 & 5 & 'MF' \\
1 & 6 & 'FW' \\
2 & 4 & 'GK' \\
2 & 5 & 'MF' \\
2 & 6 & 'FW' \\
2 & 7 & 'GK' \\
2 & 8 & 'FW' \\
2 & 9 & 'MF' \\
3 & 7 & 'GK' \\
3 & 8 & 'FW' \\
3 & 9 & 'MF' \\
3 & 1 & 'FW' \\
3 & 2 & 'MF' \\
3 & 3 & 'GK' \\
\end{tabular}
\end{center}
$$


# substitutions
$$
 \begin{center}
\begin{tabular}{|c|c|c|c|}
\hline
match_id & player_id & minute & in_out \\ 
\hline\hline
2 & 5 & 78 & 'I' \\
2 & 10 & 78 & 'O' \\
\end{tabular}
\end{center}
$$
 shot_types
$$
 \begin{center}
\begin{tabular}{|c|c|}
\hline
shot_type & shot_description \\ 
\hline\hline
'G' & 'Goal' \\
'OG' & 'Own Goal' \\
'M' & 'Miss' \\
'PG' & 'Penalty Goal' \\
'PM' & 'Penalty Miss' \\
'PS' & 'Penalty Saved' \\
'S' & 'Save' \\
\end{tabular}
\end{center}
$$

# shots
$$
 \begin{center}
\begin{tabular}{|c|c|c|c|c|c|}
\hline
shot_id & match_id & minute & shot_taker & assister & shot_result \\ 
\hline\hline
1 & 1 & 38 & 5 & 5 & 'OG' \\
2 & 1 & 45 & 6 & 5 & 'M' \\
3 & 1 & 60 & 6 & 5 & 'G' \\
4 & 1 & 68 & 1 & 2 & 'G' \\
5 & 1 & 70 & 2 & 2 & 'S' \\
6 & 1 & 72 & 1 & 2 & 'M' \\
7 & 1 & 80 & 5 & 5 & 'S' \\
8 & 2 & 20 & 5 & 6 & 'M' \\
9 & 2 & 30 & 7 & 8 & 'M' \\
10 & 2 & 45 & 6 & 6 & 'G' \\
11 & 2 & 60 & 6 & 5 & 'M' \\
12 & 2 & 70 & 5 & 6 & 'S' \\
13 & 3 & 10 & 1 & 1 & 'G' \\
14 & 3 & 13 & 1 & 2 & 'M' \\
15 & 3 & 25 & 9 & 8 & 'S' \\
16 & 3 & 30 & 8 & 8 & 'S' \\
17 & 3 & 35 & 9 & 8 & 'S' \\
18 & 3 & 45 & 1 & 2 & 'G' \\
19 & 3 & 67 & 2 & 1 & 'G' \\
\end{tabular}
\end{center}
$$
