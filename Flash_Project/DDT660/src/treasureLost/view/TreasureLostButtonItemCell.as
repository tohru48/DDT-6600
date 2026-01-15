package treasureLost.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import treasureLost.controller.TreasureLostManager;
   
   public class TreasureLostButtonItemCell extends Sprite implements Disposeable
   {
      
      private var _buyImage:MovieClip;
      
      private var _backImage:Bitmap;
      
      private var _type:String;
      
      private var _count:int;
      
      private var _countText:FilterFrameText;
      
      private var _quick:QuickBuyFrame;
      
      public function TreasureLostButtonItemCell(type:String)
      {
         super();
         this._type = type;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._buyImage = ComponentFactory.Instance.creat("treasureLost.treasureLostBattleBuy");
         PositionUtils.setPos(this._buyImage,"treasureLost.treasureLostBattleBuyPOS");
         this._backImage = ComponentFactory.Instance.creatBitmap(this._type);
         this._countText = ComponentFactory.Instance.creatComponentByStylename("treasureLost.goldDiceBuyNumText");
         PositionUtils.setPos(this._countText,"treasureLost.treasureLostBattleBuyCountPos");
         addChild(this._backImage);
         addChild(this._buyImage);
         addChild(this._countText);
         this._buyImage.alpha = 0;
         this.updateCount();
      }
      
      public function updateCount() : void
      {
         var count:int = 0;
         if(this._type == "treasureLost.treasureLostBattleOne")
         {
            count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(TreasureLostManager.NORMALBALL);
         }
         else if(this._type == "treasureLost.treasureLostBattleAll")
         {
            count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(TreasureLostManager.ALLBALL);
         }
         this._countText.text = count + "";
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseRollover);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseRollout);
         addEventListener(MouseEvent.CLICK,this.____onMouseClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseRollover);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseRollout);
         removeEventListener(MouseEvent.CLICK,this.____onMouseClick);
      }
      
      protected function ____onMouseClick(event:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         if(this._type == "treasureLost.treasureLostBattleOne")
         {
            this._quick.itemID = TreasureLostManager.NORMALBALL;
         }
         else if(this._type == "treasureLost.treasureLostBattleAll")
         {
            this._quick.itemID = TreasureLostManager.ALLBALL;
         }
         LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __onMouseRollover(event:MouseEvent) : void
      {
         TweenLite.to(this._buyImage,0.25,{"alpha":1});
      }
      
      protected function __onMouseRollout(event:MouseEvent) : void
      {
         TweenLite.to(this._buyImage,0.25,{"alpha":0});
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._quick))
         {
            this._quick.dispose();
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

