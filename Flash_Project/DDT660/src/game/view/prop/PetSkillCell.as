package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import pet.date.PetSkill;
   
   public class PetSkillCell extends PropCell
   {
      
      private var _skill:PetSkill;
      
      private var _turnNum:int = 0;
      
      private var _skillPic:BitmapLoaderProxy;
      
      private var _lockBg:Bitmap;
      
      private var _normHeight:Number;
      
      private var _normWidth:Number;
      
      private var _skillPicWidth:Number = 33;
      
      private var _skillPicHeight:Number = 33;
      
      public function PetSkillCell(shortcutKey:String = null, mode:int = -1, allowDrag:Boolean = false, normWidth:Number = 0, normHeight:Number = 0)
      {
         super(shortcutKey,mode,allowDrag);
         this.setGrayFilter();
         this._normWidth = normWidth;
         this._normHeight = normHeight;
      }
      
      override public function get tipStyle() : String
      {
         return "ddt.view.tips.PetSkillCellTip";
      }
      
      override public function get tipData() : Object
      {
         return this._skill;
      }
      
      public function creteSkillCell(value:PetSkill, isLock:Boolean = false) : void
      {
         ShowTipManager.Instance.removeTip(this);
         this._skill = value;
         if(this._skill != null)
         {
            this._skillPic = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(this._skill.Pic),new Rectangle(0,0,this._skillPicWidth,this._skillPicHeight));
            addChild(this._skillPic);
            ShowTipManager.Instance.addTip(this);
            this._turnNum = this._skill.ColdDown;
            buttonMode = true;
         }
         else
         {
            _fore = _bitmapMgr.creatBitmapShape("asset.game.petSkillBarCellBg",null,false,true);
            addChild(_fore);
            buttonMode = false;
            _tipInfo = null;
         }
         if(isLock)
         {
            this.drawLockBg();
         }
         this.shortcutKeyConfigUI();
         this.positionAdjust();
      }
      
      private function positionAdjust() : void
      {
         if(Boolean(this._skillPic))
         {
            if(this._normWidth > 0)
            {
               this._skillPic.x = (this._normWidth - this._skillPicWidth) / 2;
            }
            if(this._normHeight > 0)
            {
               this._skillPic.y = (this._normHeight - this._skillPicHeight) / 2;
            }
         }
         if(Boolean(_shortcutKeyShape) && Boolean(this._skillPic))
         {
            _shortcutKeyShape.x = this._skillPic.x;
            _shortcutKeyShape.y = this._skillPic.y;
         }
         if(Boolean(_fore))
         {
            if(this._normWidth > 0)
            {
               _fore.x = (this._normWidth - this._skillPicWidth) / 2;
            }
            if(this._normHeight > 0)
            {
               _fore.y = (this._normHeight - this._skillPicHeight) / 2;
            }
         }
      }
      
      private function drawLockBg() : void
      {
         if(!this._skill && !this._lockBg)
         {
            this._lockBg = ComponentFactory.Instance.creatBitmap("asset.game.petSkillLockBg");
            addChild(this._lockBg);
         }
      }
      
      override protected function configUI() : void
      {
         _tipInfo = new ToolPropInfo();
         _tipInfo.showThew = true;
      }
      
      private function shortcutKeyConfigUI() : void
      {
         if(_shortcutKey != null && _shortcutKeyShape == null)
         {
            if(this._skill && this._skill.isActiveSkill || !this._skill)
            {
               _shortcutKeyShape = ComponentFactory.Instance.creatBitmap("asset.game.prop.ShortcutKey" + _shortcutKey);
               Bitmap(_shortcutKeyShape).smoothing = true;
               _shortcutKeyShape.y = -2;
               addChild(_shortcutKeyShape);
               drawLayer();
            }
            else
            {
               _shortcutKey = null;
            }
         }
      }
      
      public function get skillInfo() : PetSkill
      {
         return this._skill;
      }
      
      public function get isEnabled() : Boolean
      {
         if(Boolean(this._skill) && this._skill.isActiveSkill)
         {
            return true;
         }
         return false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._lockBg))
         {
            ObjectUtils.disposeObject(this._lockBg);
         }
         this._lockBg = null;
         ObjectUtils.disposeObject(this._skillPic);
         this._skillPic = null;
         this._skill = null;
      }
      
      public function get turnNum() : int
      {
         return this._turnNum;
      }
      
      public function set turnNum(value:int) : void
      {
         this._turnNum = value;
      }
   }
}

