package gameobj;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.space.Space;

/**
 * ...
 * @author vincent blanchet
 */
class FlipperMotor extends FlxNapeSprite
{
	var motorJoint:nape.constraint.MotorJoint;
	public var rate:Int = 3000;
	public var ratio:Float = 100;
	public var left:Bool;
	public var maxAngleInDegree = 50;
	public function new(x:Float, y:Float, space:Space, leftSide:Bool = true) 
	{
		super(x, y);
		
		makeGraphic(2, 2, FlxColor.YELLOW);
		
		this.left = leftSide;
		
		if (body != null)
            destroyPhysObjects();
			
		centerOffsets(false);
		
		setBody(new Body(BodyType.DYNAMIC, Vec2.weak(x, y)));
		
		//var box = new Polygon(Polygon.box(fWidth, 10));
		var box = new nape.shape.Circle(7);
		body.shapes.add(box);
		body.space = space;
		
		body.inertia = 100000000; //prevent weak behaviour 
		
		var pivotJoint = new PivotJoint(space.world, body, body.position, Vec2.weak(0, 0));
		pivotJoint.stiff = true;
		pivotJoint.space = space;
		
		motorJoint = new nape.constraint.MotorJoint(space.world, body,0,ratio);
		motorJoint.active = true;
		//motorJoint.stiff = true;
		motorJoint.space = space;
		motorJoint.rate = 100;
	}
	
	public function activate():Void
	{
		if (left)
			counterClockwiseRotation();
		else
			clockwiseRotation();
	}
	
	public function release():Void
	{
		if (left)
			clockwiseRotation()
		else
			counterClockwiseRotation();
		
	}
	
	function clockwiseRotation()
	{
		if (body.rotation < maxAngleInDegree * Math.PI / 180)
		{
			motorJoint.rate = rate;
		}else{
			//body.angularVel = 0;
			motorJoint.rate = 0;
			//body.rotation = maxAngleInDegree * Math.PI / 180;
		}
	}
	
	function counterClockwiseRotation()
	{
		if (body.rotation > -maxAngleInDegree * Math.PI / 180)
		{
			motorJoint.rate = - rate;
		}else{
			//body.angularVel = 0;
			motorJoint.rate = 0;
			//body.rotation = -maxAngleInDegree * Math.PI / 180;
		}
	}
	
	
}