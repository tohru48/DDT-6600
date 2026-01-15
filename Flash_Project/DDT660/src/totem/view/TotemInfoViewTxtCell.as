package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemAddInfo;
   
   public class TotemInfoViewTxtCell extends Sprite implements Disposeable
   {
      
      private var _nameTxt:FilterFrameText;
      
      private var _valueTxt:FilterFrameText;
      
      private var _txtArray:Array;
      
      private var _bg:Bitmap;
      
      public function TotemInfoViewTxtCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.infoView.txtCellBg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.infoView.propertyName.txt");
         this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.infoView.propertyValue.txt");
         var tmp:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
         this._txtArray = tmp.split(",");
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._valueTxt);
      }
      
      public function show(type:int, totemLevel:int) : void
      {
         this._nameTxt.text = this._txtArray[type - 1];
         var addInfo:TotemAddInfo = TotemManager.instance.getAddInfo(totemLevel);
         switch(type)
         {
            case 1:
               this._valueTxt.text = addInfo.Attack.toString();
               break;
            case 2:
               this._valueTxt.text = addInfo.Defence.toString();
               break;
            case 3:
               this._valueTxt.text = addInfo.Agility.toString();
               break;
            case 4:
               this._valueTxt.text = addInfo.Luck.toString();
               break;
            case 5:
               this._valueTxt.text = addInfo.Blood.toString();
               break;
            case 6:
               this._valueTxt.text = addInfo.Damage.toString();
               break;
            case 7:
               this._valueTxt.text = addInfo.Guard.toString();
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._nameTxt = null;
         this._valueTxt = null;
         this._bg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

