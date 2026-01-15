package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class AvatarCollectionPropertyCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _valueTxt:FilterFrameText;
      
      private var _index:int;
      
      public function AvatarCollectionPropertyCell(index:int)
      {
         super();
         this._index = index;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarColl.propertyBg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyCell.nameTxt");
         var tmp:Array = LanguageMgr.GetTranslation("avatarCollection.propertyNameTxt").split(",");
         this._nameTxt.text = tmp[this._index];
         if(this._nameTxt.text.length <= 6)
         {
            this._nameTxt.y = 2;
         }
         this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.propertyCell.valueTxt");
         this._valueTxt.text = "0";
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._valueTxt);
      }
      
      public function refreshView(data:AvatarCollectionUnitVo, completeStatus:int) : void
      {
         if(completeStatus == -1)
         {
            this._valueTxt.text = "";
            return;
         }
         if(completeStatus == 0)
         {
            this._valueTxt.text = "0";
            return;
         }
         var tmpValue:int = 0;
         switch(this._index)
         {
            case 0:
               tmpValue = data.Attack;
               break;
            case 1:
               tmpValue = data.Defence;
               break;
            case 2:
               tmpValue = data.Agility;
               break;
            case 3:
               tmpValue = data.Luck;
               break;
            case 4:
               tmpValue = data.Damage;
               break;
            case 5:
               tmpValue = data.Guard;
               break;
            case 6:
               tmpValue = data.Blood;
         }
         var value:int = completeStatus == 2 ? tmpValue * 2 : tmpValue;
         this._valueTxt.text = value.toString();
      }
      
      public function refreshAllProperty(data:AvatarCollectionUnitVo) : void
      {
         var tmpValue:int = 0;
         switch(this._index)
         {
            case 0:
               tmpValue = data.Attack;
               break;
            case 1:
               tmpValue = data.Defence;
               break;
            case 2:
               tmpValue = data.Agility;
               break;
            case 3:
               tmpValue = data.Luck;
               break;
            case 4:
               tmpValue = data.Damage;
               break;
            case 5:
               tmpValue = data.Guard;
               break;
            case 6:
               tmpValue = data.Blood;
         }
         this._valueTxt.text = tmpValue.toString();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._nameTxt = null;
         this._valueTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

