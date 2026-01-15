package newChickenBox.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import newChickenBox.data.NewChickenBoxGoodsTempInfo;
   import newChickenBox.model.NewChickenBoxModel;
   
   public class NewChickenBoxView extends Sprite implements Disposeable
   {
      
      private static const NUM:int = 18;
      
      private var _model:NewChickenBoxModel;
      
      private var eyeItem:NewChickenBoxItem;
      
      private var frame:BaseAlerFrame;
      
      private var moveBackArr:Array;
      
      public function NewChickenBoxView()
      {
         super();
         this._model = NewChickenBoxModel.instance;
         this.init();
      }
      
      private function init() : void
      {
         this.moveBackArr = new Array();
         if(this._model.isShowAll)
         {
            this.getAllItem();
         }
         else
         {
            this.updataAllItem();
         }
      }
      
      public function getAllItem() : void
      {
         var stand:MovieClip = null;
         var move:MovieClip = null;
         var p:String = null;
         var iteminfo:NewChickenBoxGoodsTempInfo = null;
         var s:Sprite = null;
         var cell:NewChickenBoxCell = null;
         var bg:MovieClip = null;
         var item:NewChickenBoxItem = null;
         var num1:int = Math.random() * 18;
         var num2:int = this.getNum(num1);
         for(var i:int = 0; i < NUM; i++)
         {
            stand = ClassUtils.CreatInstance("asset.newChickenBox.chickenStand") as MovieClip;
            move = ClassUtils.CreatInstance("asset.newChickenBox.chickenMove") as MovieClip;
            p = "newChickenBox.itemPos" + i;
            iteminfo = this._model.templateIDList[i];
            s = new Sprite();
            s.graphics.beginFill(16777215,0);
            s.graphics.drawRect(0,0,39,39);
            s.graphics.endFill();
            cell = new NewChickenBoxCell(s,iteminfo.info);
            if(i == num1 || i == num2)
            {
               bg = move;
               this.moveBackArr.push(i);
            }
            else
            {
               bg = stand;
            }
            item = new NewChickenBoxItem(cell,bg);
            item.info = iteminfo;
            item.updateCount();
            item.addEventListener(MouseEvent.CLICK,this.tackoverCard);
            item.position = i;
            PositionUtils.setPos(item,p);
            if(this._model.itemList.length == 18)
            {
               this._model.itemList[i].dispose();
               this._model.itemList[i] = null;
               this._model.itemList[i] = item;
            }
            else
            {
               this._model.itemList.push(item);
            }
            addChild(item);
         }
      }
      
      private function openAlertFrame(item:NewChickenBoxItem) : BaseAlerFrame
      {
         var msg:String = LanguageMgr.GetTranslation("newChickenBox.EagleEye.msg",this._model.eagleEyePrice[this._model.countEye]);
         var select:SelectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.selectBnt2");
         select.text = LanguageMgr.GetTranslation("newChickenBox.noAlert");
         select.addEventListener(MouseEvent.CLICK,this.noAlertEable);
         if(Boolean(this.frame))
         {
            ObjectUtils.disposeObject(this.frame);
         }
         this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("newChickenBox.newChickenTitle"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2);
         this.frame.addChild(select);
         this.frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this.eyeItem = item;
         return this.frame;
      }
      
      private function noAlertEable(e:MouseEvent) : void
      {
         var select:SelectedCheckButton = e.currentTarget as SelectedCheckButton;
         if(select.selected)
         {
            this._model.alertEye = false;
         }
         else
         {
            this._model.alertEye = true;
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendChickenBoxUseEagleEye(this.eyeItem);
         }
      }
      
      private function openAlertFrame2(item:NewChickenBoxItem) : BaseAlerFrame
      {
         var msg:String = LanguageMgr.GetTranslation("newChickenBox.OpenCard.msg",this._model.openCardPrice[this._model.countTime]);
         var select:SelectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.selectBnt3");
         select.text = LanguageMgr.GetTranslation("newChickenBox.noAlert");
         select.addEventListener(MouseEvent.CLICK,this.noAlertEable2);
         if(Boolean(this.frame))
         {
            ObjectUtils.disposeObject(this.frame);
         }
         this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("newChickenBox.newChickenTitle"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2);
         this.frame.addChild(select);
         this.frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse2);
         this.eyeItem = item;
         return this.frame;
      }
      
      private function noAlertEable2(e:MouseEvent) : void
      {
         var select:SelectedCheckButton = e.currentTarget as SelectedCheckButton;
         if(select.selected)
         {
            this._model.alertOpenCard = false;
         }
         else
         {
            this._model.alertOpenCard = true;
         }
      }
      
      private function __onResponse2(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse2);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendChickenBoxTakeOverCard(this.eyeItem);
         }
      }
      
      public function getItemEvent(item:NewChickenBoxItem) : void
      {
         item.addEventListener(MouseEvent.CLICK,this.tackoverCard);
      }
      
      public function removeItemEvent(item:NewChickenBoxItem) : void
      {
         item.removeEventListener(MouseEvent.CLICK,this.tackoverCard);
         item.dispose();
      }
      
      public function tackoverCard(e:MouseEvent) : void
      {
         var moneyValue:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var item:NewChickenBoxItem = e.currentTarget as NewChickenBoxItem;
         var info:NewChickenBoxGoodsTempInfo = item.info;
         if(this._model.canclickEnable && !info.IsSelected && (!item.cell.visible || item.cell.alpha < 0.9))
         {
            if(this._model.clickEagleEye)
            {
               moneyValue = int(this._model.eagleEyePrice[this._model.countEye]);
               if(PlayerManager.Instance.Self.Money < moneyValue && this._model.freeEyeCount <= 0)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               if(info.IsSeeded)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.useEyeEnable"));
                  return;
               }
               if(this._model.alertEye && this._model.freeEyeCount <= 0)
               {
                  if(this._model.countEye < this._model.canEagleEyeCounts)
                  {
                     this._model.dispatchEvent(new Event("mouseShapoff"));
                     this.openAlertFrame(item);
                  }
                  else
                  {
                     SocketManager.Instance.out.sendChickenBoxUseEagleEye(item);
                  }
               }
               else
               {
                  SocketManager.Instance.out.sendChickenBoxUseEagleEye(item);
               }
            }
            else
            {
               moneyValue = int(this._model.openCardPrice[this._model.countTime]);
               if(PlayerManager.Instance.Self.Money < moneyValue && this._model.freeOpenCardCount <= 0)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               if(this._model.alertOpenCard && this._model.freeOpenCardCount <= 0)
               {
                  this.openAlertFrame2(item);
               }
               else
               {
                  SocketManager.Instance.out.sendChickenBoxTakeOverCard(item);
               }
            }
         }
      }
      
      private function getNum(num:int) : int
      {
         var num2:int = Math.random() * 18;
         if(num2 == num)
         {
            this.getNum(num);
         }
         return num2;
      }
      
      public function updataAllItem() : void
      {
         var p:String = null;
         var iteminfo:NewChickenBoxGoodsTempInfo = null;
         var s:Sprite = null;
         var tmpItemInfo:ItemTemplateInfo = null;
         var cell:NewChickenBoxCell = null;
         var bg:MovieClip = null;
         var item:NewChickenBoxItem = null;
         var num1:int = Math.random() * 18;
         var num2:int = this.getNum(num1);
         for(var i:int = 0; i < this._model.templateIDList.length; i++)
         {
            p = "newChickenBox.itemPos" + i;
            iteminfo = this._model.templateIDList[i];
            s = new Sprite();
            s.graphics.beginFill(16777215,0);
            s.graphics.drawRect(0,0,39,39);
            s.graphics.endFill();
            tmpItemInfo = iteminfo.IsSelected || iteminfo.IsSeeded ? iteminfo.info : null;
            cell = new NewChickenBoxCell(s,tmpItemInfo);
            if((i == num1 || i == num2) && iteminfo.IsSelected)
            {
               bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenMove") as MovieClip;
            }
            else if(iteminfo.IsSelected)
            {
               bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenStand") as MovieClip;
            }
            else if(iteminfo.IsSeeded)
            {
               bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenBack") as MovieClip;
               cell.visible = true;
               cell.alpha = 0.5;
            }
            else
            {
               bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenBack") as MovieClip;
               cell.visible = false;
            }
            item = new NewChickenBoxItem(cell,bg);
            item.info = iteminfo;
            item.updateCount();
            item.countTextShowIf();
            item.addEventListener(MouseEvent.CLICK,this.tackoverCard);
            item.position = i;
            PositionUtils.setPos(item,p);
            if(this._model.itemList.length == 18)
            {
               this._model.itemList[i].dispose();
               this._model.itemList[i] = null;
               this._model.itemList[i] = item;
            }
            else
            {
               this._model.itemList.push(item);
            }
            addChild(item);
         }
      }
      
      public function dispose() : void
      {
         var item:NewChickenBoxItem = null;
         if(Boolean(this.frame))
         {
            this.frame.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this.frame.dispose();
         }
         for(var i:int = 0; i < this._model.templateIDList.length; i++)
         {
            item = this._model.itemList[i] as NewChickenBoxItem;
            item.dispose();
            item = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

