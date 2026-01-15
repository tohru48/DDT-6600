package room.transnational
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import pet.date.PetSkillTemplateInfo;
   import pet.date.PetTemplateInfo;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.SkillItem;
   
   public class TransnationalPetCell extends SkillItem
   {
      
      private var _cellinfo:PetTemplateInfo;
      
      private var _shiner:Scale9CornerImage;
      
      private var _petIcon:DisplayObject;
      
      private var _skill:Array;
      
      private var cellBg:Bitmap;
      
      public function TransnationalPetCell(info:PetSkillTemplateInfo = null)
      {
         super(info,NaN);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__overhandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outhandler);
      }
      
      private function __overhandler(evt:MouseEvent) : void
      {
         this.cellBg.visible = true;
      }
      
      private function __outhandler(evt:MouseEvent) : void
      {
         this.cellBg.visible = false;
      }
      
      override protected function initView() : void
      {
         tipDirctions = "5,2,7,1,6,4";
         tipGapH = 20;
         tipGapV = 20;
         this.cellBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverShareBG");
         PositionUtils.setPos(this.cellBg,"Transnational.cellbackgroud.pos");
         this.cellBg.visible = false;
         addChild(this.cellBg);
         this.buttonMode = true;
      }
      
      public function set Cellinfo(value:PetTemplateInfo) : void
      {
         if(Boolean(this._petIcon))
         {
            ShowTipManager.Instance.removeTip(this);
            this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            this._petIcon.parent.removeChild(this._petIcon);
            this._petIcon = null;
         }
         this._cellinfo = value;
         if(Boolean(value))
         {
            ShowTipManager.Instance.addTip(this);
            this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagController.instance().getPetPic(value,TransnationalFightManager.TRANSNATIONAL_PETLEVEL)),new Rectangle(0,0,42,41),true);
            this._petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            addChild(this._petIcon);
         }
      }
      
      public function get Cellinfo() : PetTemplateInfo
      {
         return this._cellinfo;
      }
      
      public function setSkill(value:Array) : void
      {
         this._skill = value;
      }
      
      private function __fixPetIconPostion(e:Event) : void
      {
         if(Boolean(this._petIcon))
         {
            this._petIcon.x = 64 - this._petIcon.width >> 1;
            this._petIcon.y = 59 - this._petIcon.height >> 1;
         }
      }
      
      public function set cellSize(value:int) : void
      {
         var scale:Number = NaN;
         PositionUtils.setPos(this._petIcon,"ddtshop.ItemCellStartPos");
         if(this._petIcon.height >= value && value >= this._petIcon.width || this._petIcon.height >= this._petIcon.width && this._petIcon.width >= value || value >= this._petIcon.height && this._petIcon.height >= this._petIcon.width)
         {
            scale = this._petIcon.height / value;
         }
         else
         {
            scale = this._petIcon.width / value;
         }
         this._petIcon.height /= scale;
         this._petIcon.width /= scale;
         this._petIcon.x += (value - this._petIcon.width) / 2;
         this._petIcon.y += (value - this._petIcon.height) / 2;
      }
      
      override public function get tipStyle() : String
      {
         return "room.transnational.TransnationalPetCellTips";
      }
      
      override public function get tipData() : Object
      {
         return this._skill;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._petIcon.parent))
         {
            this._petIcon.parent.removeChild(this._petIcon);
            this._petIcon = null;
         }
         if(Boolean(this.cellBg))
         {
            ObjectUtils.disposeObject(this.cellBg);
            this.cellBg = null;
         }
         if(Boolean(this._skill))
         {
            ObjectUtils.disposeObject(this._skill);
            this._skill = null;
         }
         if(Boolean(this._cellinfo))
         {
            ObjectUtils.disposeObject(this._cellinfo);
            this._cellinfo = null;
         }
      }
   }
}

