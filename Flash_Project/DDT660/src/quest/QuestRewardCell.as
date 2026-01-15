package quest
{
   import bagAndInfo.cell.CellFactory;
   import beadSystem.beadSystemManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class QuestRewardCell extends Sprite implements Disposeable
   {
      
      private const NAME_AREA_HEIGHT:int = 44;
      
      private var quantityTxt:FilterFrameText;
      
      private var nameTxt:FilterFrameText;
      
      private var bgStyle:MutipleImage;
      
      private var shine:Bitmap;
      
      private var item:ShopItemCell;
      
      private var _info:InventoryItemInfo;
      
      public function QuestRewardCell(isShowBg:Boolean = true)
      {
         super();
         if(isShowBg)
         {
            this.bgStyle = ComponentFactory.Instance.creatComponentByStylename("rewardCell.BGStyle1");
            addChild(this.bgStyle);
            this.shine = ComponentFactory.Instance.creat("asset.core.quest.QuestRewardCellBGShine");
            this.shine.visible = false;
            addChild(this.shine);
         }
         var sp:Sprite = new Sprite();
         sp.graphics.beginFill(16777215,0);
         sp.graphics.drawRect(0,0,43,43);
         sp.graphics.endFill();
         this.item = CellFactory.instance.createShopItemCell(sp,null,true,true) as ShopItemCell;
         this.item.cellSize = 40;
         this.item.x = -1;
         this.item.y = -1;
         addChild(this.item);
         this.quantityTxt = ComponentFactory.Instance.creat("BagCellCountText");
         this.quantityTxt.x = 38;
         this.quantityTxt.y = 29;
         addChild(this.quantityTxt);
         if(isShowBg)
         {
            this.nameTxt = ComponentFactory.Instance.creat("core.quest.QuestItemRewardName");
            addChild(this.nameTxt);
         }
         this.item.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.item.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
      }
      
      public function get _shine() : Bitmap
      {
         return this.shine;
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         TweenLite.to(this.item,0.25,{
            "x":-13,
            "y":-14,
            "scaleX":1.5,
            "scaleY":1.5,
            "ease":Quad.easeOut
         });
         TweenLite.to(this.quantityTxt,0.25,{
            "y":34,
            "alpha":0
         });
      }
      
      private function __outHandler(event:MouseEvent) : void
      {
         TweenLite.to(this.item,0.25,{
            "x":-1,
            "y":-1,
            "scaleX":1,
            "scaleY":1,
            "ease":Quad.easeOut
         });
         TweenLite.to(this.quantityTxt,0.25,{
            "y":29,
            "alpha":1
         });
      }
      
      public function set taskType(type:int) : void
      {
      }
      
      public function set opitional(value:Boolean) : void
      {
         if(this.bgStyle.visible)
         {
            this.bgStyle.setFrame(value ? 2 : 1);
         }
      }
      
      public function set info(info:InventoryItemInfo) : void
      {
         if(info == null)
         {
            return;
         }
         this.item.info = info;
         if(info.Count > 1)
         {
            this.quantityTxt.text = info.Count.toString();
         }
         else
         {
            this.quantityTxt.text = "";
         }
         this._info = info;
         if(EquipType.isBead(int(info.Property1)))
         {
            this.itemName = beadSystemManager.Instance.getBeadName(info);
         }
         else
         {
            this.itemName = info.Name;
         }
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._info;
      }
      
      public function __setItemName(e:Event) : void
      {
         if(EquipType.isBead(int(this.info.Property1)))
         {
            this.itemName = beadSystemManager.Instance.getBeadName(this.info);
         }
         else
         {
            this.itemName = this.info.Name;
         }
      }
      
      public function set itemName(name:String) : void
      {
         if(Boolean(this.nameTxt))
         {
            this.nameTxt.text = name;
            this.nameTxt.y = (this.NAME_AREA_HEIGHT - this.nameTxt.textHeight) / 2;
         }
      }
      
      public function set selected(value:Boolean) : void
      {
         if(!this.shine.visible && value)
         {
            SoundManager.instance.play("008");
         }
         this.shine.visible = value;
         TaskManager.itemAwardSelected = this.info.TemplateID;
      }
      
      public function initSelected() : void
      {
         this.shine.visible = true;
         TaskManager.itemAwardSelected = this.info.TemplateID;
      }
      
      public function get selected() : Boolean
      {
         return this.shine.visible;
      }
      
      public function canBeSelected() : void
      {
         this.buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.__selected);
      }
      
      private function __selected(evt:MouseEvent) : void
      {
         dispatchEvent(new RewardSelectedEvent(this));
      }
      
      public function dispose() : void
      {
         this._info = null;
         this.item.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.item.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         TweenLite.killTweensOf(this.item);
         removeEventListener(MouseEvent.CLICK,this.__selected);
         if(Boolean(this.quantityTxt))
         {
            ObjectUtils.disposeObject(this.quantityTxt);
         }
         this.quantityTxt = null;
         if(Boolean(this.nameTxt))
         {
            ObjectUtils.disposeObject(this.nameTxt);
         }
         this.nameTxt = null;
         if(Boolean(this.bgStyle))
         {
            ObjectUtils.disposeObject(this.bgStyle);
         }
         this.bgStyle = null;
         if(Boolean(this.shine))
         {
            ObjectUtils.disposeObject(this.shine);
         }
         this.shine = null;
         if(Boolean(this.item))
         {
            ObjectUtils.disposeObject(this.item);
         }
         this.item = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

