# Box2D - Flail

Originally started for a Mini Ludum Dare, now a toy example of LOVE / Box2D

- Use the mouse to spin the chain and hit enemies away 

TODO:

- Chain stretching / breaking at high speeds
    - Consider reinforcing joints, joining every element to every other element
    
- Enemy velocities
    - Enemies should move towards player
    - Cannot constantly overwrite velocity with new target velocity, prevents collisions / knockbacks from playing out
    - Velocity towards player should be fixed constant speed
    - Add to velocities caused by collisions etc


- Control scheme
    - Mouse works but is quite clunky, tweak speeds/weights


- Hit detection on player
