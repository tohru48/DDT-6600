package horse.horsePicCherish
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class HorsePicCherishTipItem extends Sprite implements Disposeable
   {
      
      private var _nameTxt:FilterFrameText;
      
      private var _valueTxt:FilterFrameText;
      
      private var _type:int;
      
      private var _isActive:Boolean;
      
      public function HorsePicCherishTipItem(type:int)
      {
         super();
         this._type = type;
         this.initView();
      }
      
      private function initView() : void
      {
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.commonTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("horse.pic.txt" + this._type);
         addChild(this._nameTxt);
         this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.valueTxt" + this._type);
         if(this._type == 1)
         {
            this._valueTxt.x = 154;
         }
         else
         {
            this._valueTxt.x = 154;
         }
         addChild(this._valueTxt);
      }
      
      public function set isActive(value:Boolean) : void
      {
         this._isActive = value;
      }
      
      public function set value(txt:String) : void
      {
         var txtType:int = 0;
         if(this._type == 1)
         {
            txtType = this._isActive ? this._type + 1 : this._type;
            ObjectUtils.disposeObject(this._valueTxt);
            this._valueTxt = null;
            this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.valueTxt" + txtType);
            this._valueTxt.x = 154;
            addChild(this._valueTxt);
         }
         this._valueTxt.text = txt;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._valueTxt);
         this._valueTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

