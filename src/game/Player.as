package game 
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import states.PlayState;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class Player extends FlxSprite
	{
		[Embed(source = '../../data/textures/player.png')] private var imgPlayer:Class;
		
		private const HORIZONTAL_RUN_SPEED:int = 60;
		private const VERTICAL_RUN_SPEED:int = 40;
		
		private const NUM_ANIM_FRAMES_PER_DIRECTION:int = 1;
		// Pseudo-enum
		private const E_DIRECTION_LEFT:int = 0;
		private const E_DIRECTION_RIGHT:int = 1;
		private const E_DIRECTION_UP:int = 2;
		private const E_DIRECTION_DOWN:int = 3;
		
		public var m_spriteWidth:int;
		public var m_spriteHeight:int;
		
		public function Player(xPos:int, yPos:int) 
		{
			super(xPos, yPos);
			
			loadGraphic(imgPlayer, true, false, 12, 16);
			m_spriteWidth = width;
			m_spriteHeight = height;
			
			addAnimation("Idle_L", [E_DIRECTION_LEFT * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_R", [E_DIRECTION_RIGHT * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_U", [E_DIRECTION_UP * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_D", [E_DIRECTION_DOWN * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			
			// Adjust collision rect
			offset.x = 3;
			offset.y = (height - height / 4);
			width -= offset.x * 2;
			height -= offset.y;
		}
		
		override public function update():void 
		{
			var centreX:Number = getCentreStandingPos().x;
			var centreY:Number = getCentreStandingPos().y;
			
			if (FlxG.keys.pressed("RIGHT") && PlayState.m_currentLevel.IsInLevelBounds(centreX+1, centreY))
			{
				velocity.x = HORIZONTAL_RUN_SPEED;
			}
			else if (FlxG.keys.pressed("LEFT") && PlayState.m_currentLevel.IsInLevelBounds(centreX-1, centreY))
			{
				velocity.x = -HORIZONTAL_RUN_SPEED;
			}
			else
			{
				velocity.x = 0;
			}
			
			if (FlxG.keys.pressed("DOWN") && PlayState.m_currentLevel.IsInLevelBounds(centreX, centreY+1))
			{
				velocity.y = VERTICAL_RUN_SPEED;
			}
			else if (FlxG.keys.pressed("UP") && PlayState.m_currentLevel.IsInLevelBounds(centreX, centreY-1))
			{
				velocity.y = -VERTICAL_RUN_SPEED;
			}
			else
			{
				velocity.y = 0;
			}
			
			// Clamp position
			var maxX:int = PlayState.m_currentLevel.m_roomCentreX + PlayState.m_currentLevel.getMaxXForY(centreY);
			var minX:int = PlayState.m_currentLevel.m_roomCentreX - PlayState.m_currentLevel.getMaxXForY(centreY);
			var maxY:int = PlayState.m_currentLevel.m_roomCentreY + PlayState.m_currentLevel.getMaxYForX(centreX);
			var minY:int = PlayState.m_currentLevel.m_roomCentreY - PlayState.m_currentLevel.getMaxYForX(centreX);
			if (centreX > maxX)
				x = maxX - (width / 2.0);
			else if (centreX < minX)
				x = minX - (width / 2.0);
			if (centreY > maxY)
				y = maxY - (height - width / 4.0);
			else if (centreY < minY)
				y = minY - (height - width / 4.0);
			
			// Animate
			if (velocity.x > 0)
			{
				// Right
				play("Idle_R");
			}
			else if (velocity.x < 0)
			{
				// Left
				play("Idle_L");
			}
			else if (velocity.y > 0)
			{
				// Down
				play("Idle_D");
			}
			else if (velocity.y < 0)
			{
				// Down
				play("Idle_U");
			}
			
			super.update();
		}
		
		public function getCentreStandingPos():FlxPoint
		{
			var ret:FlxPoint = new FlxPoint(x + width / 2.0, y + height - width / 4.0);
			return ret;
		}
	}
}