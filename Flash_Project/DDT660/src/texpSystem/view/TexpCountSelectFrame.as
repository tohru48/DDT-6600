package texpSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   
   public class TexpCountSelectFrame extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _text:FilterFrameText;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _needText:FilterFrameText;
      
      private var _texpInfo:InventoryItemInfo;
      
      public function TexpCountSelectFrame()
      {
         super();
         this.intView();
      }
      
      private function intView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("texpSystem.view.TexpCountSelect.frame"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._text = ComponentFactory.Instance.creatComponentByStylename("texpSystem.TexpCountSelectFrame.Text");
         this._text.text = LanguageMgr.GetTranslation("texpSystem.view.TexpCountSelect.text");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         PositionUtils.setPos(this._numberSelecter,"texpSystem.expCountSelecterPos");
         this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
         this._needText = ComponentFactory.Instance.creatComponentByStylename("texpSystem.TexpCountSelectFrame.NeedText");
         this._needText.visible = false;
         addToContent(this._text);
         addToContent(this._numberSelecter);
         addToContent(this._needText);
      }
      
      public function show(needCount:int, max:int, min:int = 1) : void
      {
         this._numberSelecter.valueLimit = min + "," + max;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._numberSelecter.currentValue = needCount;
         var maxNumInBag:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this.texpInfo.TemplateID);
         if(maxNumInBag < needCount)
         {
            this._numberSelecter.currentValue = maxNumInBag;
         }
         if(max < needCount)
         {
            this._numberSelecter.currentValue = max;
         }
         this._needText.htmlText = LanguageMgr.GetTranslation("texpSystem.view.TexpCountSelect.CountText",needCount);
         this._needText.visible = true;
         if(needCount > max)
         {
            this._numberSelecter.currentValue = max;
         }
         else
         {
            this._numberSelecter.currentValue = needCount;
         }
      }
      
      private function __seleterChange(event:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function get texpInfo() : InventoryItemInfo
      {
         return this._texpInfo;
      }
      
      public function set texpInfo(value:InventoryItemInfo) : void
      {
         this._texpInfo = value;
      }
      
      public function get count() : int
      {
         return this._numberSelecter.currentValue;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._numberSelecter))
         {
            this._numberSelecter.removeEventListener(Event.CHANGE,this.__seleterChange);
         }
         this.removeView();
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._numberSelecter);
         this._numberSelecter = null;
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._needText);
         this._needText = null;
      }
   }
}

