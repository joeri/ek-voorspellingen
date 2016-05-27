Users
email (unique)
name
password_hash
has_many favourites
has_many predictions

Favourites
belongs_to User
belongs_to Country

Predictions
belongs_to User
belongs_to Game
predicted_outcome (goals team 1, goals team 2)

Games
belongs_to country1
belongs_to country2
outcome (goals team 1, goals team 2, final_goals team 1, final_goals team 2, penalties team 1, penalties team 2)
date
round

Countries
name
has_many groups (through countries_groups)

Round
description
round (integer, 1 is group phase, final is n where n is total number of rounds)
has_many games
has_many countries (through games(?))

CountiesGroups (join table)
belongs_to country
belongs_to group

Groups
has_many countries (through countries_groups)
belongs_to round
belongs_to seed (country)
