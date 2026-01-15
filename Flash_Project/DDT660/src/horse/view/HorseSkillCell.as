package horse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import horse.HorseManager;
   import horse.data.HorseSkillGetVo;
   import horse.data.HorseSkillVo;
   
   public class HorseSkillCell extends Sprite implements ITipedDisplay, Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _skillId:int;
      
      private var _skillGetInfo:HorseSkillGetVo;
      
      private var _skillInfo:HorseSkillVo;
      
      private var _skillIcon:Bitmap;
      
      public function HorseSkillCell(skillId:int, isShowBg:Boolean = true, isScale:Boolean = false)
      {
         super();
         this._skillId = skillId;
         this._skillGetInfo = HorseManager.instance.getHorseSkillGetInfoById(this._skillId);
         this._skillInfo = HorseManager.instance.getHorseSkillInfoById(this._skillId);
         this._skillIcon = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop" + this._skillInfo.Pic + "Asset");
         if(isShowBg)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.horse.skillFrame.cell.bg");
            addChild(this._bg);
            isScale = true;
         }
         if(isScale)
         {
            this._skillIcon.smoothing = true;
            this._skillIcon.width = 38;
            this._skillIcon.height = 38;
            this._skillIcon.x = 3;
            this._skillIcon.y = 3;
         }
         addChild(this._skillIcon);
         ShowTipManager.Instance.addTip(this);
      }
      
      public function get tipData() : Object
      {
         return this._skillInfo;
      }
      
      public function set tipData(value:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "5,2,7,1,6,4";
      }
      
      public function set tipDirctions(value:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 5;
      }
      
      public function set tipGapH(value:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 5;
      }
      
      public function set tipGapV(value:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "horse.view.HorseSkillCellTip";
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
         this._bg = null;
         this._skillGetInfo = null;
         this._skillInfo = null;
         this._skillIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

