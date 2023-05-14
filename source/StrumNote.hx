package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;
	public var direction:Float = 90;//plan on doing scroll directions soon -bb
	public var downScroll:Bool = false;//plan on doing scroll directions soon -bb
	public var sustainReduce:Bool = true;

	public var animationArray:Array<String> = ['static', 'pressed', 'confirm'];
	public var static_anim(default, set):String = "static";
	public var pressed_anim(default, set):String = "pressed"; // in case you would use this on lua
	// though, you shouldn't change it
	public var confirm_anim(default, set):String = "static";
	public function new(x:Float, y:Float, type:String, strumID:Int, playerStrum:Bool)
	{
		super(x, y);
		baseY = y;
		pressingKey5 = false;

		ID = strumID;

		// actually load in the animation
		switch (skin)
		{
			case 'gh':
				animation.addByPrefix('green', 'A Strum');
				animation.addByPrefix('red', 'B Strum');
				animation.addByPrefix('yellow', 'C Strum');
				animation.addByPrefix('blue', 'D Strum');
				animation.addByPrefix('orange', 'E Strum');

				switch (Math.abs(strumID))
				{
					case 0:
						animation.addByPrefix('static', 'A Strum');
						animation.addByPrefix('pressed', 'A Press', 24, false);
						animation.addByPrefix('confirm', 'A Confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'B Strum');
						animation.addByPrefix('pressed', 'B Press', 24, false);
						animation.addByPrefix('confirm', 'B Confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'C Strum');
						animation.addByPrefix('pressed', 'C Press', 24, false);
						animation.addByPrefix('confirm', 'C Confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'D Strum');
						animation.addByPrefix('pressed', 'D Press', 24, false);
						animation.addByPrefix('confirm', 'D Confirm', 24, false);
					case 4:
						animation.addByPrefix('static', 'E Strum');
						animation.addByPrefix('pressed', 'E Press', 24, false);
						animation.addByPrefix('confirm', 'E Confirm', 24, false);
				}
			default:
				animation.addByPrefix('green', 'arrowUP');
				animation.addByPrefix('blue', 'arrowDOWN');
				animation.addByPrefix('purple', 'arrowLEFT');
				animation.addByPrefix('red', 'arrowRIGHT');

				var nSuf:Array<String> = ['LEFT0', 'DOWN0', 'UP0', 'RIGHT0'];
				var pPre:Array<String> = ['left', 'down', 'up', 'right'];
				switch (PlayState.SONG.mania)
				{
					case 1:
						nSuf = ['LEFT0', 'DOWN0', 'SPACE', 'UP0', 'RIGHT0'];
						pPre = ['left', 'down', 'white', 'up', 'right'];
					case 2:
						nSuf = ['LEFT0', 'UP0', 'RIGHT0', 'LEFT0', 'DOWN0', 'RIGHT0'];
						pPre = ['left', 'up', 'right', 'yel', 'down', 'dark'];
					case 3:
						nSuf = ['LEFT0', 'UP0', 'RIGHT0', 'SPACE', 'LEFT0', 'DOWN0', 'RIGHT0'];
						pPre = ['left', 'up', 'right', 'white', 'yel', 'down', 'dark'];
					case 4:
						nSuf = ['LEFT0', 'DOWN0', 'UP0', 'RIGHT0', 'SPACE', 'LEFT0', 'DOWN0', 'UP0', 'RIGHT0'];
						pPre = ['left', 'down', 'up', 'right', 'white', 'yel', 'violet', 'black', 'dark'];
					case 5:
						nSuf = ['LEFT0', 'DOWN0', 'UP0', 'RIGHT0', 'LEFTSHARP', 'DOWNSHARP', 'UPSHARP', 'RIGHTSHARP', 'LEFT0', 'DOWN0', 'UP0', 'RIGHT0'];
						pPre = ['left', 'down', 'up', 'right', 'pink', 'turq', 'emerald', 'lightred', 'yel', 'violet', 'black', 'dark'];
				}
				animation.addByPrefix('static', 'arrow' + nSuf[strumID]);
				animation.addByPrefix('pressed', pPre[strumID] + ' press', 24, false);
				animation.addByPrefix('confirm', pPre[strumID] + ' confirm', 24, false);
		}
		playAnim('static');

		antialiasing = type != '3D';

		setGraphicSize(Std.int(width * (type == 'gh' ? 0.7 : Note.noteSize)));
		updateHitbox();

		scrollFactor.set();

		this.playerStrum = playerStrum;
	}

	private function set_static_anim(value:String):String {
		if (!PlayState.isPixelStage) {
			animation.addByPrefix('static', value);
			animationArray[0] = value;
			if (animation.curAnim != null && animation.curAnim.name == 'static') {
				playAnim('static');
			}
		}
		return value;
	}

	private function set_pressed_anim(value:String):String {
		if (!PlayState.isPixelStage) {
			animation.addByPrefix('pressed', value);
			animationArray[1] = value;
			if (animation.curAnim != null && animation.curAnim.name == 'pressed') {
				playAnim('pressed');
			}
		}
		return value;
	}

	private function set_confirm_anim(value:String):String {
		if (!PlayState.isPixelStage) {
			animation.addByPrefix('confirm', value);
			animationArray[2] = value;
			if (animation.curAnim != null && animation.curAnim.name == 'confirm') {
				playAnim('confirm');
			}
		}
		return value;
	}
	
	private var player:Int;
	
	public var texture(default, set):String = null;
	private function set_texture(value:String):String {
		if(texture != value) {
			texture = value;
			reloadNote();
		}
		return value;
	}

	public function reloadNote()
	{
		var lastAnim:String = null;
		if(animation.curAnim != null) lastAnim = animation.curAnim.name;

		var pxDV:Int = Note.pixelNotesDivisionValue;

		if(PlayState.isPixelStage)
			{
				loadGraphic(Paths.image('pixelUI/' + texture));
				width = width / Note.pixelNotesDivisionValue;
				height = height / 5;
				antialiasing = false;
				loadGraphic(Paths.image('pixelUI/' + texture), true, Math.floor(width), Math.floor(height));
				var daFrames:Array<Int> = Note.keysShit.get(PlayState.mania).get('pixelAnimIndex');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom * Note.pixelScales[PlayState.mania]));
				updateHitbox();
				antialiasing = false;
				animation.add('static', [daFrames[noteData]]);
				animation.add('pressed', [daFrames[noteData] + pxDV, daFrames[noteData] + (pxDV * 2)], 12, false);
				animation.add('confirm', [daFrames[noteData] + (pxDV * 3), daFrames[noteData] + (pxDV * 4)], 24, false);
				//i used windows calculator
			}
		else
			{
				frames = Paths.getSparrowAtlas(texture);

				antialiasing = ClientPrefs.globalAntialiasing;

				setGraphicSize(Std.int(width * Note.scales[PlayState.mania]));
		
				animation.addByPrefix('static', 'arrow' + animationArray[0]);
				animation.addByPrefix('pressed', animationArray[1] + ' press', 24, false);
				animation.addByPrefix('confirm', animationArray[1] + ' confirm', 24, false);
			}

		updateHitbox();

		if(lastAnim != null)
		{
			playAnim(lastAnim, true);
		}
	}

	public function postAddedToGroup() {
		playAnim('static');
		/**
		 * list of complicated math that occurs down below:
		 * start by adding X value to strum
		 * add extra X value accordng to Note.xtra
		 * add 50 for centered strum
		 * put the strums in the correct side
		 * subtract X value for centered strum
		**/

		switch (PlayState.mania)
		{
			case 0 | 1 | 2: x += width * noteData;
			case 3: x += (Note.swagWidth * noteData);
			default: x += ((width - Note.lessX[PlayState.mania]) * noteData);
		}

		x += Note.xtra[PlayState.mania];
	
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
		x -= Note.posRest[PlayState.mania];
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		if(animation.curAnim != null){ //my bad i was upset
			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
				centerOrigin();
			}
		}

		super.update(elapsed);
	}
	public function resetX()
	{
		x = baseX;
	}
	public function resetY()
	{
		y = baseY;
	}
	public function centerStrum()
	{
		x = baseX + 320 * (playerStrum ? -1 : 1) + 78 / 4;
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();
		if(animation.curAnim == null || animation.curAnim.name == 'static') {
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else {
			if (noteData > -1 && noteData < ClientPrefs.arrowHSV.length)
			{
				colorSwap.hue = ClientPrefs.arrowHSV[Std.int(Note.keysShit.get(PlayState.mania).get('pixelAnimIndex')[noteData] % Note.ammo[PlayState.mania])][0] / 360;
				colorSwap.saturation = ClientPrefs.arrowHSV[Std.int(Note.keysShit.get(PlayState.mania).get('pixelAnimIndex')[noteData] % Note.ammo[PlayState.mania])][1] / 100;
				colorSwap.brightness = ClientPrefs.arrowHSV[Std.int(Note.keysShit.get(PlayState.mania).get('pixelAnimIndex')[noteData] % Note.ammo[PlayState.mania])][2] / 100;
			}
			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
				centerOrigin();
			}
		}
	}
}
