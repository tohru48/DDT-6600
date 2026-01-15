package treasureLost.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TreasureLostFiveItemCell extends Sprite
   {
      
      public var id:int;
      
      public var isHave:Boolean;
      
      public var cell:BagCell;
      
      public var itemId:int;
      
      private var _isHave:Bitmap;
      
      public function TreasureLostFiveItemCell($id:int, $isHave:Boolean)
      {
         super();
         this.itemId = $id;
         this.isHave = $isHave;
         this.initView();
      }
      
      public function initView() : void
      {
         var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this.itemId);
         this.cell = new BagCell(0,info);
         this.cell.setBgVisible(false);
         this.cell.width = 57;
         this.cell.height = 57;
         this.cell.x = 2;
         this.cell.y = 0;
         addChild(this.cell);
         this._isHave = ComponentFactory.Instance.creat("treasureLost.isHaveBg");
         addChild(this._isHave);
         this._isHave.visible = false;
      }
      
      public function setEnable(enable:Boolean, canClick:Boolean = false) : void
      {
         if(enable)
         {
            this.cell.lightPic();
         }
         else
         {
            this.cell.grayPic();
         }
         if(canClick)
         {
            addEventListener(MouseEvent.CLICK,this.__itemClick);
         }
         else if(this.hasEventListener(MouseEvent.CLICK))
         {
            removeEventListener(MouseEvent.CLICK,this.__itemClick);
         }
         if(enable && canClick == false)
         {
            this._isHave.visible = true;
         }
      }
      
      private function __itemClick(e:MouseEvent) : void
      {
         SocketManager.Instance.out.treasureLostBuyItem(3);
      }
   }
}

