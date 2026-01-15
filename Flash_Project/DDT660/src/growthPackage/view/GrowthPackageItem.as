package growthPackage.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import growthPackage.GrowthPackageManager;
   import growthPackage.data.GrowthPackageInfo;
   
   public class GrowthPackageItem extends Sprite implements Disposeable
   {
      
      private var _index:int;
      
      private var _levelHead:Bitmap;
      
      private var _cellsBg:ScaleBitmapImage;
      
      private var _cells:HBox;
      
      private var _cellsArr:Array;
      
      private var _getBtn:TextButton;
      
      private var _getBtnGlow:MovieClip;
      
      private var _getIcon:Bitmap;
      
      private var _cellsBgWidth:Number;
      
      public function GrowthPackageItem($index:int)
      {
         super();
         this._index = $index;
         this.initView();
         this.updateView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._levelHead = ComponentFactory.Instance.creatBitmap("assets.growthPackage.Item" + this._index);
         if(this._index < 3)
         {
            this._cellsBg = ComponentFactory.Instance.creatComponentByStylename("growthPackage.LevelBg1");
         }
         else if(this._index < 6)
         {
            this._cellsBg = ComponentFactory.Instance.creatComponentByStylename("growthPackage.LevelBg2");
         }
         else if(this._index < 9)
         {
            this._cellsBg = ComponentFactory.Instance.creatComponentByStylename("growthPackage.LevelBg3");
         }
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("growthPackage.getBtn");
         this._getBtn.text = LanguageMgr.GetTranslation("ddt.growthPackage.itemGetBtnTxt");
         this._getBtnGlow = ClassUtils.CreatInstance("assets.growthPackage.BtnGlow");
         this._getBtnGlow.mouseChildren = false;
         this._getBtnGlow.mouseEnabled = false;
         this._getBtnGlow.x = this._getBtn.x - 5;
         this._getBtnGlow.y = this._getBtn.y - 1;
         this._getIcon = ComponentFactory.Instance.creatBitmap("assets.growthPackage.getIcon");
         addChild(this._levelHead);
         if(Boolean(this._cellsBg))
         {
            this._cellsBgWidth = this._cellsBg.width;
            PositionUtils.setPos(this._cellsBg,"growthPackageItem.cellsBgPos");
            addChild(this._cellsBg);
         }
         this._cells = new HBox();
         this._cells.spacing = 2;
         PositionUtils.setPos(this._cells,"growthPackageItem.cellsPos");
         if(this._index > 5)
         {
            this._cells.y = 5;
         }
         addChild(this._cells);
         addChild(this._getBtn);
         addChild(this._getBtnGlow);
         addChild(this._getIcon);
         this.isComplete(0);
      }
      
      private function initEvent() : void
      {
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__getBtnClickHandler);
      }
      
      private function removeEvent() : void
      {
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__getBtnClickHandler);
      }
      
      private function __getBtnClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(GrowthPackageManager.instance.model.isBuy < 1)
         {
            GrowthPackageManager.instance.showBuyFrame();
         }
         else
         {
            SocketManager.Instance.out.sendGrowthPackageGetItems(this._index);
         }
      }
      
      private function updateView() : void
      {
         var i:int = 0;
         var growthPackageInfo:GrowthPackageInfo = null;
         var _info:InventoryItemInfo = null;
         var cell:GrowthPackageCell = null;
         this._cellsArr = new Array();
         var itemInfoList:Vector.<GrowthPackageInfo> = GrowthPackageManager.instance.model.itemInfoList[this._index];
         if(Boolean(itemInfoList))
         {
            for(i = 0; i < itemInfoList.length; i++)
            {
               growthPackageInfo = itemInfoList[i];
               _info = GrowthPackageManager.instance.model.getInventoryItemInfo(growthPackageInfo);
               cell = this.creatItemCell(_info);
               this._cells.addChild(cell);
               this._cellsArr.push(cell);
            }
            this._cells.arrange();
         }
         this._cellsBg.width = this._cells.width + 33;
         if(this._cellsBg.width < this._cellsBgWidth)
         {
            this._cellsBg.width = this._cellsBgWidth;
         }
         this.updateState();
      }
      
      public function updateState() : void
      {
         var isComp:int = int(GrowthPackageManager.instance.model.isCompleteList[this._index]);
         var grade:int = int(GrowthPackageManager.instance.model.gradeList[this._index]);
         if(this._index == 0 && isComp != 1)
         {
            this.isComplete(2);
         }
         else if(isComp == 0 && PlayerManager.Instance.Self.Grade >= grade)
         {
            this.isComplete(2);
         }
         else
         {
            this.isComplete(isComp);
         }
      }
      
      public function isComplete(value:int) : void
      {
         if(value == 0)
         {
            this._getBtn.mouseEnabled = false;
            this._getBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._getBtn.visible = true;
            this._getBtnGlow.visible = false;
            this._getIcon.visible = false;
         }
         else if(value == 1)
         {
            this._getBtn.visible = false;
            this._getBtnGlow.visible = false;
            this._getIcon.visible = true;
         }
         else if(value == 2)
         {
            this._getBtn.mouseEnabled = true;
            this._getBtn.filters = null;
            this._getBtn.visible = true;
            this._getBtnGlow.visible = true;
            this._getIcon.visible = false;
         }
      }
      
      protected function creatItemCell($info:InventoryItemInfo) : GrowthPackageCell
      {
         var _cell:GrowthPackageCell = new GrowthPackageCell(0,null);
         _cell.width = 47;
         _cell.height = 46;
         _cell.info = $info;
         return _cell;
      }
      
      private function clearCells() : void
      {
         var cell:GrowthPackageCell = null;
         for(var i:int = 0; i < this._cellsArr.length; i++)
         {
            cell = GrowthPackageCell(this._cellsArr[i]);
            ObjectUtils.disposeObject(cell);
         }
         this._cellsArr = null;
         ObjectUtils.disposeAllChildren(this._cells);
         ObjectUtils.disposeObject(this._cells);
         this._cells = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearCells();
         ObjectUtils.disposeObject(this._levelHead);
         this._levelHead = null;
         ObjectUtils.disposeObject(this._cellsBg);
         this._cellsBg = null;
         ObjectUtils.disposeObject(this._getBtn);
         this._getBtn = null;
         if(Boolean(this._getBtnGlow))
         {
            this._getBtnGlow.stop();
            ObjectUtils.disposeObject(this._getBtnGlow);
            this._getBtnGlow = null;
         }
         ObjectUtils.disposeObject(this._getIcon);
         this._getIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

