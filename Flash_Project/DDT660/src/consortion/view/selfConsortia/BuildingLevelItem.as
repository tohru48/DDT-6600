package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class BuildingLevelItem extends Sprite implements Disposeable, ITipedDisplay
   {
      
      private var _type:int = 0;
      
      private var _tipData:Object;
      
      private var _background:MutipleImage;
      
      private var _level:FilterFrameText;
      
      public function BuildingLevelItem(type:int)
      {
         super();
         this._type = type;
         this.initView();
      }
      
      private function initView() : void
      {
         ShowTipManager.Instance.addTip(this);
         switch(this._type)
         {
            case ConsortionModel.SHOP:
               this._background = ComponentFactory.Instance.creatComponentByStylename("consortion.shop");
               break;
            case ConsortionModel.STORE:
               this._background = ComponentFactory.Instance.creatComponentByStylename("consortion.store");
               break;
            case ConsortionModel.BANK:
               this._background = ComponentFactory.Instance.creatComponentByStylename("consortion.bank");
               break;
            case ConsortionModel.SKILL:
               this._background = ComponentFactory.Instance.creatComponentByStylename("consortion.skill");
         }
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.buildLevel");
         addChild(this._background);
         addChild(this._level);
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(vaule:Object) : void
      {
         this._tipData = ConsortionModelControl.Instance.model.getLevelString(this._type,vaule as int);
         this._level.text = "Lv." + vaule;
      }
      
      public function get tipDirctions() : String
      {
         return "3";
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
         return "consortion.ConsortiaLevelTip";
      }
      
      public function set tipStyle(value:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeAllChildren(this);
         this._background = null;
         this._level = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

