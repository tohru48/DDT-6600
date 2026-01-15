package witchBlessing.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class WitchBlessingFrame extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _text:FilterFrameText;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _needText:FilterFrameText;
      
      public function WitchBlessingFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var blessCountPic:Bitmap = null;
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("witchBlessing.view.doubleBlessTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         blessCountPic = ComponentFactory.Instance.creatBitmap("asset.witchBlessing.blessCount");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         PositionUtils.setPos(this._numberSelecter,"witchBlessing.expCountSelecterPos");
         this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
         this._needText = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.NeedText");
         this._needText.visible = false;
         addToContent(blessCountPic);
         addToContent(this._numberSelecter);
         addToContent(this._needText);
      }
      
      public function show(needCount:int, needExp:int, max:int, allNeedMax:int) : void
      {
         if(max > allNeedMax)
         {
            this._numberSelecter.valueLimit = 1 + "," + allNeedMax;
         }
         else
         {
            this._numberSelecter.valueLimit = 1 + "," + max;
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._numberSelecter.currentValue = 1;
         if(this.isDoubleTime(ServerConfigManager.instance.getWitchBlessDoubleGpTime))
         {
            this._needText.htmlText = LanguageMgr.GetTranslation("witchBlessing.View.NeedExpText",ServerConfigManager.instance.getWitchBlessMoney,int(ServerConfigManager.instance.getWitchBlessGP[2]) * 2,needExp);
         }
         else
         {
            this._needText.htmlText = LanguageMgr.GetTranslation("witchBlessing.View.NeedExpText",ServerConfigManager.instance.getWitchBlessMoney,ServerConfigManager.instance.getWitchBlessGP[2],needExp);
         }
         this._needText.visible = true;
      }
      
      private function isDoubleTime(doubleTime:String) : Boolean
      {
         var _dTime:Array = doubleTime.split("-");
         var starTime:Array = _dTime[0].toString().split(":");
         var endTime:Array = _dTime[1].toString().split(":");
         var date:Date = TimeManager.Instance.Now();
         var flag:Boolean = false;
         if(int(starTime[0]) <= date.getHours() && int(starTime[1]) <= date.getMinutes())
         {
            if(int(endTime[0]) >= date.getHours() && int(endTime[1]) >= date.getMinutes())
            {
               flag = true;
            }
         }
         return flag;
      }
      
      private function __seleterChange(event:Event) : void
      {
         SoundManager.instance.play("008");
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
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._numberSelecter);
         this._numberSelecter = null;
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._needText);
         this._needText = null;
      }
   }
}

