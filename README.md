***
<p align="center">Made In USA by Stanley. <a href="https://discord.com/invite/uCKZJed3Gq">Stanley Development Studios</a> Copyright © 2024. All rights reserved.</p>

# Stretcher 🆓
⚠ This resource is in an early access testing period.
## Known Issues 💢
Players may notice a delay of up to two seconds between the time a player releases the stretcher and the time it takes for it to be set down on the ground properly. This is due to FiveM client syncronization methods. If you are aware of a solution to decrease or elimate this delay, please open an [issue](https://github.com/GlueGunStanley/Stretcher/issues) or create a [pull request](https://github.com/GlueGunStanley/Stretcher/pulls)!  

## Features ✨
- Fully functional stretcher.
- Use any stretcher model. 
- Default StrykerPro model included.
- Powerload functionality for equipped vehicles.
- Openning and closing of vehicle doors.
- Menu for interacting with the stretcher.
- Notification messages.
- Precision configuration.
- Configurable keybinds.
- Configurable permissions.
- Configurable stretcher model.
- 45+ preset configurations for base game and addon vehicles.
- Compatible with any vehicle including planes, helicopters, and boats.


## Screenshots 📸
![screenshot](https://i.imgur.com/h3MkhlP.png)

## Download 🔽
Check out the [releases](https://github.com/GlueGunStanley/Stretcher/releases) page for the latest resource version.

## Installation ✅
**1. Download the [latest release](https://github.com/GlueGunStanley/Stretcher/releases)**  
**2. Extract and rename the folder to `Stretcher`**  
**3. Drag `Stretcher` into your `resources` folder**  
**4. Go to your `server.cfg` and add `start Stretcher`**  
**5. Configure the resource to your liking**  

That's it! If everything went correctly, the next time you start your server the resource will start.
  
## Configuration 🔧
A default configuration comes with the resource. You may use that as a reference on how to configure the resource.

>   ### COMMANDS
>   `/stretchermenu` opens your the stretcher interaction menu.  
>   `/stretcher` spawns a stretcher infront of the player.  
>   `/delstretcher` deletes the closest stretcher to the player.  
>   `/mdstretcher` deletes all stretchers in the server.  
>
>   ### PERMISSIONS
>   Set `true` to restrict the command and require ace permissions.  
>   Set `false` to disable permission requirements for commands. 
>   ~~~lua
>      Config.Permissions = {
>           stretchermenu = false,
>           stretcher = false,
>           delstretcher = false,
>           mdstretcher = false,
>      }
>    ~~~
>   `add_ace builtin.everyone command.stretchermenu allow`  
>   `add_ace group.admin command.stretcher allow`  
>   `add_ace group.admin command.delstretcher allow`  
>   `add_ace group.admin command.mdstretcher allow`  
>   
>   ### KEYBINDS
>   Players can press `H` to open the stretcher interaction menu.  
>   Players can hold `E` to open and close vehicle doors.  
>   Players can press `X` to move the stretcher.   
>   Players can press `G` to load the stretcher.  
>  
>   These keybinds are configurable. You can find a list of controls here! -> [FiveM Controls](https://docs.fivem.net/docs/game-references/controls)
>
>
>   ### STRETCHER
>   A default stretcher model is included with this resource, you may substitute it with any YFT model.  
>   Simply replace `strykerpro` in the config.lua with the replacement model hash.
>
>   ### VEHICLES
>   `modelHash` is the value that is used to identify the vehicle. It is important that each `modelHash` be unique.  
>   `dist` is the distance at which players can interact with the vehicle. The `dist` value may range from `1.0` to a maximum of `20.0`  
>   `xOffset` determines the position of the stretcher in the vehicle to the left or right relative to the vehicle.  
>   `yOffset` determines the position of the stretcher in the vehicle to the front or rear relative to the vehicle.  
>   `zOffset` determines the position of the stretcher in the vehicle higher or lower in height relative to the vehicle.  
>   `rotOffset` determines the direction that the stretcher is facing relative to the vehicle.    
>   `doors` determines which doors are openned and closed when interacting with the vehicle.  
>   `powerload` is the value that is used to indicate if the vehicle supports powerload functionality.  
>   ~~~lua
>   Config.Vehicles = { 
>        {modelHash = "example", dist = 8.0, xOffset = 0.0, yOffset = -2.6, zOffset = -0.165, rotOffset = -90.0, doors = {"FLD", "FRD", "BLD", "BRD", "HOOD", "TRUNK", "RLD", "RRD"}, powerload = false}
>   }
>   ~~~
>#### DOOR MAPPING
>   `FLD` references the front left door.   
>   `FRD` references the front right door.  
>   `RLD` references the rear left door.  
>   `RRD` references the rear right door.  
>   `BLD` references the back left door.   
>   `BRD` references the back right door.   
>   `HOOD` references the hood.   
>   `TRUNK` references the trunk.  
>
>#### POWERLOAD
>   Vehicles that support powerload functionality have a fastener system that extends out of the rear of the vehicle when the doors are openned allowing for easy loading and unloading of the stretcher. Set `true` to enable or set `false` to disable.
>   ### DEBUG
>   Debug messages are disabled by default. Set `true` to enable.

## Performance ➰
We are curently evaluating this resource for performance issues and will continue working on optimization. 
  
## Contributions 💜
If you've found a bug or want to request a feature, you can go ahead and create an [issue](https://github.com/GlueGunStanley/Stretcher/issues).  
If you've improved the resource, feel free to make a [pull request](https://github.com/GlueGunStanley/Stretcher/pulls)!  
If you would like to support the development of more free resources like this one, a [donation](https://www.paypal.com/donate/?hosted_button_id=7YHMMWJF7CPSU) would be very much appreciated!

<a href="https://www.paypal.com/donate/?hosted_button_id=7YHMMWJF7CPSU">
    <img src="https://i.imgur.com/GjlYV1a.png" width="160" height="55" alt="Join us on Discord!">
</a>

## Community 🤠
<a href="https://discord.com/invite/uCKZJed3Gq">
    <img src="https://i.imgur.com/bvJDr0Q.png" width="200" height="60" alt="Join us on Discord!">
</a>

## License 📄
[Stanley Development Studios](https://discord.com/invite/uCKZJed3Gq) Copyright © 2024. All rights reserved.  
This resource is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.en)
<a href="https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.en">
    <img src="https://mirrors.creativecommons.org/presskit/buttons/88x31/png/by-nc-sa.png" width="50.6" height="17.8" alt="CC BY-NC-SA 4.0">
</a>
