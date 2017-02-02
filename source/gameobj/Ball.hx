package gameobj;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

class Ball extends FlxNapeSprite
{
    public function new(x:Float, y:Float, fillColor:FlxColor)
    {
        super(x, y);
		
		//createCircularBody(16);
        loadGraphic("assets/ball.png", true, 30, 30);
		//FlxSpriteUtil.drawCircle(this, -1, -1, 0, fillColor);

        if (body != null)
            destroyPhysObjects();

        centerOffsets(false);

		setBody(new Body(BodyType.DYNAMIC, Vec2.weak(x, y)));
        var box = new nape.shape.Circle(15);
        body.shapes.add(box);
        body.setShapeMaterials(Constants.playerMaterial);
		
		//body.isBullet = true;
        body.allowRotation = true;
    }
}
