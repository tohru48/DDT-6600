package worldboss.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossIcon extends Sprite
   {
      
      private var _dragon:MovieClip;
      
      private var _isOpen:Boolean;
      
      public function WorldBossIcon()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var iconLoader:BaseLoader = LoadResourceManager.Instance.createLoader(WorldBossManager.Instance.iconEnterPath,BaseLoader.MODULE_LOADER);
         iconLoader.addEventListener(LoaderEvent.COMPLETE,this.onIconLoadedComplete);
         LoadResourceManager.Instance.startLoad(iconLoader);
      }
      
      private function onIconLoadedComplete(e:Event) : void
      {
         this._dragon = ComponentFactory.Instance.creat("asset.hall.worldBossEntrance");
         var id:String = WorldBossManager.Instance.BossResourceId;
         this._dragon = ComponentFactory.Instance.creat("assets.hallIcon.worldBossEntrance_" + WorldBossManager.Instance.BossResourceId);
         this._dragon.buttonMode = true;
         addChild(this._dragon);
         if(Boolean(WorldBossManager.Instance.bossInfo))
         {
            this._dragon.gotoAndStop(WorldBossManager.Instance.bossInfo.fightOver ? 2 : 1);
         }
         else
         {
            this._dragon.gotoAndStop(1);
         }
         this._dragon.y = 38;
         this.addEvent();
         if(!this._isOpen)
         {
            if(this._dragon.currentFrame == 2)
            {
               this.x = 41;
            }
            else
            {
               this.x = 50;
            }
         }
      }
      
      private function stopAllMc($mc:MovieClip) : void
      {
         var cMc:MovieClip = null;
         var index:int = 0;
         while(Boolean($mc.numChildren - index))
         {
            if($mc.getChildAt(index) is MovieClip)
            {
               cMc = $mc.getChildAt(index) as MovieClip;
               cMc.stop();
               this.stopAllMc(cMc);
            }
            index++;
         }
      }
      
      private function playAllMc($mc:MovieClip) : void
      {
         var cMc:MovieClip = null;
         var index:int = 0;
         while(Boolean($mc.numChildren - index))
         {
            if($mc.getChildAt(index) is MovieClip)
            {
               cMc = $mc.getChildAt(index) as MovieClip;
               cMc.play();
               this.playAllMc(cMc);
            }
            index++;
         }
      }
      
      public function set enble(bool:Boolean) : void
      {
         this._isOpen = bool;
         mouseEnabled = bool;
         mouseChildren = bool;
         if(!bool)
         {
            BuriedManager.Instance.applyGray(this);
         }
         else
         {
            BuriedManager.Instance.reGray(this);
            if(Boolean(this._dragon))
            {
               this.playAllMc(this._dragon);
            }
         }
      }
      
      override public function get height() : Number
      {
         return 112;
      }
      
      private function addEvent() : void
      {
         this._dragon.addEventListener(MouseEvent.CLICK,this.__enterBossRoom);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._dragon))
         {
            this._dragon.removeEventListener(MouseEvent.CLICK,this.__enterBossRoom);
         }
      }
      
      private function __enterBossRoom(e:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         StateManager.setState(StateType.WORLDBOSS_AWARD);
      }
      
      public function setFrame(value:int) : void
      {
         if(Boolean(this._dragon))
         {
            this._dragon.gotoAndStop(value);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         this._dragon = null;
      }
   }
}

