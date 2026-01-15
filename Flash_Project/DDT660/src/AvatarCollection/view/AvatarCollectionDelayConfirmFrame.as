package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   
   public class AvatarCollectionDelayConfirmFrame extends BaseAlerFrame
   {
      
      private var _numberSelecter:NumberSelecter;
      
      private var _text:FilterFrameText;
      
      private var _needFoodText:FilterFrameText;
      
      public function AvatarCollectionDelayConfirmFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var alertInfo:AlertInfo = null;
         var alertInfos:AlertInfo = null;
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         if(AvatarCollectionManager.instance.skipIdArray != null && AvatarCollectionManager.instance.skipIdArray.length > 0 && AvatarCollectionManager.instance.skipFlag)
         {
            alertInfo = new AlertInfo(LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.titleTxtAll"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            alertInfo.moveEnable = false;
            info = alertInfo;
         }
         else
         {
            alertInfos = new AlertInfo(LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.titleTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            alertInfos.moveEnable = false;
            info = alertInfos;
         }
         this.escEnable = true;
         this._text = ComponentFactory.Instance.creatComponentByStylename("avatarColl.delayConfirmFrame.dayNameTxt");
         this._text.text = LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.dayNameTxt");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
         PositionUtils.setPos(this._numberSelecter,"avatarColl.delayConfirmFrame.numberSelecterPos");
         this._needFoodText = ComponentFactory.Instance.creatComponentByStylename("avatarColl.delayConfirmFrame.promptTxt");
         addToContent(this._text);
         addToContent(this._numberSelecter);
         addToContent(this._needFoodText);
      }
      
      private function __seleterChange(event:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function show(needHonor:int, maxCount:int) : void
      {
         if(AvatarCollectionManager.instance.skipIdArray != null && AvatarCollectionManager.instance.skipIdArray.length > 0 && AvatarCollectionManager.instance.skipFlag)
         {
            this._needFoodText.htmlText = LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.promptTxtAll",needHonor);
         }
         else
         {
            this._needFoodText.htmlText = LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.promptTxt",needHonor);
         }
         this._numberSelecter.valueLimit = "1,99";
      }
      
      public function get selectValue() : int
      {
         return this._numberSelecter.currentValue;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._numberSelecter = null;
         this._text = null;
         this._needFoodText = null;
      }
   }
}

