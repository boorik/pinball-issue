package states;

import flixel.addons.nape.*;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUICheckBox;
import flixel.input.touch.FlxTouch;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxColor;
import gameobj.Ball;
import gameobj.CustomNapeTilemap;
import gameobj.Flipper.FlipperType;
import gameobj.FlipperMotor;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.PreListener;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.shape.Polygon;

class PlayState extends FlxState
{
    var level:CustomNapeTilemap;
    var firstRun:Bool = false;
	
	var flippers:Array<gameobj.Flipper>;
	var infos:flixel.text.FlxText;
	var fps:openfl.display.FPS;

	var BALL	= new CbType();
	var FLIPPER	= new CbType();
	var ballIniter:nape.constraint.PivotJoint;
	var balls:Array<gameobj.Ball>;
	var bulletCheckBox:flixel.addons.ui.FlxUICheckBox;
	
    function initSpace():Void
    {
        FlxNapeSpace.init(); 
		FlxNapeSpace.drawDebug = true;
        FlxNapeSpace.space.gravity.setxy(0, 1500);
		FlxNapeSpace.space.step(1 / 60, 100, 100);
        Constants.oneWayType = new CbType();
		FlxNapeSpace.createWalls();
    }

    override public function create():Void
    {
        //FlxG.mouse.visible = false;
        FlxG.camera.bgColor = FlxColor.WHITE;

        initSpace();
        loadLevel("assets/mapCSV_firstMain_Map1.csv");
		
		balls = [];
		
		createBall(0, 0);
		spawnBall();
		
		fps = new openfl.display.FPS();
		FlxG.stage.addChild(fps);
		fps.visible = false;
		
		infos = new flixel.text.FlxText(10, 10, 0, "Fps:", 12);
		infos.addFormat(new FlxTextFormat(FlxColor.BLACK));
		add(infos);
		
		var instructionText = new FlxText(0, 0, FlxG.width, "Use SPACE to activate", 10);
		instructionText.alignment = FlxTextAlign.CENTER;
		instructionText.setFormat(null, 10, FlxColor.BLACK);
		add(instructionText);
		
		bulletCheckBox = new FlxUICheckBox(10, FlxG.height - 30, null, null, "isBullet", 100, null, onBulletClick);
		bulletCheckBox.getLabel().setFormat(null, 16);
		add(bulletCheckBox);
    }
	
	function onBulletClick():Void
	{
		for(b in balls)
			b.body.isBullet = bulletCheckBox.checked;
		trace("onBulletClick");
	}
	
	function createBall(x:Int, y:Int):Ball
	{
		var ball = new Ball(x, y, FlxColor.BLUE);
		ball.body.cbTypes.add(BALL);
		balls.push(ball);
		add(ball);
		return ball;
	}
	
	
	function spawnBall()
	{
		var ball = balls[0];
		ball.setPosition(50, 400);
		
		ballIniter = new PivotJoint(FlxNapeSpace.space.world, ball.body, ball.body.position, Vec2.weak(0,0));
		ballIniter.space = FlxNapeSpace.space;
	}

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
		
		for (b in balls)
		{
			if (b.y > FlxG.height - 30 )
			{
				FlxG.camera.shake(0.01, 0.3);
				if (balls.length > 1)
				{
					balls.remove(b);
					remove(b);
					b.kill();
				}else{
					spawnBall();
				}
			}
		}
		
		
		
		infos.text = "FPS: "+fps.currentFPS;
		#if mobile
		if (FlxG.touches.list.length > 0)
		#else
		if (FlxG.keys.pressed.SPACE)
		#end
        {
			if (ballIniter != null)
			{
				ballIniter.space = null;
				ballIniter = null;
			}
			for (f in flippers)
			{
				f.activate();
			}
        }else{
			for (f in flippers)
			{
				f.release();
			}
		}
    }

    function loadLevel(file:String)
    {

        if (level != null)
        {
            level.body.space = null;
            remove(level);
        }
        
        level = new CustomNapeTilemap(file, "assets/tiles.png", Constants.TILE_SIZE);
        level.body.setShapeMaterials(Constants.platformMaterial);
        add(level);
		
		flippers = [];
		for (p in level.leftFlippers)
		{
			var lf = new gameobj.Flipper(p.x + 8, p.y + 8, FlxNapeSpace.space, FlipperType.LEFT, 80);
			lf.body.cbTypes.add(FLIPPER);
			add(lf);
			flippers.push(lf);
		}
		
		for (p in level.rightFlippers)
		{
			var rf = new gameobj.Flipper(p.x + 8, p.y + 8, FlxNapeSpace.space,FlipperType.RIGHT, 80);
			add(rf);
			flippers.push(rf);
		}
		
    }
}