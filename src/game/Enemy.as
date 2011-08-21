package game 
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	
	/**
	 * Ludum Dare 21 - Escape
	 * @author Paul S Burgess - 20/8/2011
	 */
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../../data/textures/enemy.png')] private var imgEnemy:Class;
		
		[Embed(source = '../../data/sound/alert1.mp3')] private var sndAlert1:Class;
		[Embed(source = '../../data/sound/alert2.mp3')] private var sndAlert2:Class;
		[Embed(source = '../../data/sound/alert3.mp3')] private var sndAlert3:Class;
		[Embed(source = '../../data/sound/alert4.mp3')] private var sndAlert4:Class;
		[Embed(source = '../../data/sound/alert5.mp3')] private var sndAlert5:Class;
		
		private const HORIZONTAL_WALK_SPEED:int = 18;
		private const VERTICAL_WALK_SPEED:int = 12;
		
		private const NUM_ANIM_FRAMES_PER_DIRECTION:int = 2;
		// Pseudo-enum
		private const E_DIRECTION_LEFT:int = 0;
		private const E_DIRECTION_RIGHT:int = 1;
		private const E_DIRECTION_UP:int = 2;
		private const E_DIRECTION_DOWN:int = 3;
		
		public var m_spriteWidth:int;
		public var m_spriteHeight:int;
		
		private var m_targetPos:FlxPoint;
		private var m_hasTarget:Boolean;
		
		public var m_animDelayTimer:Number = 0.0;
		
		public var m_sfxAlert:FlxSound;
		
		public function Enemy(xPos:int, yPos:int) 
		{
			super(xPos, yPos);
			
			loadGraphic(imgEnemy, true, false, 12, 16);
			m_spriteWidth = width;
			m_spriteHeight = height;
			
			addAnimation("Idle_L", [E_DIRECTION_LEFT * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_R", [E_DIRECTION_RIGHT * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_U", [E_DIRECTION_UP * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			addAnimation("Idle_D", [E_DIRECTION_DOWN * NUM_ANIM_FRAMES_PER_DIRECTION + 0]);
			
			addAnimation("Attack_L", [E_DIRECTION_LEFT * NUM_ANIM_FRAMES_PER_DIRECTION + 1]);
			addAnimation("Attack_R", [E_DIRECTION_RIGHT * NUM_ANIM_FRAMES_PER_DIRECTION + 1]);
			addAnimation("Attack_U", [E_DIRECTION_UP * NUM_ANIM_FRAMES_PER_DIRECTION + 1]);
			addAnimation("Attack_D", [E_DIRECTION_DOWN * NUM_ANIM_FRAMES_PER_DIRECTION + 1]);
			
			// Adjust collision rect
			offset.x = 3;
			offset.y = (height - height / 4);
			width -= offset.x * 2;
			height -= offset.y;
			
			m_hasTarget = false;
			m_targetPos = new FlxPoint;
			
			m_sfxAlert = new FlxSound;
			var soundRoll:Number = Math.random();
			if (soundRoll < 0.2)
				m_sfxAlert.loadEmbedded(sndAlert1);
			else if (soundRoll < 0.4)
				m_sfxAlert.loadEmbedded(sndAlert2);
			else if (soundRoll < 0.6)
				m_sfxAlert.loadEmbedded(sndAlert3);
			else if (soundRoll < 0.8)
				m_sfxAlert.loadEmbedded(sndAlert4);
			else if (soundRoll < 1.0)
				m_sfxAlert.loadEmbedded(sndAlert5);
		}
		
		override public function update():void 
		{
			// Move to target where one exists
			if (m_hasTarget)
			{
				var pathX:Number = m_targetPos.x - getCentreStandingPos().x;
				var pathY:Number = m_targetPos.y - getCentreStandingPos().y;
				var pathLength:Number = Math.sqrt(pathX * pathX + pathY * pathY);
				pathX /= pathLength;
				pathY /= pathLength;
				pathX *= HORIZONTAL_WALK_SPEED;
				pathY *= VERTICAL_WALK_SPEED;
				
				velocity.x = pathX;
				velocity.y = pathY;
			}
			
			// Animate
			if (m_animDelayTimer <= 0)
			{
				if (velocity.x > 0)
				{
					// Right
					play("Idle_R");
					facing = RIGHT;
				}
				else if (velocity.x < 0)
				{
					// Left
					play("Idle_L");
					facing = LEFT;
				}
				else if (velocity.y > 0)
				{
					// Down
					play("Idle_D");
					facing = DOWN;
				}
				else if (velocity.y < 0)
				{
					// Down
					play("Idle_U");
					facing = UP;
				}
			}
			else
				m_animDelayTimer -= FlxG.elapsed;
			
			super.update();
		}
		
		public function getCentreStandingPos():FlxPoint
		{
			var ret:FlxPoint = new FlxPoint(x + width / 2.0, y + height - width / 4.0);
			return ret;
		}
		
		public function setTargetPos(targetX:Number, targetY:Number):void
		{
			m_targetPos.x = targetX;
			m_targetPos.y = targetY;
			m_hasTarget = true;
		}
	}
}