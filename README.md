# Godot TRPG Template
A starting point for creating a TRPG in Godot 4

Originally based on the GDQuest TRPG Movement tutorial for Godot 3.x, but has now taken it's own form into what I ideally would like from a template for a TRPG.

## Deviations from the source material
This has been modified to use an isometric perspective by default, though it can be changed by simply modifying the tilemaps to use whatever else you'd like.

The movement system supports both setting a unit's movement to a radial range, or to a custom pattern defined by a tilemap layer on the Unit itself.

For managing how turns work for each team on the game board, there is a TurnManager resource on the GameBoard scene that can be overridden and replaced with a resouce inherrited from the same TurnManager class to create a different rule set.
