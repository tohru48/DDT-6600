package farm.viewx.helper
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   
   public class HelperBeginFrame extends BaseAlerFrame
   {
      
      private var _explainText:FilterFrameText;
      
      private var _explainText2:FilterFrameText;
      
      private var _explainText3:FilterFrameText;
      
      private var _bgTitle:DisplayObject;
      
      public var modelType:int;
      
      private var _seedID:int;
      
      private var _seedTime:int;
      
      private var _needCount:int;
      
      private var _haveCount:int;
      
      private var _getCount:int;
      
      private var _needMoney:int;
      
      private var _moneyType:int;
      
      private var _moneyTypeText:String;
      
      private var _ifNeed:Boolean;
      
      private var _isDDTMoney:Boolean = false;
      
      private var _showPayMoneyBG:Image;
      
      public function HelperBeginFrame()
      {
         super();
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.escEnable = true;
         alertInfo.title = LanguageMgr.GetTranslation("ddt.farm.beginFrame.title");
         alertInfo.bottomGap = 37;
         alertInfo.buttonGape = 90;
         alertInfo.customPos = ComponentFactory.Instance.creat("farm.confirmHelperBeginAlertBtnPos");
         this.info = alertInfo;
         height = 250;
         this._needCount = 0;
         this._ifNeed = false;
         this.intView();
         this.intEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(this.modelType == -1)
         {
            if(this._needCount > 0)
            {
               this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText1",this._needCount,this._needMoney);
               this._explainText.text += this._moneyTypeText;
               this._explainText3.x = 57;
               this._explainText3.y = 75;
               this._explainText2.x = 105;
               this._explainText2.y = 50;
               PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos2");
               _submitButton.y = 102;
               _cancelButton.y = 102;
               addToContent(this._explainText2);
            }
            else
            {
               this._explainText3.x = 57;
               this._explainText3.y = 75;
               _submitButton.y = 102;
               _cancelButton.y = 102;
            }
            return;
         }
         if(this._needCount > 0)
         {
            this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText1",this._needCount,this._needMoney);
            this._explainText.text += this._moneyTypeText;
            this._explainText2.x = 106;
            this._explainText2.y = 50;
            this._explainText3.x = 55;
            this._explainText3.y = 75;
            PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos2");
            _submitButton.y = 102;
            _cancelButton.y = 102;
            addToContent(this._explainText2);
         }
         else
         {
            _submitButton.y = 102;
            _cancelButton.y = 102;
         }
      }
      
      private function intView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         PositionUtils.setPos(this._bgTitle,"farm.HelperBeginTitlePos");
         addChild(this._bgTitle);
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText");
         this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText");
         PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos1");
         addToContent(this._explainText);
         this._explainText2 = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText2");
         this._explainText2.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText2");
         this._explainText3 = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText3");
         this._explainText3.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText3");
         addToContent(this._explainText3);
      }
      
      private function intEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      protected function __framePesponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.submit();
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
               this.dispose();
               break;
            case FrameEvent.CANCEL_CLICK:
               removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
               this.dispose();
         }
      }
      
      private function submit() : void
      {
         if(this._needCount > 0)
         {
            switch(this.modelType)
            {
               case -2:
                  if(PlayerManager.Instance.Self.BandMoney < this._needMoney)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.madelLack"));
                     return;
                  }
                  break;
               case -8:
                  if(PlayerManager.Instance.Self.Money < this._needMoney)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureHunting.tip1"));
                     return;
                  }
                  break;
               case -9:
                  if(PlayerManager.Instance.Self.BandMoney < this._needMoney)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureHunting.tip1"));
                     return;
                  }
                  break;
            }
         }
         var array:Array = new Array();
         array.push(true);
         array.push(this._seedID);
         array.push(this._seedTime);
         array.push(this._haveCount);
         array.push(this._getCount);
         array.push(this._moneyType);
         array.push(this._needMoney);
         array.push(_isBand);
         SocketManager.Instance.out.sendBeginHelper(array);
         this.dispose();
      }
      
      private function __poorManResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function removeEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      private function removeView() : void
      {
         if(Boolean(this._explainText))
         {
            ObjectUtils.disposeObject(this._explainText);
         }
         this._explainText = null;
      }
      
      public function get seedID() : int
      {
         return this._seedID;
      }
      
      public function set seedID(value:int) : void
      {
         this._seedID = value;
      }
      
      public function get seedTime() : int
      {
         return this._seedTime;
      }
      
      public function set seedTime(value:int) : void
      {
         this._seedTime = value;
      }
      
      public function get needCount() : int
      {
         return this._needCount;
      }
      
      public function set needCount(value:int) : void
      {
         var ID:int = 0;
         this._needCount = value;
         var infoList:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         for(var i:int = 0; i < infoList.length; i++)
         {
            ID = infoList[i].TemplateID;
            if(this._seedID == ID)
            {
               this._needMoney = this._needCount * infoList[i].AValue1;
               this._moneyType = infoList[i].APrice1;
               if(this._needCount * infoList[i].getItemPrice(1).bandDdtMoneyValue > 0)
               {
                  this._isDDTMoney = true;
                  this._moneyTypeText = LanguageMgr.GetTranslation("ddtMoney");
               }
               if(this._needCount * infoList[i].getItemPrice(1).moneyValue > 0)
               {
                  this._isDDTMoney = false;
                  this._moneyTypeText = LanguageMgr.GetTranslation("money");
               }
            }
         }
      }
      
      public function get haveCount() : int
      {
         return this._haveCount;
      }
      
      public function set haveCount(value:int) : void
      {
         this._haveCount = value;
      }
      
      public function get getCount() : int
      {
         return this._getCount;
      }
      
      public function set getCount(value:int) : void
      {
         this._getCount = value;
      }
      
      override public function dispose() : void
      {
         this.removeView();
         this.removeEvent();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

