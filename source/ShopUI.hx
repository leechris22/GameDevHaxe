package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * The beginning of the story
 * @author Tony
 */

class ShopUI extends FlxTypedGroup<FlxSprite> {
	// Background
	var name:FlxSprite;
	var text:FlxSprite;
	var shop:FlxSprite;
	
	// Text Content
	var textIndex = 0;
	var nameContent:FlxText;
	var textContent:FlxText;
	
	// Shop Content
	var Names:Array<String> = ["Sake", "Tea", "Ink", "Arranged Flowers", "German Pen", "Famous Katana", "Chinese Tea Pot", "Kimono", "Japanese Fan", "Mythic Shamisen"];
	var Prices:Array<Int> = [1000, 1200, 800, 600, 9400, 10800, 13000, 12500, 9800, 8500];
	var itemName:Map<String, FlxText> = new Map<String, FlxText>();
	var itemPrice:Map<String, FlxText> = new Map<String, FlxText>();
	
	//Sound
	private var chooseSound:FlxSound;
	private var failSound:FlxSound;
	
	public function new()  {
		super();
		// Add the shop backgrounds
		name = new FlxSprite(150, 220);
		name.loadGraphic(AssetPaths.ui_name__png);
		text = new FlxSprite(150, 260);
		text.loadGraphic(AssetPaths.ui_dialogue__png);
		shop = new FlxSprite(280,20);
		shop.loadGraphic(AssetPaths.ui_shop__png);
		add(name);
		add(text);
		add(shop);
		
		// Content section
		nameContent = new FlxText(name.x + 15, name.y + 5, 100, "Shopkeeper");
		nameContent.setFormat("assets/fonts/SHPinscher-Regular.otf", 20, FlxColor.WHITE);
		textContent = new FlxText(text.x + 15, text.y + 10, 470, "Welcome. How can I help you?\nPress SPACE to finish shopping.");
		textContent.setFormat("assets/fonts/SHPinscher-Regular.otf", 20, FlxColor.WHITE);
		add(nameContent);
		add(textContent);
				
		// Add items to shop
		var count:Int = 0;
		var offsetx:Int = 15;
		var offsety:Int = 10;
		for (i in 0...Names.length) {
			var tempItemName:FlxText = new FlxText(shop.x+offsetx, shop.y+offsety, 150, Names[i]+":");
			tempItemName.setFormat("assets/fonts/SHPinscher-Regular.otf", 15, FlxColor.WHITE);
			var tempItemPrice:FlxText = new FlxText(shop.x+offsetx+75, shop.y+offsety+15, 80, Std.string(Prices[i])+" G");
			tempItemPrice.setFormat("assets/fonts/SHPinscher-Regular.otf", 15, FlxColor.WHITE);
			itemName[Names[i]] = tempItemName;
			itemPrice[Names[i]] = tempItemPrice;
			add(tempItemName);
			add(tempItemPrice);
			offsety += 45;
			if (count == 4) {
				offsetx += 155;
				offsety = 10;
			}
			count++;
		}
		
		// Load Sounds
		chooseSound = FlxG.sound.load(AssetPaths.ButtonSFXMenu__ogg);
		failSound = FlxG.sound.load(AssetPaths.ButtonSFXBack__ogg);
		
		// Set to disabled
		forEach(function(spr:FlxSprite) {
			spr.alpha = 0;
		});
		active = false;
		
		// like we did in our HUD class, we need to set the scrollFactor on each of our children objects to 0,0.
		forEach(function(spr:FlxSprite) { spr.scrollFactor.set(); });
	}

	
	override public function update(elapsed:Float):Void {
		if (Storage.pauseUI) {
			if (FlxG.keys.anyJustReleased([SPACE,ENTER])) {
				toggleHUD(false);
			}			
			if (FlxG.mouse.justReleased) {
				if (FlxG.mouse.screenX >= 290 && FlxG.mouse.screenX <= 435 && FlxG.mouse.screenY >=25 && FlxG.mouse.screenY <= 60) {
					buy(0);
				} else if (FlxG.mouse.screenX >= 290 && FlxG.mouse.screenX <= 435 && FlxG.mouse.screenY >= 70 && FlxG.mouse.screenY <= 105) {
					buy(1);
				} else if (FlxG.mouse.screenX >= 290 && FlxG.mouse.screenX <= 435 && FlxG.mouse.screenY >= 115 && FlxG.mouse.screenY <= 150) {
					buy(2);
				} else if (FlxG.mouse.screenX >= 290 && FlxG.mouse.screenX <= 435 && FlxG.mouse.screenY >= 160 && FlxG.mouse.screenY <= 195) {
					buy(3);
				} else if (FlxG.mouse.screenX >= 290 && FlxG.mouse.screenX <= 435 && FlxG.mouse.screenY >= 205 && FlxG.mouse.screenY <= 240) {
					buy(4);
				} else if (FlxG.mouse.screenX >= 450 && FlxG.mouse.screenX <= 590 && FlxG.mouse.screenY >= 25 && FlxG.mouse.screenY <= 60) {
					buy(5);
				} else if (FlxG.mouse.screenX >= 450 && FlxG.mouse.screenX <= 590  && FlxG.mouse.screenY >= 70 && FlxG.mouse.screenY <= 105) {
					buy(6);
				} else if (FlxG.mouse.screenX >= 450 && FlxG.mouse.screenX <= 590  && FlxG.mouse.screenY >= 115 && FlxG.mouse.screenY <= 150) {
					buy(7);
				} else if (FlxG.mouse.screenX >= 450 && FlxG.mouse.screenX <= 590  && FlxG.mouse.screenY >= 160 && FlxG.mouse.screenY <= 195) {
					buy(8);
				} else if (FlxG.mouse.screenX >= 450 && FlxG.mouse.screenX <= 590  && FlxG.mouse.screenY >= 205 && FlxG.mouse.screenY <= 240) {
					buy(9);
				}
			}
		}
		super.update(elapsed);	
	}
		
