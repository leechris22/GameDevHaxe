package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSort;

class NightState extends FlxState {
	// Maps
	var nightMap:FlxOgmoLoader;

	// Layers
	var layers:FlxTypedGroup<FlxTilemap>;
	var collisionLayers:FlxTypedGroup<FlxTilemap>;
	var collisionMainLayer:FlxTilemap;
	var foregroundLayer:FlxTypedGroup<FlxTilemap>;
	
	// Entities
	var entities:FlxTypedGroup<FlxObject>;
	var collisionEntities:FlxTypedGroup<FlxObject>;
	var players:FlxTypedGroup<Player>;
	var npcs:FlxTypedGroup<NPC>;
	
	// UI
	var characterUI:CharacterUI;
	var shopUI:ShopUI;
	var npc1UI:NPC1UI;
	var npc2UI:NPC2UI;
	var npc3UI:NPC3UI;

	// Actions
	var selectedPlayer:Player;
	
	override public function create():Void {
		// Update Storage values
		Storage.time = false;
		
		// Music
		FlxG.sound.play(AssetPaths.night__ogg, 1, true);
		
		// Map
		nightMap = new FlxOgmoLoader(AssetPaths.night__oel);
		
		// Layers
		layers = new FlxTypedGroup<FlxTilemap>();
		collisionLayers = new FlxTypedGroup<FlxTilemap>();
		foregroundLayer = new FlxTypedGroup<FlxTilemap>();
		placeLayers("walls", 1);
		placeLayers("floor", 0);
		placeLayers("stuff1", 0);
		placeLayers("stuff2", 0);
		placeLayers("unwalkable", 1);
		placeLayers("unwalkableMain", 2);
		placeLayers("Foreground1", 3);
		placeLayers("Foreground2", 3);
		
		// Entities
		entities = new FlxTypedGroup<FlxObject>();
		collisionEntities = new FlxTypedGroup<FlxObject>();
		players = new FlxTypedGroup<Player>();
		npcs = new FlxTypedGroup<NPC>();
		nightMap.loadEntities(placeEntities, "entities");
		
		// UI
		characterUI = new CharacterUI();
		shopUI = new ShopUI();
		npc1UI = new NPC1UI();
		npc2UI = new NPC2UI();
		npc3UI = new NPC3UI();
		
		// Select the player
		Select();
		
		// Add values to view
		add(layers);
		add(entities);
		add(foregroundLayer);
		add(characterUI);
		add(shopUI);
		add(npc1UI);
		add(npc2UI);
		add(npc3UI);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		if (!Storage.pauseUI) {
			// Select players on mouse input
			if (FlxG.mouse.justReleased) {
				selectPlayer();
			}
			if (selectedPlayer.pType == 0) {
				FlxG.collide(selectedPlayer, collisionMainLayer);
			}
			
			// Update Views for foreground/background
			entities.sort(FlxSort.byY);
			
			// Update Collisions
			FlxG.collide(selectedPlayer, collisionLayers);
			FlxG.collide(selectedPlayer, collisionEntities);
			FlxG.collide(npcs, collisionLayers);
			FlxG.overlap(selectedPlayer.actionBox, npcs, playerActions);
		}
		super.update(elapsed);
	}
	
	// Initialize layers
	private function placeLayers(layerName:String, state:Int):Void {
		var tempLayer:FlxTilemap = nightMap.loadTilemap(AssetPaths.tileset__png, 16, 16, layerName);
		tempLayer.follow();
		switch (state) {
			case 0:
				layers.add(tempLayer);
			case 1:
				collisionLayers.add(tempLayer);
				layers.add(tempLayer);
			case 2:
				collisionMainLayer = tempLayer;
				layers.add(tempLayer);
			case 3:
				foregroundLayer.add(tempLayer);
		}
	}
	
	// Initialize entities
	private function placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player") {
			var temp:Player = new Player(x, y, Std.parseInt(entityData.get("pType")));
			entities.add(temp);
			collisionEntities.add(temp);
			players.add(temp);
			add(temp.actionBox);
		} else if (entityName == "npc") {
			var tempType:Int = Std.parseInt(entityData.get("nType"));
			var temp:NPC;
			switch (tempType) {
				case 2:
					if (Storage.Day == 0 || Storage.Day == 7) {
						temp = new InfoNPC(x + 5, y, tempType);
						entities.add(temp);
						collisionEntities.add(temp);
						npcs.add(temp);
					}
				case 3, 4, 5:
						temp = new GuestNPC(x + 5, y, tempType);
						entities.add(temp);
						collisionEntities.add(temp);
						npcs.add(temp);
			}
		}
	}
	
	// Selects the first alive player and changes state once inactive
	private function Select(): Void {
		selectedPlayer = players.getFirstAlive();
		if (players.countLiving() > 1) {
			selectedPlayer.isSelected(true);
			characterUI.updatePlayer(selectedPlayer.pType);
			FlxG.camera.follow(selectedPlayer, TOPDOWN, 1);
		} else {
			FlxG.switchState(new IntroState());
		}
	}
	
	// Selects a player that is clicked
	private function selectPlayer():Void {
		var tempPosition:FlxPoint = FlxG.mouse.getWorldPosition();
		var tempPlayer:Player = selectedPlayer;
		for (player in players) {
			if (player.overlapsPoint(tempPosition) && player.alive) {
				tempPlayer = player;
			} else {
				player.isSelected(false);
			}
		}
		selectedPlayer = tempPlayer;
		selectedPlayer.isSelected(true);
		characterUI.updatePlayer(selectedPlayer.pType);
		FlxG.camera.follow(selectedPlayer, TOPDOWN, 1);
	}
	
	// Performs an action
	private function playerActions(actionBox:FlxObject, npc:NPC):Void {
		if (FlxG.keys.justPressed.E) {
			switch (npc.nType) {
				case 2:
					npc.face(selectedPlayer);
				case 3:
					if (selectedPlayer.pType != 0) {
						if (npc1UI.finishTalking) {
							npc.setFollow(selectedPlayer);
							collisionEntities.remove(npc);
							selectedPlayer.setInactive();
							Select();
						} else {
							npc1UI.toggleHUD(true);
						}
					}
				case 4:
					if (selectedPlayer.pType != 0) {
						if (npc2UI.finishTalking) {
							npc.setFollow(selectedPlayer);
							collisionEntities.remove(npc);
							selectedPlayer.setInactive();
							Select();
						} else {
							npc2UI.toggleHUD(true);
						}
					}
				case 5:
					if (selectedPlayer.pType != 0) {
						if (npc3UI.finishTalking) {
							npc.setFollow(selectedPlayer);
							collisionEntities.remove(npc);
							selectedPlayer.setInactive();
							Select();
						} else {
							npc3UI.toggleHUD(true);
						}
					}
			}
		}
	}
}