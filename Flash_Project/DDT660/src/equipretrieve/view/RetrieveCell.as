package equipretrieve.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import equipretrieve.RetrieveController;
   import equipretrieve.RetrieveModel;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import store.StoreCell;
   
   public class RetrieveCell extends StoreCell
   {
      
      public static const SHINE_XY:int = 1;
      
      public static const SHINE_SIZE:int = 96;
      
      private var bg:Sprite = new Sprite();
      
      private var bgBit:Bitmap = ComponentFactory.Instance.creatBitmap("equipretrieve.trieveCell0");
      
      private var _text:FilterFrameText;
      
      public function RetrieveCell($index:int)
      {
         PositionUtils.setPos(this.bgBit,"asset.equipretrieve.trieveCellPos");
         this._text = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.reworkname.Text");
         this._text.text = LanguageMgr.GetTranslation("tank.view.equipretrieve.text");
         this.bg.addChild(this.bgBit);
         this.bg.addChild(this._text);
         super(this.bg,$index);
         setContentSize(68,68);
         PicPos = new Point(10,9);
      }
      
      override public function startShine() : void
      {
         _shiner.x = SHINE_XY;
         _shiner.y = SHINE_XY;
         _shiner.width = _shiner.height = SHINE_SIZE;
         super.startShine();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(Boolean(_tbxCount))
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("equipretrieve.goodsCountText");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override protected function addEnchantMc() : void
      {
         _enchantMcName = "asset.enchant.equip.level";
         _enchantMcPosStr = "enchant.retrieve.equip.levelMcPos";
         super.addEnchantMc();
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         RetrieveController.Instance.shine = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var sourceInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(sourceInfo.BagType == BagInfo.STOREBAG && this.info != null)
         {
            return;
         }
         if(Boolean(sourceInfo) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,1);
            RetrieveModel.Instance.setSavePlaceType(sourceInfo,index);
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      override protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if(!DoubleClickEnabled)
         {
            return;
         }
         if(info == null)
         {
            return;
         }
         if((evt.currentTarget as BagCell).info != null)
         {
            if((evt.currentTarget as BagCell).info != null)
            {
               SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,index,RetrieveModel.Instance.getSaveCells(index).BagType,RetrieveModel.Instance.getSaveCells(index).Place);
               if(!mouseSilenced)
               {
                  SoundManager.instance.play("008");
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this.bgBit))
         {
            ObjectUtils.disposeObject(this.bgBit);
         }
         if(Boolean(this._text))
         {
            ObjectUtils.disposeObject(this._text);
         }
         if(Boolean(this.bg))
         {
            ObjectUtils.disposeObject(this.bg);
         }
         if(Boolean(_tbxCount))
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         this.bgBit = null;
         this.bg = null;
         _tbxCount = null;
         this._text = null;
      }
   }
}

