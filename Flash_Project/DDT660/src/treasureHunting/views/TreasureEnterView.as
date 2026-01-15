package treasureHunting.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import treasureHunting.TreasureManager;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.views.IRightView;
   
   public class TreasureEnterView extends Sprite implements IRightView
   {
      
      private var _content:Sprite;
      
      private var _enterBG:Bitmap;
      
      private var _enterBtn:SimpleBitmapButton;
      
      private var _remainDay:FilterFrameText;
      
      private var _treasureFrame:TreasureHuntingFrame;
      
      public function TreasureEnterView()
      {
         super();
         TreasureManager.instance.loadTreasureHuntingModule(this.init2);
      }
      
      public function init() : void
      {
      }
      
      private function init2() : void
      {
         this.initView();
         this.initData();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._content = new Sprite();
         PositionUtils.setPos(this._content,"treasureHunting.Treasure.ContentPos");
         this._enterBG = ComponentFactory.Instance.creat("treasureHunting.enterBG");
         this._content.addChild(this._enterBG);
         this._enterBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.enterBtn");
         this._content.addChild(this._enterBtn);
         this._remainDay = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.remainDayTxt");
         this._content.addChild(this._remainDay);
         addChild(this._content);
      }
      
      private function initData() : void
      {
         var endDate:Date = TreasureManager.instance.endDate;
         var nowDate:Date = TimeManager.Instance.Now();
         var remain:String = WonderfulActivityManager.Instance.getTimeDiff(endDate,nowDate);
         this._remainDay.text = remain;
         if(remain == "0")
         {
            if(Boolean(this._remainDay))
            {
               this._remainDay.text = LanguageMgr.GetTranslation("treasureHunting.over");
            }
         }
      }
      
      private function initEvent() : void
      {
         this._enterBtn.addEventListener(MouseEvent.CLICK,this.onEnterBtnClick);
      }
      
      protected function onEnterBtnClick(event:MouseEvent) : void
      {
         this._treasureFrame = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.TreasureHuntingFrame");
         LayerManager.Instance.addToLayer(this._treasureFrame,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND,false);
      }
      
      private function removeEvent() : void
      {
         this._enterBtn.removeEventListener(MouseEvent.CLICK,this.onEnterBtnClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._enterBG))
         {
            ObjectUtils.disposeObject(this._enterBG);
         }
         this._enterBG = null;
         if(Boolean(this._enterBtn))
         {
            ObjectUtils.disposeObject(this._enterBtn);
         }
         this._enterBtn = null;
         if(Boolean(this._remainDay))
         {
            ObjectUtils.disposeObject(this._remainDay);
         }
         this._remainDay = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
   }
}

