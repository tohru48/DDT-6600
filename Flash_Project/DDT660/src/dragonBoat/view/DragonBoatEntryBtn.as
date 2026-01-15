package dragonBoat.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import dragonBoat.DragonBoatManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import hall.HallStateView;
   import hall.event.NewHallEvent;
   import hall.player.HallPlayerView;
   
   public class DragonBoatEntryBtn extends Component
   {
      
      private var _hallPlayerView:HallPlayerView;
      
      private var _consHitBtn:BaseButton;
      
      private var _content:Sprite;
      
      private var _boatMc:MovieClip;
      
      private var _boatTxt:Bitmap;
      
      private var _boatTxt2:Bitmap;
      
      private var _isDispose:Boolean = false;
      
      private var _mouseOverFilter:Array = [new GlowFilter(16777113,1,35,35,2)];
      
      private var _isCreate:Boolean = false;
      
      private var activeId:int;
      
      public function DragonBoatEntryBtn(hallPlayerView:HallPlayerView)
      {
         super();
         this._hallPlayerView = hallPlayerView;
         this._consHitBtn = ComponentFactory.Instance.creatComponentByStylename("HallMain.dragonBoatBtn");
         addChild(this._consHitBtn);
         this.x = 464;
         this.y = 300;
         this.buttonMode = true;
         this._content = new Sprite();
         this._content.x = this.x;
         this._content.y = this.y;
         if(DragonBoatManager.instance.isStart && DragonBoatManager.instance.isLoadBoatResComplete)
         {
            this.initThis();
         }
         else
         {
            DragonBoatManager.instance.addEventListener(DragonBoatManager.BOAT_RES_LOAD_COMPLETE,this.resLoadComplete);
         }
         this.initTips();
         this._hallPlayerView.addEventListener(NewHallEvent.BTNCLICK,this.__onBtnClick);
      }
      
      private function initTips() : void
      {
         this.tipStyle = "ddt.view.tips.HallBuildTip";
         this.tipDirctions = "0,1,2";
         this.tipGapV = 120;
      }
      
      override public function get tipData() : Object
      {
         var consortionObj:Object = new Object();
         if(this.activeId == 1)
         {
            if(DragonBoatManager.instance.isBuildEnd)
            {
               consortionObj["title"] = LanguageMgr.GetTranslation("ddt.hall.dragonboatentrybtnTitle");
            }
            else
            {
               consortionObj["title"] = LanguageMgr.GetTranslation("ddt.dragonBoat.frameTitle");
            }
         }
         else
         {
            consortionObj["title"] = LanguageMgr.GetTranslation("ddt.kingStatue.frameTitle");
         }
         consortionObj["content"] = LanguageMgr.GetTranslation("ddt.hall.dragonboatentrybtnContent");
         return consortionObj;
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         if(!this._boatMc)
         {
            return;
         }
         this._boatMc.filters = this._mouseOverFilter;
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         if(!this._boatMc)
         {
            return;
         }
         this._boatMc.filters = null;
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         this._hallPlayerView.MapClickFlag = false;
         this._hallPlayerView.setSelfPlayerPos(new Point(450,363));
         HallStateView.btnID = DragonBoatManager.BTNID_DRAGONBOAT;
      }
      
      private function __onBtnClick(event:NewHallEvent) : void
      {
         if(HallStateView.btnID == DragonBoatManager.BTNID_DRAGONBOAT)
         {
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.Grade < DragonBoatManager.instance.activeInfo.LimitGrade)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dragonBoat.cannotEnterPromptTxt"));
               return;
            }
            DragonBoatManager.instance.loadUIModule(DragonBoatManager.instance.doOpenDragonBoatFrame);
            HallStateView.btnID = -1;
         }
      }
      
      private function refreshBoatStatusHandler(event:Event) : void
      {
         if(Boolean(this._boatMc))
         {
            this._boatMc.gotoAndStop(6);
         }
         this.isShowBoatTxt();
      }
      
      private function initThis() : void
      {
         this.activeId = DragonBoatManager.instance.activeInfo.ActiveID;
         this._isCreate = true;
         switch(this.activeId)
         {
            case 1:
               this._boatMc = ComponentFactory.Instance.creat("asset.dragonBoat.boatMc");
               this._boatMc.gotoAndStop(DragonBoatManager.instance.boatInWhatStatus);
               this._boatMc.mouseChildren = false;
               this._content.addChild(this._boatMc);
               this._boatTxt = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.boatTxt");
               this._boatTxt.x = -72;
               this._boatTxt.y = -130;
               this._content.addChild(this._boatTxt);
               this._boatTxt2 = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.boatTxt2");
               this._boatTxt2.x = -62;
               this._boatTxt2.y = -130;
               this._content.addChild(this._boatTxt2);
               break;
            case 4:
               this._boatMc = ComponentFactory.Instance.creat("asset.kingStatue.statueMc");
               this._boatMc.gotoAndStop(6);
               this._boatMc.mouseChildren = false;
               this._content.addChild(this._boatMc);
               this._boatTxt = ComponentFactory.Instance.creatBitmap("asset.kingStatue.statueTxt");
               this._boatTxt.x = -52;
               this._boatTxt.y = -128;
               this._content.addChild(this._boatTxt);
         }
         DragonBoatManager.instance.addEventListener(DragonBoatManager.REFRESH_BOAT_STATUS,this.refreshBoatStatusHandler);
         addEventListener(MouseEvent.CLICK,this.clickHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,this.overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.isShowBoatTxt();
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      private function isShowBoatTxt() : void
      {
         if(DragonBoatManager.instance.isBuildEnd && this.activeId == 1)
         {
            this._boatTxt.visible = false;
            if(Boolean(this._boatTxt2))
            {
               this._boatTxt2.visible = true;
            }
         }
         else
         {
            this._boatTxt.visible = true;
            if(Boolean(this._boatTxt2))
            {
               this._boatTxt2.visible = false;
            }
         }
      }
      
      private function resLoadComplete(event:Event) : void
      {
         DragonBoatManager.instance.removeEventListener(DragonBoatManager.BOAT_RES_LOAD_COMPLETE,this.resLoadComplete);
         this.initThis();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._isDispose)
         {
            return;
         }
         DragonBoatManager.instance.removeEventListener(DragonBoatManager.BOAT_RES_LOAD_COMPLETE,this.resLoadComplete);
         this._hallPlayerView.removeEventListener(NewHallEvent.BTNCLICK,this.__onBtnClick);
         if(this._isCreate)
         {
            removeEventListener(MouseEvent.MOUSE_MOVE,this.overHandler);
            removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
            removeEventListener(MouseEvent.CLICK,this.clickHandler);
            DragonBoatManager.instance.removeEventListener(DragonBoatManager.REFRESH_BOAT_STATUS,this.refreshBoatStatusHandler);
            if(Boolean(this._boatMc))
            {
               this._boatMc.gotoAndStop(this._boatMc.totalFrames);
            }
            ObjectUtils.disposeAllChildren(this);
            this._boatMc = null;
            this._boatTxt = null;
         }
         this._consHitBtn = null;
         this._mouseOverFilter = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._isDispose = true;
      }
   }
}