	// Turn on/off HUD
	public function toggleHUD(power:Bool):Void {
		textIndex = 0;
		if (power) {
			Storage.pauseUI = true;
			FlxTween.num(0, 1, .33, { onComplete: function(_) {
				active = true;
				nameContent.text = "Shopkeeper";
				textContent.text = "Welcome. How can I help you?\nPress SPACE to finish shopping.";
			}}, function(Alpha:Float) {
				forEach(function(spr:FlxSprite) {
					spr.alpha = Alpha;
				});
			});
		} else {
			Storage.pauseUI = power;
			active = false;
			FlxTween.num(1, 0, .33, { onComplete: function(_) {
				Storage.pauseUI = false;
			}}, function(Alpha:Float) {
				forEach(function(spr:FlxSprite) {
					spr.alpha = Alpha;
				});
			});
		}
	}
	
	//Buy items
	public function buy(shopItem:Int):Void {
		//limitedItems
		if (shopItem >= 0 && shopItem <= 3) {
			if (Storage.money >= Prices[shopItem]) { //Has enough money
				chooseSound.play();
				Storage.limitedItemCounts[shopItem] += 1;
				Storage.money -= Prices[shopItem];
				textContent.text = "You buy " + Storage.limitedItemNames[shopItem] + " successfully!\nPress SPACE to finish shopping.";
				chooseSound.play();
			} else {
				textContent.text = "Sorry, you don't have enough money.\nPress SPACE to finish shopping.";
				failSound.play();
			}
		//UnlimitedItems
		} else if (shopItem >= 4 && shopItem <= 9) {
			if (Storage.unlimitedItemCounts[shopItem - 4] > 0) { //Player has bought it
				textContent.text = "This item is sold out.\nPress SPACE to finish shopping.";
				failSound.play();
			} else {
				if (Storage.money >= Prices[shopItem]) { //Has enough money
					chooseSound.play();
					Storage.unlimitedItemCounts[shopItem-4] += 1;
					Storage.money -= Prices[shopItem];
					if (shopItem == 4 || shopItem == 7){
						Storage.npc1 += 1;
					}
					else if (shopItem == 5 || shopItem == 8){
						Storage.npc2 += 1;
					}
					else{
						Storage.npc3 += 1;
					}
					textContent.text = "You buy " + Storage.unlimitedItemNames[shopItem - 4] + " successfully!\nPress SPACE to finish shopping.";
					chooseSound.play();
				} else {
					textContent.text = "Sorry, you don't have enough money.\nPress SPACE to finish shopping.";
					failSound.play();
				}	
			}
		} 
	}
	
}