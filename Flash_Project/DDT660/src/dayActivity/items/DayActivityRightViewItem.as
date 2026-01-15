package dayActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.DayActivityManager;
   import dayActivity.data.DayRewaidData;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class DayActivityRightViewItem extends Sprite implements Disposeable
   {
      
      public var id:int;
      
      private var _back:ScaleBitmapImage;
      
      private var _txt1:FilterFrameText;
      
      private var _list:Vector.<BagCell>;
      
      private var _btn1:SimpleBitmapButton;
      
      private var _btn2:SimpleBitmapButton;
      
      private var _lightBitMap:MovieClip;
      
      public function DayActivityRightViewItem(num:int)
      {
         super();
         this.initView(num);
      }
      
      private function initView(num:int) : void
      {
         this._list = new Vector.<BagCell>();
         this._back = ComponentFactory.Instance.creatComponentByStylename("dayActivityView.right.itemBack");
         addChild(this._back);
         this._lightBitMap = ComponentFactory.Instance.creat("day.receiveLight");
         this._lightBitMap.x = 284;
         this._lightBitMap.y = 13;
         this._lightBitMap.visible = false;
         addChild(this._lightBitMap);
         this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activityView.right.itemTxt");
         this._txt1.text = LanguageMgr.GetTranslation("ddt.dayActivity.needActivity",num);
         addChild(this._txt1);
         this._btn1 = ComponentFactory.Instance.creatComponentByStylename("dayActivity.day.receiveBtn");
         this._btn1.addEventListener(MouseEvent.CLICK,this.clickHander);
         addChild(this._btn1);
         this._btn1.visible = false;
         this._btn2 = ComponentFactory.Instance.creatComponentByStylename("dayActivity.receiveOverBtn");
         this._btn2.visible = false;
         addChild(this._btn2);
         this.initGoods(DayActivityManager.Instance.reweadDataList,num);
      }
      
      private function clickHander(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGetGoods(this.id);
      }
      
      public function showBtn(bool:Boolean) : void
      {
         this._txt1.visible = false;
         this._btn2.visible = false;
         this._btn1.visible = false;
         this._lightBitMap.visible = false;
         if(bool)
         {
            this._btn2.visible = true;
            this._btn2.enable = false;
            this.applyGray(this);
         }
         else
         {
            this._btn1.visible = true;
            this._btn1.enable = true;
            this._lightBitMap.visible = true;
         }
      }
      
      private function applyGray(child:DisplayObject) : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.applyFilter(child,matrix);
      }
      
      private function applyFilter(child:DisplayObject, matrix:Array) : void
      {
         var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
         var filters:Array = new Array();
         filters.push(filter);
         child.filters = filters;
      }
      
      private function initGoods(list:Vector.<DayRewaidData>, num:int) : void
      {
         var i:int = 0;
         var cell:BagCell = null;
         var back:ScaleBitmapImage = null;
         var info:ItemTemplateInfo = null;
         if(!list)
         {
            return;
         }
         var len:int = int(list.length);
         var index:int = 0;
         for(i = 0; i < len; i++)
         {
            if(num == DayActivityManager.Instance.reweadDataList[i].RewardID)
            {
               cell = new BagCell(i);
               back = ComponentFactory.Instance.creat("dayActivityView.right.goodsBack");
               info = ItemManager.Instance.getTemplateById(DayActivityManager.Instance.reweadDataList[i].RewardItemID);
               cell.info = info;
               addChild(back);
               addChild(cell);
               back.x = (back.width + 4) * index + 10;
               back.y = this._back.height / 2 - back.height / 2;
               cell.x = back.x + 2.5;
               cell.y = back.y + 2.5;
               index++;
               cell.setCount(DayActivityManager.Instance.reweadDataList[i].RewardItemCount);
               this._list.push(cell);
            }
         }
      }
      
      public function dispose() : void
      {
         this._btn1.removeEventListener(MouseEvent.CLICK,this.clickHander);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._list = null;
      }
   }
}

