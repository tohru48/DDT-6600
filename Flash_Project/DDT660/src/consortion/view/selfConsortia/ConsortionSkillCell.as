package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITransformableTipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortionSkillInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ConsortionSkillCell extends Sprite implements Disposeable, ITransformableTipedDisplay
   {
      
      private var _info:ConsortionSkillInfo;
      
      private var _bg:Bitmap;
      
      public function ConsortionSkillCell()
      {
         super();
         buttonMode = true;
         ShowTipManager.Instance.addTip(this);
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.addTip(this);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         if(this._info.isOpen)
         {
            return LanguageMgr.GetTranslation("civil.register.NicknameLabel") + this._info.name + "\n" + LanguageMgr.GetTranslation("ddt.view.skillFrame.effect") + this._info.descript.replace("{0}",this._info.value) + "\n" + LanguageMgr.GetTranslation("ddt.consortion.skillTip.validity",this._info.validity);
         }
         return LanguageMgr.GetTranslation("civil.register.NicknameLabel") + this._info.name + "\n" + LanguageMgr.GetTranslation("ddt.view.skillFrame.effect") + this._info.descript.replace("{0}",this._info.value);
      }
      
      public function get info() : ConsortionSkillInfo
      {
         return this._info;
      }
      
      public function set tipData(value:Object) : void
      {
         this._info = value as ConsortionSkillInfo;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.skillIcon." + this._info.pic);
         PositionUtils.setPos(this._bg,"asset.consortion.skillIcon.pos");
         addChild(this._bg);
         this._bg.smoothing = true;
         if(!this._info.isOpen)
         {
            this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this.filters = null;
         }
      }
      
      public function contentRect(width:int, height:int) : void
      {
         this._bg.width = width;
         this._bg.height = height;
      }
      
      public function setGray(value:Boolean) : void
      {
         if(!value)
         {
            this.filters = null;
         }
      }
      
      public function get tipDirctions() : String
      {
         return "0";
      }
      
      public function set tipDirctions(value:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipGapH(value:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function set tipGapV(value:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "ddt.view.tips.MultipleLineTip";
      }
      
      public function set tipStyle(value:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function get tipWidth() : int
      {
         return 200;
      }
      
      public function set tipWidth(w:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return -1;
      }
      
      public function set tipHeight(h:int) : void
      {
      }
   }
}

