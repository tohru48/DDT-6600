package labyrinth.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import labyrinth.LabyrinthManager;
   
   public class LabyrinthBoxIcon extends Sprite implements Disposeable, ITipedDisplay
   {
      
      private var _icon:Bitmap;
      
      private var _levelText:GradientText;
      
      private var _index:int;
      
      private var _level:int;
      
      private var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      private var _tipData:Object;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _myColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
      
      public function LabyrinthBoxIcon(index:int)
      {
         this._index = index;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._icon = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.Box");
         addChild(this._icon);
         this._levelText = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.BoxText");
         addChild(this._levelText);
         this.tipStyle = "labyrinth.view.LabyrinthBoxIconTips";
         this.tipDirctions = "7,2,5";
         this.update();
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      protected function __updateInfo(event:Event) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var temp:String = "";
         var myProgress:int = LabyrinthManager.Instance.model.myProgress;
         if(myProgress <= 20)
         {
            this._level = this._index * 2;
         }
         else if(myProgress <= 40)
         {
            this._level = 20 + this._index * 2;
         }
         else
         {
            this._level = 40 + this._index * 2;
         }
         if(myProgress + 2 < this._level)
         {
            temp = "?";
            this.filters = [this._myColorMatrix_filter];
            ShowTipManager.Instance.removeTip(this);
         }
         else if(myProgress < this._level)
         {
            temp = this._level.toString() + LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIcon.floor");
            this.filters = [this._myColorMatrix_filter];
            ShowTipManager.Instance.addTip(this);
            if(this._level == 32)
            {
               this.tipData = {"label":LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.labelII")};
               ShowTipManager.Instance.addTip(this);
            }
         }
         else
         {
            temp = this._level.toString() + LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIcon.floor");
            this.filters = null;
            ShowTipManager.Instance.addTip(this);
         }
         this._levelText.text = temp;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
         this._tipData = value;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._levelText);
         this._levelText = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

