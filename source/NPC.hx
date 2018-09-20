package;

import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author Christian
 */
class NPC extends FlxSprite {
	// Initialize variables
	private var nType:Int;
	private var speed:Float = 200;

	public function new(X:Float = 0, Y:Float = 0, NType:Int) {
		//Set values
		super(X, Y);
		nType = NType;
		immovable = true;
		
		// Set graphics
		loadGraphic("assets/images/enemy-" + nType + ".png", true, 16, 16);
		setSize(8, 14);
		offset.set(4, 2);
		//animation.add("d", [0, 1, 0, 2], 6, false);
		//animation.add("lr", [3, 4, 3, 5], 6, false);
		//animation.add("u", [6, 7, 6, 8], 6, false);
		
		// Set movement
		drag.x = drag.y = 1600;
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
	}
	
	override public function update(elapsed:Float):Void {
		movement();
		super.update(elapsed);
	}
	
	private function movement():Void {
		/*// Set movement bools
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		
		// Get key inputs
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		
		// Cancel input if two opposite keys pressed
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;
		
		// Calculate angle and velocity
		if (up || down || left || right) {
			var mA:Float = 0;
			if (up) {
				mA = -90;
				if (left) {
					mA -= 45;
				} else if (right) {
					mA += 45;
				}
				facing = FlxObject.UP;
			} else if (down) {
				mA = 90;
				if (left) {
					mA += 45;
				} else if (right) {
					mA -= 45;
				}
				facing = FlxObject.DOWN;
			} else if (left) {
				mA = 180;
				facing = FlxObject.LEFT;
			} else if (right) {
				mA = 0;
				facing = FlxObject.RIGHT;
			}

			// Determine the velocity based on angle and speed
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);
			
			// Change the face
			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
				switch (facing) {
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("u");
					case FlxObject.DOWN:
						animation.play("d");
				}
			}
		}
		actionBox.setPosition(x, y);*/
	}
}