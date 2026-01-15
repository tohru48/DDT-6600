package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class AvatarCollectionPropertyTip extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _line:ScaleBitmapImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _valueTxtList:Vector.<FilterFrameText>;
      
      private var _titleStrList:Array;
      
      public function AvatarCollectionPropertyTip()
      {
         var i:int = 0;
         var nameTxt:FilterFrameText = null;
         var valueTxt:FilterFrameText = null;
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._bg.width = 178;
         this._bg.height = 205;
         addChild(this._bg);
         this._line = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line.width = 168;
         this._line.x = 4;
         this._line.y = 36;
         addChild(this._line);
         this._titleStrList = LanguageMgr.GetTranslation("avatarCollection.propertyTipTitleTxt").split(",");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.titleTxt");
         addChild(this._titleTxt);
         this._valueTxtList = new Vector.<FilterFrameText>();
         var nameStrList:Array = LanguageMgr.GetTranslation("avatarCollection.propertyNameTxt").split(",");
         for(i = 0; i < 7; i++)
         {
            nameTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.nameTxt");
            nameTxt.text = nameStrList[i] + "：";
            nameTxt.x = 15;
            nameTxt.y = i * 20 + 46;
            addChild(nameTxt);
            valueTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyTip.valueTxt");
            valueTxt.text = "0";
            valueTxt.x = 80;
            valueTxt.y = i * 20 + 46;
            addChild(valueTxt);
            this._valueTxtList.push(valueTxt);
         }
      }
      
      public function refreshView(data:AvatarCollectionUnitVo, completeStatus:int) : void
      {
         this._valueTxtList[0].text = (data.Attack * completeStatus).toString();
         this._valueTxtList[1].text = (data.Defence * completeStatus).toString();
         this._valueTxtList[2].text = (data.Agility * completeStatus).toString();
         this._valueTxtList[3].text = (data.Luck * completeStatus).toString();
         this._valueTxtList[4].text = (data.Damage * completeStatus).toString();
         this._valueTxtList[5].text = (data.Guard * completeStatus).toString();
         this._valueTxtList[6].text = (data.Blood * completeStatus).toString();
         this._titleTxt.text = this._titleStrList[completeStatus - 1];
         if(Boolean(this._bg))
         {
            this._bg.width = Math.max(this._titleTxt.width,this._valueTxtList[0].width,this._valueTxtList[1].width,this._valueTxtList[2].width,this._valueTxtList[3].width,this._valueTxtList[4].width,this._valueTxtList[5].width,this._valueTxtList[6].width) + 20;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._line = null;
         this._titleTxt = null;
         this._valueTxtList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

