package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemAddInfo;
   
   public class TotemRightViewTxtTxtCell extends Sprite implements Disposeable
   {
      
      private var _leftTxt:FilterFrameText;
      
      private var _rightTxt:FilterFrameText;
      
      private var _txtArray:Array;
      
      private var _type:int;
      
      public function TotemRightViewTxtTxtCell()
      {
         super();
         this._leftTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.txtCell.leftTxt");
         this._rightTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.txtCell.rightTxt");
         var tmp:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
         this._txtArray = tmp.split(",");
         addChild(this._leftTxt);
         addChild(this._rightTxt);
      }
      
      public function show(type:int) : void
      {
         this._leftTxt.text = this._txtArray[type - 1] + "：";
         this._type = type;
         this.refresh();
      }
      
      public function refresh() : void
      {
         var addInfo:TotemAddInfo = TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId));
         switch(this._type)
         {
            case 1:
               this._rightTxt.text = addInfo.Attack.toString();
               break;
            case 2:
               this._rightTxt.text = addInfo.Defence.toString();
               break;
            case 3:
               this._rightTxt.text = addInfo.Agility.toString();
               break;
            case 4:
               this._rightTxt.text = addInfo.Luck.toString();
               break;
            case 5:
               this._rightTxt.text = addInfo.Blood.toString();
               break;
            case 6:
               this._rightTxt.text = addInfo.Damage.toString();
               break;
            case 7:
               this._rightTxt.text = addInfo.Guard.toString();
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._leftTxt = null;
         this._rightTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

