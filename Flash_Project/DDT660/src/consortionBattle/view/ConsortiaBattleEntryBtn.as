package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortiaBattleEntryBtn extends Sprite implements Disposeable
   {
      
      private var _btn:MovieClip;
      
      private var _isOpen:Boolean;
      
      public function ConsortiaBattleEntryBtn()
      {
         super();
         this.x = 47;
         this.y = 217;
         if(ConsortiaBattleManager.instance.isLoadIconMapComplete)
         {
            this.initThis();
         }
         else
         {
            ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         }
      }
      
      public function setEnble(bool:Boolean) : void
      {
         this._isOpen = bool;
         mouseChildren = bool;
         mouseEnabled = bool;
         if(bool)
         {
            BuriedManager.Instance.reGray(this);
            this.playAllMc(this._btn);
         }
         else
         {
            BuriedManager.Instance.applyGray(this);
         }
      }
      
      private function initThis() : void
      {
         this._btn = ComponentFactory.Instance.creat("assets.hallIcon.consortiaBattleEntryIcon");
         this._btn.gotoAndStop(1);
         this._btn.buttonMode = true;
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickhandler,false,0,true);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         if(!this._isOpen)
         {
            this.stopAllMc(this._btn);
         }
      }
      
      private function playAllMc($mc:MovieClip) : void
      {
         var cMc:MovieClip = null;
         var index:int = 0;
         if(Boolean($mc))
         {
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
      }
      
      private function stopAllMc($mc:MovieClip) : void
      {
         var cMc:MovieClip = null;
         var index:int = 0;
         if(Boolean($mc))
         {
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
      }
      
      private function clickhandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ConsortiaBattleManager.instance.isCanEnter)
         {
            GameInSocketOut.sendSingleRoomBegin(4);
         }
         else if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt2"));
         }
      }
      
      private function resLoadComplete(event:Event) : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         this.initThis();
      }
      
      private function closeHandler(event:Event) : void
      {
         this.closeDispose();
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
      }
      
      private function closeDispose() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickhandler);
            this._btn.gotoAndStop(2);
         }
         ObjectUtils.disposeAllChildren(this);
         this._btn = null;
      }
      
      public function dispose() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         this.closeDispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

