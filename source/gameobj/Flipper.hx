package gameobj;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import nape.constraint.WeldJoint;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.space.Space;

/**
 * ...
 * @author vincent blanchet
 */
class Flipper extends flixel.group.FlxSpriteGroup
{
	var flipHeight:Int = 15;
	var motor:gameobj.FlipperMotor;
	public var body:nape.phys.Body;

	public function new(x:Float,y:Float, space:Space, type:FlipperType, racketSize:Int = 40) 
	{
		super(x, y);
		
		switch(type)
		{
			case LEFT:
				createLeftFlip(space,racketSize);
			case RIGHT:
				createRightFlip(space,racketSize);
		}
	}
	
	function createLeftFlip(space:Space,racketSize:Int)
	{
		motor = new FlipperMotor(x, y, space);
		add(motor);
		
		var racket = new FlxNapeSprite(x + motor.width, y);
		racket.makeGraphic(racketSize, flipHeight,FlxColor.GREEN);
		racket.createRectangularBody(0, 0, BodyType.DYNAMIC);
		racket.mass = 0;
		body = racket.body;
		add(racket);
		
		var weldJoint = new WeldJoint(motor.body, racket.body, Vec2.weak(0, 0), Vec2.weak( -racketSize/2, 0));
		weldJoint.space = space;
		
	}
	
	function createRightFlip(space:Space, racketSize:Int)
	{
		motor = new FlipperMotor(x, y, space, false);
		add(motor);
		
		var racket = new FlxNapeSprite(x - motor.width, y);
		racket.makeGraphic(racketSize, flipHeight,FlxColor.GREEN);
		racket.createRectangularBody();
		racket.mass = 0;
		body = racket.body;
		add(racket);
		
		var weldJoint = new WeldJoint(motor.body, racket.body, Vec2.weak(0, 0), Vec2.weak( racketSize / 2, 0));
		weldJoint.stiff = true;
		weldJoint.space = space;
		
	}
	
	public function activate():Void
	{
		motor.activate();
	}
	
	public function release():Void
	{
		motor.release();
	}
	
}



enum FlipperType
{
	LEFT;
	RIGHT;
}