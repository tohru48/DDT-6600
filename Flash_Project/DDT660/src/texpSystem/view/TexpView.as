package texpSystem.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shop.view.NewShopBugleView;
   import shop.view.SetsShopView;
   import texpSystem.TexpEvent;
   import texpSystem.controller.TexpManager;
   import texpSystem.data.TexpInfo;
   import texpSystem.data.TexpType;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class TexpView extends Sprite implements Disposeable
   {
      
      private var _bg1:MovieImage;
      
      private var _bg2:Scale9CornerImage;
      
      private var _bg3:Scale9CornerImage;
      
      private var _bg4:Bitmap;
      
      private var _txtBg1:Bitmap;
      
      private var _bg5:MutipleImage;
      
      private var _texpCell:TexpCell;
      
      private var _lblTexpName:FilterFrameText;
      
      private var _lblCurrLv:FilterFrameText;
      
      private var _limitCount:FilterFrameText;
      
      private var _lblCurrEffect:FilterFrameText;
      
      private var _lblUpEffect:FilterFrameText;
      
      private var _txtCurrEffect:FilterFrameText;
      
      private var _txtUpEffect:FilterFrameText;
      
      private var _buyText:FilterFrameText;
      
      private var _buyText1:FilterFrameText;
      
      private var _sbtnGroup:SelectedButtonGroup;
      
      private var _sbtnAtt:SelectedButton;
      
      private var _sbtnHp:SelectedButton;
      
      private var _sbtnLuk:SelectedButton;
      
      private var _sbtnDef:SelectedButton;
      
      private var _sbtnSpd:SelectedButton;
      
      private var _attLevel:FilterFrameText;
      
      private var _hpLevel:FilterFrameText;
      
      private var _lukLevel:FilterFrameText;
      
      private var _defLevel:FilterFrameText;
      
      private var _spdLevel:FilterFrameText;
      
      private var _infoArray:Vector.<FilterFrameText>;
      
      private var _background1:Bitmap;
      
      private var _progressLevel:TexpLevelPro;
      
      private var _btnTexp:SimpleBitmapButton;
      
      private var _btnHelp:BaseButton;
      
      private var _btnBuy:TexpBuyButton;
      
      private var _textBack:Bitmap;
      
      private var _helpFrame:Frame;
      
      private var isActive:Boolean = false;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      public function TexpView()
      {
         super();
         this.initView();
         this.initEvent();
         this.texpGuide();
      }
      
      private function texpGuide() : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.TEXP_GUIDE))
         {
            if(PlayerManager.Instance.Self.Grade == 13 && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(7)))
            {
               NewHandContainer.Instance.showArrow(ArrowType.TEXP_GUIDE,0,new Point(217,63),"asset.trainer.txtTexpGuide","guide.texp.txtPos",this);
            }
         }
      }
      
      private function initView() : void
      {
         this._infoArray = new Vector.<FilterFrameText>();
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg1");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg2");
         addChild(this._bg2);
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg3");
         addChild(this._bg3);
         this._bg4 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.bg4");
         addChild(this._bg4);
         this._txtBg1 = ComponentFactory.Instance.creatBitmap("asset.texpSystem.txtBg1");
         PositionUtils.setPos(this._txtBg1,"texpSystem.posTxtBg1");
         addChild(this._txtBg1);
         this._bg5 = ComponentFactory.Instance.creatComponentByStylename("texpSystem.bg5");
         addChild(this._bg5);
         this._background1 = ComponentFactory.Instance.creatBitmap("texpSystem.Background_Progress1");
         PositionUtils.setPos(this._background1,"texpSystem.expBackground1Pos");
         addChild(this._background1);
         this._texpCell = ComponentFactory.Instance.creatCustomObject("texpSystem.texpCell");
         addChild(this._texpCell);
         this._textBack = ComponentFactory.Instance.creat("asset.texpSystem.texpNum");
         addChild(this._textBack);
         this._lblTexpName = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblTexpName");
         this._lblTexpName.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpName");
         addChild(this._lblTexpName);
         this._lblCurrLv = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblCurrentLv");
         addChild(this._lblCurrLv);
         this._limitCount = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblCurrentLv");
         this._limitCount.x = 245;
         this._limitCount.y = 214;
         addChild(this._limitCount);
         this._lblCurrEffect = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblCurrentEffect");
         this._lblCurrEffect.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.currEffect");
         addChild(this._lblCurrEffect);
         this._lblUpEffect = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lblUpEffect");
         this._lblUpEffect.text = LanguageMgr.GetTranslation("texpSystem.view.TexpView.upEffect");
         addChild(this._lblUpEffect);
         this._txtCurrEffect = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtCurrEffect");
         addChild(this._txtCurrEffect);
         this._txtUpEffect = ComponentFactory.Instance.creatComponentByStylename("texpSystem.txtUpEffect");
         addChild(this._txtUpEffect);
         this._sbtnGroup = new SelectedButtonGroup();
         this._sbtnHp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.hp");
         this._sbtnHp.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.HP));
         this._sbtnGroup.addSelectItem(this._sbtnHp);
         addChild(this._sbtnHp);
         this._hpLevel = ComponentFactory.Instance.creatComponentByStylename("texpSystem.hpLevel");
         addChild(this._hpLevel);
         this._infoArray.push(this._hpLevel);
         this._sbtnAtt = ComponentFactory.Instance.creatComponentByStylename("texpSystem.att");
         this._sbtnAtt.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.ATT));
         this._sbtnGroup.addSelectItem(this._sbtnAtt);
         addChild(this._sbtnAtt);
         this._attLevel = ComponentFactory.Instance.creatComponentByStylename("texpSystem.attLevel");
         addChild(this._attLevel);
         this._infoArray.push(this._attLevel);
         this._sbtnDef = ComponentFactory.Instance.creatComponentByStylename("texpSystem.def");
         this._sbtnDef.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.DEF));
         this._sbtnGroup.addSelectItem(this._sbtnDef);
         addChild(this._sbtnDef);
         this._defLevel = ComponentFactory.Instance.creatComponentByStylename("texpSystem.defLevel");
         addChild(this._defLevel);
         this._infoArray.push(this._defLevel);
         this._sbtnSpd = ComponentFactory.Instance.creatComponentByStylename("texpSystem.spd");
         this._sbtnSpd.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.SPD));
         this._sbtnGroup.addSelectItem(this._sbtnSpd);
         addChild(this._sbtnSpd);
         this._spdLevel = ComponentFactory.Instance.creatComponentByStylename("texpSystem.spdLevel");
         addChild(this._spdLevel);
         this._infoArray.push(this._spdLevel);
         this._sbtnLuk = ComponentFactory.Instance.creatComponentByStylename("texpSystem.luk");
         this._sbtnLuk.tipData = LanguageMgr.GetTranslation("texpSystem.view.TexpView.texpTip",TexpManager.Instance.getName(TexpType.LUK));
         this._sbtnGroup.addSelectItem(this._sbtnLuk);
         addChild(this._sbtnLuk);
         this._lukLevel = ComponentFactory.Instance.creatComponentByStylename("texpSystem.lukLevel");
         addChild(this._lukLevel);
         this._infoArray.push(this._lukLevel);
         this._btnTexp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.btnTexp");
         addChild(this._btnTexp);
         this._btnBuy = ComponentFactory.Instance.creat("texpSystem.btnBuy");
         this._btnBuy.setup(EquipType.TEXP_LV_III);
         addChild(this._btnBuy);
         this._buyText = ComponentFactory.Instance.creatComponentByStylename("ddttexpSystem.buyText");
         this._buyText.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
         this._btnBuy.addChild(this._buyText);
         this._btnHelp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.btnHelp");
         addChild(this._btnHelp);
         this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("TexpLevelProgress");
         addChild(this._progressLevel);
         this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressLevel.tipDirctions = "3,7,6";
         this._buyText1 = ComponentFactory.Instance.creatComponentByStylename("ddttexpSystem.buyText1");
         this._buyText1.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
         this.setInfoLevel();
         this._sbtnGroup.selectIndex = 1;
         this.setTexpInfo(this._sbtnGroup.selectIndex);
         this.setLimitTxt();
      }
      
      private function setLimitTxt() : void
      {
         var addTexpCount:int = 0;
         if(TexpManager.Instance.isXiuLianDaShi(PlayerManager.Instance.Self.buffInfo))
         {
            addTexpCount = 5;
         }
         else
         {
            addTexpCount = 0;
         }
         var total:int = PlayerManager.Instance.Self.Grade + addTexpCount;
         var limit:int = total - PlayerManager.Instance.Self.texpCount;
         var str:String = limit + "/" + total;
         this._limitCount.text = str;
      }
      
      private function setInfoLevel() : void
      {
         var info:TexpInfo = null;
         for(var j:int = 0; j < 5; j++)
         {
            info = TexpManager.Instance.getInfo(j,TexpManager.Instance.getExp(j));
            this._infoArray[j].text = LanguageMgr.GetTranslation("ddt.cardSystem.CardEquipView.levelText") + info.lv.toString();
         }
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.playerPropertyEventHander);
         this._sbtnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._sbtnAtt.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnHp.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnLuk.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnDef.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnSpd.addEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._btnTexp.addEventListener(MouseEvent.CLICK,this.__texpClick);
         this._btnBuy.addEventListener(MouseEvent.CLICK,this.__buyClick);
         this._btnHelp.addEventListener(MouseEvent.CLICK,this.__helpClick);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_HP,this.__onChange);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_ATT,this.__onChange);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_DEF,this.__onChange);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_SPD,this.__onChange);
         TexpManager.Instance.addEventListener(TexpEvent.TEXP_LUK,this.__onChange);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE,this.__updateStoreBag);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.playerPropertyEventHander);
         this._sbtnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._sbtnAtt.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnHp.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnLuk.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnDef.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._sbtnSpd.removeEventListener(MouseEvent.CLICK,this.__texpTypeClick);
         this._btnTexp.removeEventListener(MouseEvent.CLICK,this.__texpClick);
         this._btnBuy.removeEventListener(MouseEvent.CLICK,this.__buyClick);
         this._btnHelp.removeEventListener(MouseEvent.CLICK,this.__helpClick);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_HP,this.__onChange);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_ATT,this.__onChange);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_DEF,this.__onChange);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_SPD,this.__onChange);
         TexpManager.Instance.removeEventListener(TexpEvent.TEXP_LUK,this.__onChange);
      }
      
      private function playerPropertyEventHander(e:PlayerPropertyEvent) : void
      {
         this.setLimitTxt();
      }
      
      private function __buyBuff(evt:MouseEvent) : void
      {
         var item:ShopItemInfo = null;
         var carItem:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         var list:Array = [];
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Caddy_Good);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Save_Life);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Agility_Get);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.ReHealth);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Train_Good);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Level_Try);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         item = ShopManager.Instance.getGoodsByTemplateID(EquipType.Card_Get);
         carItem = new ShopCarItemInfo(item.ShopID,item.TemplateID);
         ObjectUtils.copyProperties(carItem,item);
         list.push(carItem);
         var setspayFrame:SetsShopView = new SetsShopView();
         setspayFrame.initialize(list);
         LayerManager.Instance.addToLayer(setspayFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function clearInfo() : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         this._texpCell.info = null;
      }
      
      public function startShine() : void
      {
         this._texpCell.startShine();
      }
      
      public function stopShine() : void
      {
         this._texpCell.stopShine();
      }
      
      private function __updateStoreBag(evt:BagEvent) : void
      {
         var p:String = null;
         var place:int = 0;
         for(p in evt.changedSlots)
         {
            place = int(p);
            if(place == 0)
            {
               this._texpCell.info = PlayerManager.Instance.Self.StoreBag.items[0];
            }
         }
      }
      
      private function __onChange(evt:TexpEvent) : void
      {
         switch(evt.type)
         {
            case TexpEvent.TEXP_HP:
               if(this._sbtnGroup.selectIndex == TexpType.HP)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
               break;
            case TexpEvent.TEXP_ATT:
               if(this._sbtnGroup.selectIndex == TexpType.ATT)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
               break;
            case TexpEvent.TEXP_DEF:
               if(this._sbtnGroup.selectIndex == TexpType.DEF)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
               break;
            case TexpEvent.TEXP_SPD:
               if(this._sbtnGroup.selectIndex == TexpType.SPD)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
               break;
            case TexpEvent.TEXP_LUK:
               if(this._sbtnGroup.selectIndex == TexpType.LUK)
               {
                  this.setTexpInfo(this._sbtnGroup.selectIndex);
               }
         }
      }
      
      private function __changeHandler(evt:Event) : void
      {
         this.setTexpInfo(this._sbtnGroup.selectIndex);
      }
      
      private function __texpTypeClick(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
      }
      
      private function __texpClick(evt:MouseEvent) : void
      {
         var addTexpCount:int = 0;
         SoundManager.instance.playButtonSound();
         var info:InventoryItemInfo = this._texpCell.info as InventoryItemInfo;
         if(Boolean(info))
         {
            if(info.CategoryID != EquipType.TEXP)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.typeError"));
               return;
            }
            addTexpCount = 0;
            if(TexpManager.Instance.isXiuLianDaShi(PlayerManager.Instance.Self.buffInfo))
            {
               addTexpCount = 5;
            }
            else
            {
               addTexpCount = 0;
            }
            if(PlayerManager.Instance.Self.texpCount >= PlayerManager.Instance.Self.Grade + addTexpCount)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.texpCountToplimit"));
               return;
            }
            if(this._sbtnGroup.selectIndex == -1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.selectType"));
               return;
            }
            if(TexpManager.Instance.getLv(TexpManager.Instance.getExp(this._sbtnGroup.selectIndex)) >= PlayerManager.Instance.Self.Grade + 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.lvToplimit"));
               return;
            }
            SocketManager.Instance.out.sendTexp(this._sbtnGroup.selectIndex,info.TemplateID,info.Count,info.Place);
            if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.TEXP_GUIDE))
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.TEXP_GUIDE);
               SocketManager.Instance.out.syncWeakStep(Step.TEXP_GUIDE);
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.empty"));
         }
      }
      
      private function __buyClick(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         KeyboardShortcutsManager.Instance.prohibitNewHandBag(false);
         var buy:NewShopBugleView = new NewShopBugleView(EquipType.TEXP_LV_III);
      }
      
      private function __helpClick(evt:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("texpSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("texpSystem.view.TexpView.helpTitle");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("texpSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("texpSystem.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("texpSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      private function setTexpInfo(type:int) : void
      {
         var info:TexpInfo = TexpManager.Instance.getInfo(type,TexpManager.Instance.getExp(type));
         this._texpCell.texpInfo = info;
         this._lblTexpName.text = TexpManager.Instance.getName(type);
         this._lblCurrLv.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardEquipView.levelText") + info.lv.toString();
         this._txtCurrEffect.text = info.currEffect.toString();
         this._txtUpEffect.text = info.upEffect.toString();
         this.setInfoLevel();
         this._progressLevel.setProgress(info.currExp / info.upExp * 100,100);
         this._progressLevel.tipData = info.currExp + "/" + info.upExp;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearInfo();
         ObjectUtils.disposeAllChildren(this);
         this._bg1 = null;
         this._bg2 = null;
         this._bg3 = null;
         this._bg4 = null;
         this._bg5 = null;
         this._txtBg1 = null;
         this._texpCell = null;
         this._lblTexpName = null;
         this._lblCurrLv = null;
         this._lblCurrEffect = null;
         this._lblUpEffect = null;
         this._txtCurrEffect = null;
         this._txtUpEffect = null;
         this._sbtnGroup = null;
         this._sbtnAtt = null;
         this._sbtnHp = null;
         this._sbtnLuk = null;
         this._sbtnDef = null;
         this._sbtnSpd = null;
         this._btnTexp = null;
         this._btnBuy = null;
         this._btnHelp = null;
         this._attLevel = null;
         this._hpLevel = null;
         this._defLevel = null;
         this._lukLevel = null;
         this._spdLevel = null;
         this._infoArray = null;
         this._background1 = null;
         this._progressLevel = null;
         if(Boolean(this._helpFrame))
         {
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._btnOk.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            ObjectUtils.disposeObject(this._bgHelp);
            ObjectUtils.disposeObject(this._content);
            ObjectUtils.disposeObject(this._btnOk);
            this._bgHelp = null;
            this._content = null;
            this._btnOk = null;
            this._helpFrame.dispose();
            this._helpFrame = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

