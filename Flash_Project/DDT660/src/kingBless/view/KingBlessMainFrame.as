package kingBless.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kingBless.KingBlessManager;
   import shop.view.ShopPresentClearingFrame;
   
   public class KingBlessMainFrame extends Frame
   {
      
      private var _awardIconBtnBg:Bitmap;
      
      private var _monthBtnBg:Bitmap;
      
      private var _bottomBg:Bitmap;
      
      private var _txtBg:Bitmap;
      
      private var _oneMonthBtn:SelectedButton;
      
      private var _threeMonthBtn:SelectedButton;
      
      private var _sixMonthBtn:SelectedButton;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _openFriendBtn:SimpleBitmapButton;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _awardIconList:Vector.<Image>;
      
      private var _awardNameTxtList:Vector.<FilterFrameText>;
      
      private var _tipTxt:FilterFrameText;
      
      private var _descTxt:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _nameList:Array;
      
      private var _descList:Array;
      
      private var _tipList:Array;
      
      private var _tipNoOpenTxt:String;
      
      private var _needMoneyList:Array;
      
      private var _openTimeDescList:Array;
      
      private var _giveFriendOpenFrame:ShopPresentClearingFrame;
      
      private var _discountIcon:Image;
      
      private var _friendInfo:Object;
      
      private var payMoney:int;
      
      private var _isGive:Boolean;
      
      public function KingBlessMainFrame()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         var tmparray:Array = null;
         var j:int = 0;
         this._nameList = LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardNameTxtList").split(",");
         this._descList = [];
         this._tipList = [];
         for(var i:int = 1; i <= 3; i++)
         {
            this._tipList.push(LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardTipTxt" + i));
            tmparray = [];
            for(j = 1; j <= 6; j++)
            {
               tmparray.push(LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardDescTxt" + i.toString() + j.toString()));
            }
            this._descList.push(tmparray);
         }
         this._tipNoOpenTxt = LanguageMgr.GetTranslation("ddt.kingBlessFrame.noOpenTipTxt");
         this._needMoneyList = LanguageMgr.GetTranslation("ddt.kingBlessFrame.openNeedMoney").split(",");
         this._openTimeDescList = LanguageMgr.GetTranslation("ddt.kingBlessFrame.openTime").split(",");
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var image:Image = null;
         var txt:FilterFrameText = null;
         titleText = LanguageMgr.GetTranslation("ddt.kingBlessFrame.titleTxt");
         this._awardIconBtnBg = ComponentFactory.Instance.creatBitmap("asset.kingbless.awardIconBtnBg");
         this._monthBtnBg = ComponentFactory.Instance.creatBitmap("asset.kingbless.monthBtnBg");
         this._bottomBg = ComponentFactory.Instance.creatBitmap("asset.kingbless.bottomBg");
         this._txtBg = ComponentFactory.Instance.creatBitmap("asset.kingbless.txtBg");
         this._oneMonthBtn = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.oneMonthBtn");
         this._threeMonthBtn = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.threeMonthBtn");
         this._sixMonthBtn = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.sixMonthBtn");
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._oneMonthBtn);
         this._selectedButtonGroup.addSelectItem(this._threeMonthBtn);
         this._selectedButtonGroup.addSelectItem(this._sixMonthBtn);
         this._selectedButtonGroup.selectIndex = 2;
         this._openFriendBtn = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.openFriendBtn");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.openBtn");
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.tipTxt");
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.descTxt");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.txtVBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.txtScrollPanel");
         this._discountIcon = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.discountIcon");
         addToContent(this._awardIconBtnBg);
         addToContent(this._monthBtnBg);
         addToContent(this._bottomBg);
         addToContent(this._txtBg);
         addToContent(this._oneMonthBtn);
         addToContent(this._threeMonthBtn);
         addToContent(this._sixMonthBtn);
         addToContent(this._scrollPanel);
         addToContent(this._openFriendBtn);
         addToContent(this._openBtn);
         addToContent(this._discountIcon);
         this._awardIconList = new Vector.<Image>(6);
         this._awardNameTxtList = new Vector.<FilterFrameText>(6);
         for(i = 0; i < 6; i++)
         {
            image = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.awardIcon");
            image.resourceLink = "asset.kingbless.awardIcon" + (i + 1);
            txt = ComponentFactory.Instance.creatComponentByStylename("kingBlessFrame.iconNameTxt");
            txt.text = this._nameList[i];
            image.x += i * 79;
            txt.x += i * 79;
            addToContent(image);
            addToContent(txt);
            this._awardIconList[i] = image;
            this._awardNameTxtList[i] = txt;
         }
         this.refreshIconTipData();
         this.refreshShowTxt();
         this.refreshOpenBtn();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._selectedButtonGroup.addEventListener(Event.CHANGE,this.selectedButtonChange,false,0,true);
         KingBlessManager.instance.addEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.refreshView);
         this._openFriendBtn.addEventListener(MouseEvent.CLICK,this.openFriendHandler,false,0,true);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.openHandler,false,0,true);
      }
      
      private function openHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this.judgeOpen())
         {
            return;
         }
         this.openConfirmFrame();
      }
      
      private function judgeOpen() : Boolean
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return false;
         }
         var index:int = this._selectedButtonGroup.selectIndex;
         this.payMoney = this._needMoneyList[index];
         return true;
      }
      
      private function openConfirmFrame() : void
      {
         var msg:String = null;
         var confirmFrame:BaseAlerFrame = null;
         var index:int = this._selectedButtonGroup.selectIndex;
         if(!this._friendInfo)
         {
            msg = LanguageMgr.GetTranslation("ddt.kingBlessFrame.openPromptTxt",this._openTimeDescList[index],this._needMoneyList[index]);
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
            this._isGive = false;
         }
         else
         {
            this._isGive = true;
            msg = LanguageMgr.GetTranslation("ddt.kingBlessFrame.openFriendPromptTxt",this._friendInfo["name"],this._openTimeDescList[index],this._needMoneyList[index]);
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame.moveEnable = false;
            confirmFrame.isBand = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
         }
      }
      
      private function __confirm(evt:FrameEvent) : void
      {
         var id:int = 0;
         var msg:String = null;
         var type:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(!this._friendInfo)
            {
               id = PlayerManager.Instance.Self.ID;
               msg = "";
            }
            else
            {
               id = int(this._friendInfo["id"]);
               msg = this._friendInfo["msg"];
            }
            type = this._selectedButtonGroup.selectIndex + 1;
            if(!this._isGive)
            {
               if(BuriedManager.Instance.checkMoney(confirmFrame.isBand,this.payMoney))
               {
                  return;
               }
               SocketManager.Instance.out.sendOpenKingBless(type,id,msg,confirmFrame.isBand);
               confirmFrame.dispose();
            }
            else
            {
               if(!(!confirmFrame.isBand && PlayerManager.Instance.Self.Money >= this.payMoney))
               {
                  LeavePageManager.showFillFrame();
                  confirmFrame.dispose();
                  return;
               }
               SocketManager.Instance.out.sendOpenKingBless(type,id,msg,confirmFrame.isBand);
            }
         }
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         this._friendInfo = null;
      }
      
      private function openFriendHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this.judgeOpen())
         {
            return;
         }
         this._giveFriendOpenFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this._giveFriendOpenFrame.nameInput.enable = false;
         this._giveFriendOpenFrame.titleTxt.visible = false;
         this._giveFriendOpenFrame.setType();
         this._giveFriendOpenFrame.show();
         this._giveFriendOpenFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick,false,0,true);
         this._giveFriendOpenFrame.addEventListener(FrameEvent.RESPONSE,this.__responseHandler2,false,0,true);
      }
      
      private function __responseHandler2(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            StageReferance.stage.focus = this;
            this._giveFriendOpenFrame = null;
         }
      }
      
      private function __presentBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var name:String = this._giveFriendOpenFrame.nameInput.text;
         if(name == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(name))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         this._friendInfo = {};
         this._friendInfo["id"] = this._giveFriendOpenFrame.selectPlayerId;
         this._friendInfo["name"] = name;
         this._friendInfo["msg"] = FilterWordManager.filterWrod(this._giveFriendOpenFrame.textArea.text);
         this.openConfirmFrame();
      }
      
      private function refreshView(event:Event) : void
      {
         this.refreshIconTipData();
         this.refreshOpenBtn();
      }
      
      private function selectedButtonChange(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.refreshShowTxt();
      }
      
      private function refreshOpenBtn() : void
      {
         var openType:int = KingBlessManager.instance.openType;
         if(openType > 0)
         {
            this._openBtn.backStyle = "asset.kingbless.renewBtn";
         }
         else
         {
            this._openBtn.backStyle = "asset.kingbless.openBtn";
         }
      }
      
      private function refreshIconTipData() : void
      {
         var openType:int = KingBlessManager.instance.openType;
         for(var i:int = 0; i < 6; i++)
         {
            if(openType > 0)
            {
               this._awardIconList[i].tipData = this._descList[openType - 1][i];
            }
            else
            {
               this._awardIconList[i].tipData = this._tipNoOpenTxt;
            }
         }
      }
      
      private function refreshShowTxt() : void
      {
         var tmp:String = null;
         var array:Array = null;
         var index:int = this._selectedButtonGroup.selectIndex;
         this._tipTxt.text = this._tipList[index];
         var tmpDescList:Array = this._descList[index];
         var tmpStr:String = "";
         for(var i:int = 0; i < 6; i++)
         {
            tmp = tmpDescList[i];
            array = tmp.match(/\d+/);
            if(Boolean(array) && array.length > 0)
            {
               tmp = tmp.replace(array[0],"<FONT COLOR=\'#FF0000\'>" + array[0] + "</FONT>");
            }
            tmpStr += LanguageMgr.GetTranslation("ddt.kingBlessFrame.awardDescTxt",(i + 1).toString(),this._nameList[i],tmp) + "\n";
         }
         this._descTxt.htmlText = tmpStr;
         this._vbox.addChild(this._tipTxt);
         this._vbox.addChild(this._descTxt);
         this._scrollPanel.setView(this._vbox);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._selectedButtonGroup.removeEventListener(Event.CHANGE,this.selectedButtonChange);
         KingBlessManager.instance.removeEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.refreshView);
         this._openFriendBtn.removeEventListener(MouseEvent.CLICK,this.openFriendHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.openHandler);
      }
      
      override public function dispose() : void
      {
         var image:Image = null;
         var txt:FilterFrameText = null;
         this.removeEvent();
         ObjectUtils.disposeObject(this._awardIconBtnBg);
         this._awardIconBtnBg = null;
         ObjectUtils.disposeObject(this._monthBtnBg);
         this._monthBtnBg = null;
         ObjectUtils.disposeObject(this._bottomBg);
         this._bottomBg = null;
         ObjectUtils.disposeObject(this._txtBg);
         this._txtBg = null;
         ObjectUtils.disposeObject(this._selectedButtonGroup);
         this._selectedButtonGroup = null;
         ObjectUtils.disposeObject(this._oneMonthBtn);
         this._oneMonthBtn = null;
         ObjectUtils.disposeObject(this._threeMonthBtn);
         this._threeMonthBtn = null;
         ObjectUtils.disposeObject(this._sixMonthBtn);
         this._sixMonthBtn = null;
         ObjectUtils.disposeObject(this._tipTxt);
         this._tipTxt = null;
         ObjectUtils.disposeObject(this._descTxt);
         this._descTxt = null;
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._openBtn);
         this._openBtn = null;
         ObjectUtils.disposeObject(this._openFriendBtn);
         this._openFriendBtn = null;
         ObjectUtils.disposeObject(this._giveFriendOpenFrame);
         this._giveFriendOpenFrame = null;
         ObjectUtils.disposeObject(this._discountIcon);
         this._discountIcon = null;
         for each(image in this._awardIconList)
         {
            ObjectUtils.disposeObject(image);
         }
         this._awardIconList = null;
         for each(txt in this._awardNameTxtList)
         {
            ObjectUtils.disposeObject(txt);
         }
         this._awardNameTxtList = null;
         this._nameList = null;
         this._descList = null;
         super.dispose();
      }
   }
}

