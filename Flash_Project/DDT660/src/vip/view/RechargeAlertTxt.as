package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class RechargeAlertTxt extends Sprite implements Disposeable
   {
      
      private var _bg:Scale9CornerImage;
      
      private var _title:FilterFrameText;
      
      private var _content:FilterFrameText;
      
      public function RechargeAlertTxt()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._title = ComponentFactory.Instance.creat("VipRechargeLV.titleTxt");
         addChild(this._title);
         this._content = ComponentFactory.Instance.creat("VipRechargeLV.contentTxt");
         addChild(this._content);
      }
      
      public function set AlertContent(vipLev:int) : void
      {
         this._title.text = this.getAlertTitle(vipLev);
         this._content.text = this.getAlertTxt(vipLev);
      }
      
      private function getAlertTxt(lev:int) : String
      {
         var resultString:String = "";
         switch(lev)
         {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
               resultString += "1、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param0")) + "\n";
               resultString += "2、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2Param")) + "\n";
               resultString += "3、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               resultString += "4、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4Param0")) + "\n";
               resultString += "5、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param0")) + "\n";
               resultString += "6、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6") + "\n";
               resultString += "7、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7") + "\n";
               resultString += "8、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8") + "\n";
               resultString += "9、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent9",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param0"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param2")) + "\n";
               resultString += "            " + "\n";
               break;
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
               resultString += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent13") + "\n";
               resultString += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent14") + "\n";
               resultString += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent15") + "\n";
               resultString += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent16") + "\n";
               resultString += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent17") + "\n";
               resultString += "6、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param1")) + "\n";
               resultString += "7、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4Param1")) + "\n";
               resultString += "8、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               resultString += "9、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2Param")) + "\n";
               resultString += "10、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent6") + "\n";
               resultString += "11、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param1")) + "\n";
               resultString += "12、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8") + "\n";
               resultString += "13、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7") + "\n";
               resultString += "14、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent9",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param3")) + "\n";
               resultString += "            " + "\n";
         }
         return resultString;
      }
      
      private function getAlertTitle(lev:int) : String
      {
         var resultString:String = "";
         switch(lev)
         {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
               resultString = LanguageMgr.GetTranslation("tank.vip.rechargeAlertTitle",6);
               break;
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
               resultString = LanguageMgr.GetTranslation("tank.vip.rechargeAlertEndTitle",12);
         }
         return resultString;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
      }
   }
}

