package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaApplyInfo;
   import consortion.event.ConsortionEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TakeInMemberFrame extends Frame
   {
      
      private var _bg:MovieImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _levelTxt:FilterFrameText;
      
      private var _powerTxt:FilterFrameText;
      
      private var _operateTxt:FilterFrameText;
      
      private var _level:TextButton;
      
      private var _power:TextButton;
      
      private var _selectAll:TextButton;
      
      private var _agree:TextButton;
      
      private var _refuse:TextButton;
      
      private var _setRefuse:SelectedCheckButton;
      
      private var _refuseImg:FilterFrameText;
      
      private var _takeIn:TextButton;
      
      private var _close:TextButton;
      
      private var _list:VBox;
      
      private var _lastSort:String;
      
      private var _items:Array;
      
      private var _turnPage:TakeInTurnPage;
      
      private var _itemBG:MutipleImage;
      
      private var _menberListVLine:MutipleImage;
      
      private var _powerBtn:Sprite;
      
      private var _levelBtn:Sprite;
      
      private var _pageCount:int = 8;
      
      public function TakeInMemberFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaAuditingApplyList.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("takeInMemberFrame.BG");
         this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInMemberListVLine");
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("takeInMemberItem.BG");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.nameTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("itemview.listname");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.levelTxt");
         this._levelTxt.text = LanguageMgr.GetTranslation("itemview.listlevel");
         this._powerTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.powerTxt");
         this._powerTxt.text = LanguageMgr.GetTranslation("itemview.listfightpower");
         this._operateTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.operateTxt");
         this._operateTxt.text = LanguageMgr.GetTranslation("operate");
         this._selectAll = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.selectAllBtn");
         this._selectAll.text = LanguageMgr.GetTranslation("consortion.takeIn.selectAllBtn.text");
         this._agree = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.agreeBtn");
         this._agree.text = LanguageMgr.GetTranslation("consortion.takeIn.agreeBtn.text");
         this._refuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.refuseBtn");
         this._refuse.text = LanguageMgr.GetTranslation("consortion.takeIn.refuseBtn.text");
         this._setRefuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.setRefuse");
         this._refuseImg = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.setRefuseText");
         this._refuseImg.text = LanguageMgr.GetTranslation("consortion.takeIn.setRefuseText.text");
         this._takeIn = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.takeIn");
         this._close = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.close");
         this._list = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.list");
         this._turnPage = ComponentFactory.Instance.creatCustomObject("takeInTurnPage");
         this._levelBtn = new Sprite();
         this._levelBtn.graphics.beginFill(16777215,1);
         this._levelBtn.graphics.drawRect(0,0,65,30);
         this._levelBtn.graphics.endFill();
         this._levelBtn.alpha = 0;
         this._levelBtn.buttonMode = true;
         this._levelBtn.mouseEnabled = true;
         this._levelBtn.x = 165;
         this._powerBtn = new Sprite();
         this._powerBtn.graphics.beginFill(16777215,1);
         this._powerBtn.graphics.drawRect(0,0,80,30);
         this._powerBtn.graphics.endFill();
         this._powerBtn.alpha = 0;
         this._powerBtn.buttonMode = true;
         this._powerBtn.mouseEnabled = true;
         this._powerBtn.x = 232;
         this._levelBtn.y = 45;
         this._powerBtn.y = 45;
         addToContent(this._bg);
         addToContent(this._menberListVLine);
         addToContent(this._itemBG);
         addToContent(this._nameTxt);
         addToContent(this._levelTxt);
         addToContent(this._powerTxt);
         addToContent(this._operateTxt);
         addToContent(this._selectAll);
         addToContent(this._agree);
         addToContent(this._refuse);
         addToContent(this._setRefuse);
         this._setRefuse.addChild(this._refuseImg);
         addToContent(this._takeIn);
         addToContent(this._close);
         addToContent(this._list);
         addToContent(this._turnPage);
         addToContent(this._levelBtn);
         addToContent(this._powerBtn);
         this._takeIn.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaAuditingApplyList.okLabel");
         this._close.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         this._setRefuse.visible = PlayerManager.Instance.Self.consortiaInfo.ChairmanID == PlayerManager.Instance.Self.ID ? true : false;
         this._setRefuse.selected = !PlayerManager.Instance.Self.consortiaInfo.OpenApply;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._levelBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._powerBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._selectAll.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._agree.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._refuse.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._setRefuse.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._takeIn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._close.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._turnPage.addEventListener(TakeInTurnPage.PAGE_CHANGE,this.__pageChangeHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__refishListHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,this.__consortiaApplyStatusResult);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._levelBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._powerBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._selectAll.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._agree.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._refuse.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._setRefuse.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._takeIn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._close.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._turnPage.removeEventListener(TakeInTurnPage.PAGE_CHANGE,this.__pageChangeHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__refishListHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,this.__consortiaApplyStatusResult);
      }
      
      private function __pageChangeHandler(event:Event) : void
      {
         this.setList(ConsortionModelControl.Instance.model.getapplyListWithPage(this._turnPage.present,this._pageCount));
      }
      
      private function __consortiaApplyStatusResult(evt:CrazyTankSocketEvent) : void
      {
         var status:Boolean = evt.pkg.readBoolean();
         var isSuccess:Boolean = evt.pkg.readBoolean();
         var msg:String = evt.pkg.readUTF();
         MessageTipManager.getInstance().show(msg);
         this._setRefuse.selected = Boolean(!status);
         PlayerManager.Instance.Self.consortiaInfo.OpenApply = Boolean(status);
      }
      
      private function __refishListHandler(event:ConsortionEvent) : void
      {
         this._lastSort = "";
         this._turnPage.sum = Math.ceil(ConsortionModelControl.Instance.model.myApplyList.length / this._pageCount);
         this.setList(ConsortionModelControl.Instance.model.getapplyListWithPage(this._turnPage.present,this._pageCount));
      }
      
      private function clearList() : void
      {
         var i:int = 0;
         this._list.disposeAllChildren();
         if(Boolean(this._items))
         {
            for(i = 0; i < this._items.length; i++)
            {
               this._items[i] = null;
            }
            this._items = null;
         }
         this._items = new Array();
      }
      
      private function setList(value:Vector.<ConsortiaApplyInfo>) : void
      {
         var item:TakeInMemberItem = null;
         this.clearList();
         var len:int = int(value.length);
         for(var i:int = 0; i < len; i++)
         {
            item = new TakeInMemberItem();
            item.info = value[i];
            this._list.addChild(item);
            this._items.push(item);
         }
         if(this._lastSort != "")
         {
            this.sort(this._lastSort);
         }
      }
      
      private function sort(field:String) : void
      {
         var item:TakeInMemberItem = null;
         var item2:TakeInMemberItem = null;
         for(var i:int = 0; i < this._items.length; i++)
         {
            item = this._items[i] as TakeInMemberItem;
            this._list.removeChild(item);
         }
         this._items.sortOn(field,Array.DESCENDING | Array.NUMERIC);
         for(var j:int = 0; j < this._items.length; j++)
         {
            item2 = this._items[j] as TakeInMemberItem;
            this._list.addChild(item2);
         }
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         var wantTakeIn:WantTakeInFrame = null;
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._levelBtn:
               this._lastSort = "Level";
               this.sort(this._lastSort);
               break;
            case this._powerBtn:
               this._lastSort = "FightPower";
               this.sort(this._lastSort);
               break;
            case this._selectAll:
               this.selectAll();
               break;
            case this._agree:
               this.agree();
               break;
            case this._refuse:
               this.refuse();
               break;
            case this._setRefuse:
               SocketManager.Instance.out.sendConsoritaApplyStatusOut(!this._setRefuse.selected);
               break;
            case this._takeIn:
               wantTakeIn = ComponentFactory.Instance.creatComponentByStylename("wantTakeInFrame");
               LayerManager.Instance.addToLayer(wantTakeIn,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._close:
               this.dispose();
         }
      }
      
      private function selectAll() : void
      {
         var i:int = 0;
         var j:int = 0;
         if(this.allHasSelected())
         {
            for(i = 0; i < this._items.length; i++)
            {
               if(this._items[i])
               {
                  (this._items[i] as TakeInMemberItem).selected = false;
               }
            }
         }
         else
         {
            for(j = 0; j < this._items.length; j++)
            {
               if(this._items[j])
               {
                  (this._items[j] as TakeInMemberItem).selected = true;
               }
            }
         }
      }
      
      private function allHasSelected() : Boolean
      {
         for(var i:uint = 0; i < this._items.length; i++)
         {
            if(!(this._items[i] as TakeInMemberItem).selected)
            {
               return false;
            }
         }
         return true;
      }
      
      private function agree() : void
      {
         var item:TakeInMemberItem = null;
         var noChoice:Boolean = true;
         for(var i:int = 0; i < this._items.length; i++)
         {
            item = this._items[i] as TakeInMemberItem;
            if(item)
            {
               if(item.selected)
               {
                  SocketManager.Instance.out.sendConsortiaTryinPass(item.info.ID);
                  noChoice = false;
               }
            }
         }
         if(noChoice)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
         }
      }
      
      private function refuse() : void
      {
         var item:TakeInMemberItem = null;
         var noChoice:Boolean = true;
         for(var i:int = 0; i < this._items.length; i++)
         {
            item = this._items[i] as TakeInMemberItem;
            if(item)
            {
               if((this._items[i] as TakeInMemberItem).selected)
               {
                  SocketManager.Instance.out.sendConsortiaTryinDelete(item.info.ID);
                  noChoice = false;
               }
            }
         }
         if(noChoice)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         super.dispose();
         this._bg = null;
         this._menberListVLine = null;
         this._itemBG = null;
         this._nameTxt = null;
         this._levelTxt = null;
         this._powerTxt = null;
         this._operateTxt = null;
         this._levelBtn = null;
         this._powerBtn = null;
         this._selectAll = null;
         this._agree = null;
         this._refuse = null;
         this._setRefuse = null;
         this._takeIn = null;
         this._close = null;
         this._list = null;
         this._refuseImg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

