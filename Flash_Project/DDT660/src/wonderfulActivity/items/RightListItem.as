package wonderfulActivity.items
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import firstRecharge.FirstRechargeManger;
   import firstRecharge.info.RechargeData;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.data.ActivityTypeData;
   
   public class RightListItem extends Sprite implements Disposeable
   {
      
      private var _back:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _goodContent:Sprite;
      
      private var _btn:SimpleBitmapButton;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var _data:ActivityTypeData;
      
      public function RightListItem(type:int, data:ActivityTypeData)
      {
         super();
         this._data = data;
         this.init(type,data);
      }
      
      public function getItemID() : int
      {
         return this._data.ID;
      }
      
      private function init(type:int, data:ActivityTypeData) : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.listItem");
         addChild(this._back);
         if(type == 1)
         {
            this._back.gotoAndStop(1);
         }
         else
         {
            this._back.gotoAndStop(2);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.nameTxt");
         addChild(this._nameTxt);
         this._nameTxt.text = data.Description.replace(/\{\d+\}/,data.Condition);
         this._nameTxt.y = this._back.height / 2 - this._nameTxt.height / 2;
         this.initGoods(data);
      }
      
      public function getBtn() : SimpleBitmapButton
      {
         return this._btn;
      }
      
      public function initBtnState(type:int = 1, num:int = 0) : void
      {
         this.clearBtn();
         if(type == 0)
         {
            if(this._data.RegetType == 0)
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(this._btn);
               this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
               this._btn.addChild(this._btnTxt);
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._btn.addChild(this._tipsBtn);
            }
            else
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
               addChild(this._btn);
            }
            return;
         }
         if(this._data.RegetType == 0)
         {
            if(num == 0)
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
            }
            else
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.smallGetBtn");
            }
            this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
            this._btn.addChild(this._btnTxt);
            this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
            this._btn.addChild(this._tipsBtn);
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
         }
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.btnHandler);
      }
      
      public function setBtnTxt(num:int) : void
      {
         if(Boolean(this._btnTxt))
         {
            this._btnTxt.text = "(" + num + ")";
         }
      }
      
      private function btnHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendWonderfulActivity(1,this._data.ID);
      }
      
      private function initGoods(data:ActivityTypeData) : void
      {
         var i:int = 0;
         var cell:BagCell = null;
         var back:Bitmap = null;
         var info:InventoryItemInfo = null;
         this._goodContent = new Sprite();
         addChild(this._goodContent);
         var list:Vector.<RechargeData> = FirstRechargeManger.Instance.getGoodsList();
         var len:int = int(list.length);
         var index:int = 0;
         for(i = 0; i < len; i++)
         {
            if(data.ID == list[i].RewardID)
            {
               cell = new BagCell(0);
               back = ComponentFactory.Instance.creat("wonderfulactivity.goods.back");
               addChild(back);
               info = new InventoryItemInfo();
               info.TemplateID = list[i].RewardItemID;
               info = ItemManager.fill(info);
               info.IsBinds = list[i].IsBind;
               info.ValidDate = list[i].RewardItemValid;
               info._StrengthenLevel = list[i].StrengthenLevel;
               info.AttackCompose = list[i].AttackCompose;
               info.DefendCompose = list[i].DefendCompose;
               info.AgilityCompose = list[i].AgilityCompose;
               info.LuckCompose = list[i].LuckCompose;
               cell.info = info;
               cell.setBgVisible(false);
               cell.setCount(list[i].RewardItemCount);
               back.x = (back.width + 5) * index;
               cell.x = back.width / 2 - cell.width / 2 + back.x + 2;
               cell.y = back.height / 2 - cell.height / 2 + 1;
               this._goodContent.addChild(back);
               this._goodContent.addChild(cell);
               index++;
            }
         }
         this._goodContent.x = 142;
         this._goodContent.y = 11;
      }
      
      private function clearBtn() : void
      {
         if(!this._btn)
         {
            return;
         }
         while(Boolean(this._btn.numChildren))
         {
            ObjectUtils.disposeObject(this._btn.getChildAt(0));
         }
         this._btn = null;
      }
      
      public function dispose() : void
      {
         while(Boolean(this._goodContent.numChildren))
         {
            ObjectUtils.disposeObject(this._goodContent.getChildAt(0));
         }
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._goodContent = null;
         this._back = null;
         this._nameTxt = null;
         this._btn = null;
         this._btnTxt = null;
         this._tipsBtn = null;
      }
   }
}

