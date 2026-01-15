package email.view
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.bag.BagFrame;
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import ddt.view.FriendDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import email.data.EmailInfo;
   import email.data.EmailState;
   import email.manager.MailManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class WritingView extends Frame implements IAcceptDrag
   {
      
      private var _bag:Frame;
      
      private var _selectInfo:EmailInfo;
      
      private var isChargeMail:Boolean = false;
      
      private var _hours:uint;
      
      private var _titleIsManMade:Boolean = false;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _writingViewBG:MovieClip;
      
      private var _receiver:FriendDropListTarget;
      
      private var _senderTip:FilterFrameText;
      
      private var _topicTip:FilterFrameText;
      
      private var _dropList:DropList;
      
      private var _topic:TextInput;
      
      private var _content:TextArea;
      
      private var _friendsBtn:TextButton;
      
      private var _houerBtnGroup:SelectedButtonGroup;
      
      private var _oneHouerBtn:SelectedCheckButton;
      
      private var _sixHouerBtn:SelectedCheckButton;
      
      private var _payForBtn:SelectedCheckButton;
      
      private var _moneyInput:TextInput;
      
      private var _sendBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var bagContent:BagFrame;
      
      private var _type:int;
      
      private var _diamonds:DiamondOfWriting;
      
      private var _payTipTxt1:FilterFrameText;
      
      private var _payTipTxt2:FilterFrameText;
      
      private var _lowestPrice:Number;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _currentHourBtn:SelectedButton;
      
      public function WritingView()
      {
         super();
         this.initView();
         this.addEvent();
         BagAndInfoManager.Instance.hideBagAndInfo();
      }
      
      private function initView() : void
      {
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.view.emailII.writingView.titleTxt");
         var bg:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("email.writeBG1");
         addToContent(bg);
         this._writingViewBG = ClassUtils.CreatInstance("asset.email.writeViewBg");
         PositionUtils.setPos(this._writingViewBG,"writingView.BGPos");
         addToContent(this._writingViewBG);
         var xuLine:Image = ComponentFactory.Instance.creatComponentByStylename("email.writeLine");
         addToContent(xuLine);
         this._senderTip = ComponentFactory.Instance.creatComponentByStylename("email.geterTipTxt");
         this._senderTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.geterTip");
         addToContent(this._senderTip);
         this._topicTip = ComponentFactory.Instance.creatComponentByStylename("email.topicTipTxtII");
         this._topicTip.text = LanguageMgr.GetTranslation("tank.view.emailII.readView.topicTip");
         addToContent(this._topicTip);
         this._receiver = ComponentFactory.Instance.creat("email.receiverInput");
         addToContent(this._receiver);
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._receiver;
         this._dropList.x = this._receiver.x;
         this._dropList.y = this._receiver.y + this._receiver.height;
         this._topic = ComponentFactory.Instance.creat("email.writeTopicInput");
         this._topic.textField.maxChars = 16;
         addToContent(this._topic);
         this._content = ComponentFactory.Instance.creatComponentByStylename("email.writeContent");
         this._content.textField.maxChars = 200;
         addToContent(this._content);
         this._friendsBtn = ComponentFactory.Instance.creat("email.friendsBtn");
         this._friendsBtn.text = LanguageMgr.GetTranslation("tank.view.emailII.writingView.friendlist");
         addToContent(this._friendsBtn);
         var bg1:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("email.writeBG3");
         addToContent(bg1);
         this._houerBtnGroup = new SelectedButtonGroup();
         this._oneHouerBtn = ComponentFactory.Instance.creatComponentByStylename("email.oneHouerBtn");
         this._oneHouerBtn.text = LanguageMgr.GetTranslation("tank.view.emailII.writingView.onehour");
         this.setTip(this._oneHouerBtn,LanguageMgr.GetTranslation("tank.view.emailII.WritingView.backTime"));
         addToContent(this._oneHouerBtn);
         this._houerBtnGroup.addSelectItem(this._oneHouerBtn);
         this._oneHouerBtn.enable = false;
         this._sixHouerBtn = ComponentFactory.Instance.creatComponentByStylename("email.sixHouerBtn");
         this._sixHouerBtn.text = LanguageMgr.GetTranslation("tank.view.emailII.writingView.sixhour");
         this.setTip(this._sixHouerBtn,LanguageMgr.GetTranslation("tank.view.emailII.WritingView.backTime2"));
         addToContent(this._sixHouerBtn);
         this._houerBtnGroup.addSelectItem(this._sixHouerBtn);
         this._sixHouerBtn.enable = false;
         this._payForBtn = ComponentFactory.Instance.creatComponentByStylename("email.payForBtn");
         addToContent(this._payForBtn);
         this._payForBtn.enable = false;
         this._payTipTxt1 = ComponentFactory.Instance.creatComponentByStylename("email.moneyInputTip1");
         this._payTipTxt1.text = LanguageMgr.GetTranslation("tank.view.emailII.writingView.paytip1");
         addToContent(this._payTipTxt1);
         this._payTipTxt2 = ComponentFactory.Instance.creatComponentByStylename("email.moneyInputTip2");
         this._payTipTxt2.text = LanguageMgr.GetTranslation("tank.view.emailII.writingView.paytip2");
         addToContent(this._payTipTxt2);
         this._moneyInput = ComponentFactory.Instance.creat("email.moneyInput");
         this._moneyInput.beginChanges();
         this._moneyInput.text = "";
         this._moneyInput.textField.restrict = "0-9";
         this._moneyInput.textField.maxChars = 9;
         this._moneyInput.visible = true;
         this._moneyInput.commitChanges();
         addToContent(this._moneyInput);
         this._sendBtn = ComponentFactory.Instance.creat("email.sendBtn");
         this._sendBtn.text = LanguageMgr.GetTranslation("send");
         addToContent(this._sendBtn);
         this._cancelBtn = ComponentFactory.Instance.creat("email.cancelBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         addToContent(this._cancelBtn);
         var diamondTipImg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.email.diamondTipImg");
         addToContent(diamondTipImg);
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName);
         this._bag = ComponentFactory.Instance.creat("email.emialBagFrame");
         this._bag.titleText = LanguageMgr.GetTranslation("tank.view.emailII.BagFrame.selectBag");
         addToContent(this._bag);
         this.bagContent = ComponentFactory.Instance.creat("email.bagContent");
         this.bagContent.emailBagView.setBagType(BagView.PROP);
         this.bagContent.emailBagView.itemtabBtn = 2;
         this.bagContent.emailBagView.tableEnable = false;
         this.bagContent.emailBagView.isNeedCard(false);
         this.bagContent.emailBagView.cardbtnVible = false;
         this.bagContent.emailBagView.tableEnable = true;
         this.bagContent.emailBagView.initBeadButton();
         this.bagContent.emailBagView.switchButtomVisible(true);
         this.bagContent.emailBagView.cellDoubleClickEnable = false;
         this._bag.addToContent(this.bagContent);
         this.bagContent.graySortBtn();
         this.bagContent.emailBagView.sortBagEnable = false;
         this.bagContent.emailBagView.breakBtnEnable = false;
         this.bagContent.emailBagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         this.bagContent.emailBagView._bagLockBtn.y = -2;
         this._diamonds = new DiamondOfWriting();
         addToContent(this._diamonds);
         PositionUtils.setPos(this._diamonds,"writingView.diaPos");
      }
      
      private function setTip(btn:SelectedCheckButton, data:String) : void
      {
         btn.tipStyle = "ddt.view.tips.OneLineTip";
         btn.tipDirctions = "0";
         btn.tipData = data;
         btn.tipGapV = 5;
      }
      
      private function addEvent() : void
      {
         this._receiver.addEventListener(Event.CHANGE,this.__onReceiverChange);
         this._receiver.addEventListener(FocusEvent.FOCUS_IN,this.__onReceiverChange);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideDropList);
         this._content.textField.addEventListener(Event.CHANGE,this.__sound);
         this._content.textField.addEventListener(TextEvent.TEXT_INPUT,this.__taInput);
         this._friendsBtn.addEventListener(MouseEvent.CLICK,this.__friendListView);
         this._oneHouerBtn.addEventListener(MouseEvent.CLICK,this.__selectHourListener);
         this._sixHouerBtn.addEventListener(MouseEvent.CLICK,this.__selectHourListener);
         this._payForBtn.addEventListener(MouseEvent.CLICK,this.__selectMoneyType);
         this._moneyInput.textField.addEventListener(Event.CHANGE,this.__moneyChange);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.__send);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__close);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEND_EMAIL,this.__sendEmailBack);
         addEventListener(KeyboardEvent.KEY_DOWN,this.__StopEnter);
         addEventListener(Event.ADDED_TO_STAGE,this.addToStageListener);
         addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         this._diamonds.addEventListener(EmailEvent.SHOW_BAGFRAME,this.__showBag);
         this._diamonds.addEventListener(EmailEvent.HIDE_BAGFRAME,this.__hideBag);
         this._diamonds.addEventListener(EmailEvent.DRAGIN_ANNIEX,this.__doDragIn);
         this._diamonds.addEventListener(EmailEvent.DRAGOUT_ANNIEX,this.__doDragOut);
         this.bagContent.emailBagView.addEventListener(BagView.TABCHANGE,this.__onBagTabChanged);
      }
      
      protected function __onBagTabChanged(event:Event) : void
      {
         if(this.bagContent.emailBagView.bagType == BagAndGiftFrame.BEADVIEW)
         {
            this.bagContent.emailBagView.switchButtomVisible(false);
            this.bagContent.emailBagView.enableBeadFunctionBtns(false);
         }
         else
         {
            this.bagContent.emailBagView.switchButtomVisible(true);
         }
      }
      
      private function __hideDropList(event:MouseEvent) : void
      {
         if(event.target is FriendDropListTarget)
         {
            return;
         }
         if(Boolean(this._dropList) && Boolean(this._dropList.parent))
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      private function __onReceiverChange(event:Event) : void
      {
         if(this._receiver.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var list:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterRepeatInArray(this.filterSearch(list,this._receiver.text));
      }
      
      private function filterRepeatInArray(filterArr:Array) : Array
      {
         var j:int = 0;
         var arr:Array = new Array();
         for(var i:int = 0; i < filterArr.length; i++)
         {
            if(i == 0)
            {
               arr.push(filterArr[i]);
            }
            for(j = 0; j < arr.length; j++)
            {
               if(arr[j].NickName == filterArr[i].NickName)
               {
                  break;
               }
               if(j == arr.length - 1)
               {
                  arr.push(filterArr[i]);
               }
            }
         }
         return arr;
      }
      
      private function filterSearch(list:Array, targetStr:String) : Array
      {
         var result:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            if(list[i].NickName.indexOf(targetStr) != -1)
            {
               result.push(list[i]);
            }
         }
         return result;
      }
      
      private function removeEvent() : void
      {
         this._friendsBtn.removeEventListener(MouseEvent.CLICK,this.__friendListView);
         this._oneHouerBtn.removeEventListener(MouseEvent.CLICK,this.__selectHourListener);
         this._sixHouerBtn.removeEventListener(MouseEvent.CLICK,this.__selectHourListener);
         this._payForBtn.removeEventListener(MouseEvent.CLICK,this.__selectMoneyType);
         this._moneyInput.textField.removeEventListener(Event.CHANGE,this.__moneyChange);
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.__send);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__close);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SEND_EMAIL,this.__sendEmailBack);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__StopEnter);
         removeEventListener(Event.ADDED_TO_STAGE,this.addToStageListener);
         removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
         this._diamonds.removeEventListener(EmailEvent.SHOW_BAGFRAME,this.__showBag);
         this._diamonds.removeEventListener(EmailEvent.HIDE_BAGFRAME,this.__hideBag);
         this._diamonds.removeEventListener(EmailEvent.DRAGIN_ANNIEX,this.__doDragIn);
         this._diamonds.removeEventListener(EmailEvent.DRAGOUT_ANNIEX,this.__doDragOut);
         this.bagContent.emailBagView.removeEventListener(BagView.TABCHANGE,this.__onBagTabChanged);
      }
      
      public function set selectInfo(value:EmailInfo) : void
      {
         this._selectInfo = value;
      }
      
      public function isHasWrite() : Boolean
      {
         if(!StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._receiver.text)))
         {
            return true;
         }
         if(!StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._topic.text)))
         {
            return true;
         }
         if(!StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._content.text)))
         {
            return true;
         }
         if(Boolean(this._diamonds.annex))
         {
            return true;
         }
         return false;
      }
      
      private function selectName(nick:String, id:int = 0) : void
      {
         this._receiver.text = nick;
         this._friendList.setVisible = false;
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         effect.action = DragEffect.MOVE;
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(Boolean(info) && effect.action != DragEffect.SPLIT)
         {
            if(this._diamonds.annex == null)
            {
               this._diamonds.dragDrop(effect);
               if(Boolean(effect.target))
               {
                  return;
               }
            }
            effect.action = DragEffect.NONE;
         }
      }
      
      public function reset() : void
      {
         this._receiver.text = "";
         this._topic.text = "";
         this._content.text = "";
         this._moneyInput.text = "";
         this._diamonds.annex = null;
         this._payForBtn.enable = false;
         this._oneHouerBtn.enable = false;
         this._sixHouerBtn.enable = false;
         this._currentHourBtn = null;
         this._hours = 1;
         this.setDiamondMoneyType();
      }
      
      private function btnSound() : void
      {
         SoundManager.instance.play("043");
      }
      
      private function getFirstDiamond() : DiamondOfWriting
      {
         if(Boolean(this._diamonds.annex))
         {
            return this._diamonds;
         }
         return null;
      }
      
      public function closeWin() : void
      {
         if(this.isHasWrite())
         {
            if(this._confirmFrame == null)
            {
               this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.tip"),LanguageMgr.GetTranslation("tank.view.emailII.WritingView.isEdit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            }
         }
         else if(this._type == 0)
         {
            this.okCancel();
            dispatchEvent(new EmailEvent(EmailEvent.CLOSE_WRITING_FRAME));
         }
      }
      
      public function okCancel() : void
      {
         this.btnSound();
         this.reset();
         this._diamonds.setBagUnlock();
         if(Boolean(this._friendList) && Boolean(this._friendList.parent))
         {
            this._friendList.setVisible = false;
         }
         this._bag.visible = false;
         MailManager.Instance.changeState(EmailState.READ);
      }
      
      private function payEnable(b:Boolean) : void
      {
         this._topic.enable = !b;
         this._payForBtn.mouseChildren = this._payForBtn.mouseEnabled = this._payForBtn.buttonMode = this._payForBtn.enable = this._payForBtn.selected = b;
         this._moneyInput.enable = b;
         this._moneyInput.text = "";
         this.isChargeMail = this._payForBtn.selected;
      }
      
      private function atLeastOneDiamond() : Boolean
      {
         if(Boolean(this._diamonds.annex))
         {
            return true;
         }
         return false;
      }
      
      private function setDiamondMoneyType() : void
      {
         this._diamonds.chargedImg.visible = false;
         this._diamonds.centerMC.visible = true;
         if(Boolean(this._diamonds.annex) && this.isChargeMail)
         {
            this._diamonds.centerMC.visible = false;
            this._diamonds.chargedImg.visible = true;
            this._lowestPrice = this._diamonds.annex.FloorPrice * this._diamonds._cell.goodsCount;
            this._moneyInput.text = this._lowestPrice + "";
         }
         else if(Boolean(this._diamonds.annex) && !this.isChargeMail)
         {
            this._diamonds.centerMC.visible = false;
         }
         else
         {
            this._diamonds.centerMC.setFrame(1);
         }
         this.switchHourBtnState(this.isChargeMail);
      }
      
      private function switchHourBtnState(isChargeMail:Boolean) : void
      {
         this._oneHouerBtn.selected = false;
         this._sixHouerBtn.selected = false;
         this._oneHouerBtn.enable = isChargeMail;
         this._sixHouerBtn.enable = isChargeMail;
         if(isChargeMail)
         {
            this._currentHourBtn = this._oneHouerBtn;
            this._currentHourBtn.selected = true;
         }
      }
      
      private function __selectHourListener(e:MouseEvent) : void
      {
         this.btnSound();
         if(Boolean(this._currentHourBtn))
         {
            this._currentHourBtn.selected = false;
         }
         this._currentHourBtn = e.currentTarget as SelectedButton;
         this._currentHourBtn.selected = true;
         if(this._currentHourBtn == this._oneHouerBtn)
         {
            this._hours = 1;
         }
         else
         {
            this._hours = 6;
         }
      }
      
      private function __selectMoneyType(e:MouseEvent) : void
      {
         this.isChargeMail = this._payForBtn.selected;
         if(this.isChargeMail)
         {
            this._moneyInput.enable = true;
         }
         else
         {
            this._moneyInput.enable = false;
         }
         this.btnSound();
         this._topic.enable = !this._payForBtn.selected;
         this._moneyInput.text = "";
         if(this._payForBtn.selected)
         {
            this._moneyInput.setFocus();
            this._payForBtn.mouseChildren = this._payForBtn.mouseEnabled = this._payForBtn.buttonMode = true;
         }
         this.setDiamondMoneyType();
      }
      
      private function __moneyChange(e:Event) : void
      {
         if(this._moneyInput.text.charAt(0) == "0")
         {
            this._moneyInput.text = "";
         }
         e.preventDefault();
      }
      
      private function __send(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         var param:Object = null;
         var annexArr:Array = null;
         var diamond:DiamondOfWriting = null;
         var tempDiamond:InventoryItemInfo = null;
         this.btnSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(FilterWordManager.IsNullorEmpty(this._receiver.text))
         {
            this._receiver.text = "";
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.sender"));
         }
         else if(this._receiver.text == PlayerManager.Instance.Self.NickName)
         {
            this._receiver.text = "";
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.NickName"));
         }
         else if(FilterWordManager.IsNullorEmpty(this._topic.text) && !this.getFirstDiamond())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.topic"));
         }
         else if(PlayerManager.Instance.Self.Gold < 100)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         }
         else if(this._content.text.length > 200)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.contentLength"));
         }
         else
         {
            if(this.isChargeMail && !Number(this._moneyInput.text))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.money_txt"));
               return;
            }
            if(this.isChargeMail && !this.atLeastOneDiamond())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.annex"));
               return;
            }
            if(this.isChargeMail && (Number(this._moneyInput.text) < this._lowestPrice || Number(this._moneyInput.text) <= 0))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.Lowest",String(this._lowestPrice)));
               return;
            }
            if(!this.isChargeMail && int(this._moneyInput.text) > PlayerManager.Instance.Self.Money)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            param = new Object();
            param.NickName = this._receiver.text;
            if(FilterWordManager.IsNullorEmpty(this._topic.text))
            {
               this._topic.text = this.getFirstDiamond().annex.Name;
            }
            param.Title = FilterWordManager.filterWrod(this._topic.text);
            param.Content = FilterWordManager.filterWrod(this._content.text);
            param.SendedMoney = Number(this._moneyInput.text);
            param.isPay = this.isChargeMail;
            if(this.isChargeMail)
            {
               param.hours = this._hours;
               diamond = this.getFirstDiamond();
               param.Title = diamond.annex.Name;
            }
            else
            {
               param.SendedMoney = 0;
            }
            annexArr = [];
            if(Boolean(this._diamonds.annex))
            {
               tempDiamond = this._diamonds.annex as InventoryItemInfo;
               annexArr.push(tempDiamond);
               param["Annex0"] = tempDiamond.BagType.toString() + "," + tempDiamond.Place.toString();
            }
            param.Count = this._diamonds._cell.goodsCount;
            MailManager.Instance.sendEmail(param);
            MailManager.Instance.onSendAnnex(annexArr);
            this._sendBtn.enable = false;
         }
      }
      
      private function __quickBuyResponse(evt:FrameEvent) : void
      {
         var quickBuy:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         frame.dispose();
         if(Boolean(frame.parent))
         {
            frame.parent.removeChild(frame);
         }
         frame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            quickBuy = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            quickBuy.itemID = EquipType.GOLD_BOX;
            quickBuy.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(quickBuy,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __friendListView(event:MouseEvent) : void
      {
         this.btnSound();
         var pos:Point = this._friendsBtn.localToGlobal(new Point(0,0));
         this._friendList.x = pos.x + this._friendsBtn.width;
         this._friendList.y = pos.y;
         this._friendList.setVisible = true;
      }
      
      private function __taInput(event:TextEvent) : void
      {
         if(this._content.text.length > 300)
         {
            event.preventDefault();
         }
      }
      
      private function __sendEmailBack(e:CrazyTankSocketEvent) : void
      {
         this._sendBtn.enable = true;
      }
      
      private function __StopEnter(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.ENTER)
         {
            e.stopImmediatePropagation();
         }
         else if(e.keyCode == Keyboard.ESCAPE)
         {
            e.stopImmediatePropagation();
            SoundManager.instance.play("008");
            this.closeWin();
         }
      }
      
      private function addToStageListener(event:Event) : void
      {
         this.reset();
         this._receiver.text = Boolean(this._selectInfo) ? this._selectInfo.Sender : "";
         this._topic.text = "";
         this._content.text = "";
         this._moneyInput.text = "";
         this._moneyInput.enable = false;
         this._bag.visible = true;
         if(Boolean(stage))
         {
            stage.focus = this;
         }
         this._diamonds.annex = null;
      }
      
      private function __showBag(event:EmailEvent) : void
      {
         var diamond:DiamondOfWriting = event.target as DiamondOfWriting;
         if(diamond.annex == null || this._bag.parent == null)
         {
            this._bag.visible = true;
         }
      }
      
      private function __hideBag(event:EmailEvent) : void
      {
         this._bag.visible = false;
      }
      
      private function __doDragIn(e:EmailEvent) : void
      {
         var diamond:DiamondOfWriting = null;
         this._payForBtn.mouseChildren = this._payForBtn.mouseEnabled = this._payForBtn.buttonMode = this._payForBtn.enable = true;
         if(this._topic.text == "" || !this._titleIsManMade)
         {
            diamond = this.getFirstDiamond();
            if(Boolean(diamond))
            {
               this._topic.text = diamond.annex.Name;
               this._titleIsManMade = false;
            }
            else
            {
               this._topic.text = "";
               this._titleIsManMade = false;
            }
         }
         this.setDiamondMoneyType();
      }
      
      private function __doDragOut(e:EmailEvent) : void
      {
         if(this.atLeastOneDiamond())
         {
            this._payForBtn.enable = true;
         }
         else
         {
            this.payEnable(false);
            this._topic.text = "";
         }
         this.setDiamondMoneyType();
      }
      
      private function __sound(event:Event) : void
      {
         this._titleIsManMade = true;
      }
      
      private function __frameClose(event:FrameEvent) : void
      {
         this.btnSound();
         this.closeWin();
      }
      
      private function __close(event:MouseEvent) : void
      {
         this.btnSound();
         this.closeWin();
      }
      
      private function __confirmResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         this._confirmFrame.dispose();
         this._confirmFrame = null;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this._type == 0)
            {
               this.okCancel();
            }
            dispatchEvent(new EmailEvent(EmailEvent.CLOSE_WRITING_FRAME));
         }
      }
      
      public function set type(value:int) : void
      {
         this._type = value;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function setName(value:String) : void
      {
         this._receiver.text = value;
      }
      
      override public function dispose() : void
      {
         this._diamonds.setBagUnlock();
         this.removeEvent();
         if(Boolean(this._bag))
         {
            ObjectUtils.disposeObject(this._bag);
         }
         this._bag = null;
         if(Boolean(this.bagContent))
         {
            this.bagContent.dispose();
         }
         this.bagContent = null;
         ObjectUtils.disposeObject(this._payTipTxt1);
         this._payTipTxt1 = null;
         ObjectUtils.disposeObject(this._payTipTxt2);
         this._payTipTxt2 = null;
         ObjectUtils.disposeObject(this._friendList);
         this._friendList = null;
         ObjectUtils.disposeObject(this._writingViewBG);
         this._writingViewBG = null;
         ObjectUtils.disposeObject(this._receiver);
         this._receiver = null;
         ObjectUtils.disposeObject(this._dropList);
         this._dropList = null;
         ObjectUtils.disposeObject(this._topic);
         this._topic = null;
         ObjectUtils.disposeObject(this._friendsBtn);
         this._friendsBtn = null;
         ObjectUtils.disposeObject(this._houerBtnGroup);
         this._houerBtnGroup = null;
         ObjectUtils.disposeObject(this._oneHouerBtn);
         this._oneHouerBtn = null;
         ObjectUtils.disposeObject(this._sixHouerBtn);
         this._sixHouerBtn = null;
         ObjectUtils.disposeObject(this._payForBtn);
         this._payForBtn = null;
         ObjectUtils.disposeObject(this._moneyInput);
         this._moneyInput = null;
         ObjectUtils.disposeObject(this._sendBtn);
         this._sendBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         ObjectUtils.disposeObject(this._confirmFrame);
         this._confirmFrame = null;
         ObjectUtils.disposeObject(this._diamonds);
         this._diamonds = null;
         ObjectUtils.disposeObject(this._selectInfo);
         this._selectInfo = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(Boolean(this._senderTip))
         {
            ObjectUtils.disposeObject(this._senderTip);
         }
         this._senderTip = null;
         if(Boolean(this._topicTip))
         {
            ObjectUtils.disposeObject(this._topicTip);
         }
         this._topicTip = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
         dispatchEvent(new EmailEvent(EmailEvent.DISPOSED));
      }
   }
}

