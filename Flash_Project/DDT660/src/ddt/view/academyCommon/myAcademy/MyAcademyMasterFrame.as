package ddt.view.academyCommon.myAcademy
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.academyCommon.myAcademy.myAcademyItem.MyAcademyApprenticeItem;
   import ddt.view.academyCommon.myAcademy.myAcademyItem.MyAcademyMasterItem;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class MyAcademyMasterFrame extends BaseAlerFrame implements Disposeable
   {
      
      public static const ITEM_NUM:int = 3;
      
      public static const BOTTOM_GAP:int = 27;
      
      protected var _myAcademyTitle:Bitmap;
      
      protected var _myAcademyIcon:Bitmap;
      
      protected var _ItemButtomBg1:ScaleBitmapImage;
      
      protected var _ItemButtomBg2:ScaleBitmapImage;
      
      protected var _ItemButtomBg3:ScaleBitmapImage;
      
      protected var _itemBG:MovieImage;
      
      protected var _titleline1:ScaleBitmapImage;
      
      protected var _titleline2:ScaleBitmapImage;
      
      protected var _titleline3:ScaleBitmapImage;
      
      protected var _titleline4:ScaleBitmapImage;
      
      protected var _titleline5:ScaleBitmapImage;
      
      protected var _titleline6:ScaleBitmapImage;
      
      protected var _nameTitle:FilterFrameText;
      
      protected var _levelTitle:FilterFrameText;
      
      protected var _stateTitle:FilterFrameText;
      
      protected var _sexTitle:FilterFrameText;
      
      protected var _emailTitle:FilterFrameText;
      
      protected var _appreCount:FilterFrameText;
      
      protected var _academyCalled:FilterFrameText;
      
      protected var _offLineTitle:FilterFrameText;
      
      protected var _disposeTitle:FilterFrameText;
      
      protected var _nameTitleClass:FilterFrameText;
      
      protected var _levelTitleClass:FilterFrameText;
      
      protected var _emailTitleClass:FilterFrameText;
      
      protected var _offLineTitleClass:FilterFrameText;
      
      protected var _disposeTitleClass:FilterFrameText;
      
      protected var _titleBtn:TextButton;
      
      protected var _myApprentice:DictionaryData;
      
      protected var _items:Vector.<MyAcademyApprenticeItem>;
      
      protected var _alertInfo:AlertInfo;
      
      protected var _currentItem:MyAcademyMasterItem;
      
      protected var _gradueteNumText:GradientText;
      
      protected var _masterHonorText:GradientText;
      
      public function MyAcademyMasterFrame()
      {
         super();
         this.initContent();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function initContent() : void
      {
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("im.IMView.myAcademyBtnTips");
         this._alertInfo.bottomGap = BOTTOM_GAP;
         this._alertInfo.customPos = ComponentFactory.Instance.creatCustomObject("academyCommon.myAcademy.gotoMainlPos2");
         info = this._alertInfo;
         this._ItemButtomBg1 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.itemButtomBg1");
         addToContent(this._ItemButtomBg1);
         this._myAcademyTitle = ComponentFactory.Instance.creatBitmap("asset.academyCommon.myAcademy.myAcademyTitle");
         addToContent(this._myAcademyTitle);
         this._titleBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterFrame.titleBtn");
         this._titleBtn.text = LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree");
         addToContent(this._titleBtn);
         this._myApprentice = AcademyManager.Instance.myAcademyPlayers;
         this.initItem();
      }
      
      protected function initItemContent() : void
      {
         this._titleline1 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.formIineBig1");
         addToContent(this._titleline1);
         this._titleline2 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.formIineBig2");
         addToContent(this._titleline2);
         this._titleline3 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.formIineBig3");
         addToContent(this._titleline3);
         this._titleline4 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.formIineBig4");
         addToContent(this._titleline4);
         this._levelTitle = ComponentFactory.Instance.creatComponentByStylename("academyCommon.item.levelTitle");
         this._levelTitle.text = LanguageMgr.GetTranslation("itemview.listlevel");
         addToContent(this._levelTitle);
         this._offLineTitle = ComponentFactory.Instance.creatComponentByStylename("academyCommon.item.offLineTitle");
         this._offLineTitle.text = LanguageMgr.GetTranslation("itemview.listOffLine");
         addToContent(this._offLineTitle);
         this._emailTitle = ComponentFactory.Instance.creatComponentByStylename("academyCommon.item.emailTitle");
         this._emailTitle.text = LanguageMgr.GetTranslation("itemview.listLink");
         addToContent(this._emailTitle);
         this._disposeTitle = ComponentFactory.Instance.creatComponentByStylename("academyCommon.item.disposeTitle");
         this._disposeTitle.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.itemtitle.disposeItem");
         addToContent(this._disposeTitle);
      }
      
      protected function initItem() : void
      {
         this._myAcademyIcon = ComponentFactory.Instance.creatBitmap("asset.academyCommon.myAcademy.MyAcademyApprenticeIcon");
         addToContent(this._myAcademyIcon);
         this._ItemButtomBg2 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.itemButtomBg2");
         addToContent(this._ItemButtomBg2);
         this._ItemButtomBg3 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.itemButtomBg3");
         addToContent(this._ItemButtomBg3);
         this._gradueteNumText = ComponentFactory.Instance.creatComponentByStylename("view.common.MyAcademyMasterFrame.gradueteNumText");
         this._gradueteNumText.text = String(PlayerManager.Instance.Self.graduatesCount);
         addToContent(this._gradueteNumText);
         this._masterHonorText = ComponentFactory.Instance.creatComponentByStylename("view.common.MyAcademyMasterFrame.masterHonorText");
         this._masterHonorText.text = PlayerManager.Instance.Self.honourOfMaster;
         addToContent(this._masterHonorText);
         this._appreCount = ComponentFactory.Instance.creatComponentByStylename("academyCommon.apprenCount");
         this._appreCount.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.apprenCount");
         addToContent(this._appreCount);
         this._academyCalled = ComponentFactory.Instance.creatComponentByStylename("academyCommon.academyCalled");
         this._academyCalled.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRegisterFrame.academyHonorLabel");
         addToContent(this._academyCalled);
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.myAcademy.myAcademyApprenticeBG");
         addToContent(this._itemBG);
         this._nameTitle = ComponentFactory.Instance.creatComponentByStylename("academyCommon.item.nameTitle");
         this._nameTitle.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.ApprenticeIcon");
         addToContent(this._nameTitle);
         this.initItemContent();
         this._items = new Vector.<MyAcademyApprenticeItem>();
         var apprentice:MyAcademyApprenticeItem = new MyAcademyApprenticeItem();
         PositionUtils.setPos(apprentice,"academyCommon.myAcademy.MyAcademyMasterFrame.Apprentice");
         addToContent(apprentice);
         this._items.push(apprentice);
         var apprenticeII:MyAcademyApprenticeItem = new MyAcademyApprenticeItem();
         PositionUtils.setPos(apprenticeII,"academyCommon.myAcademy.MyAcademyMasterFrame.ApprenticeII");
         addToContent(apprenticeII);
         this._items.push(apprenticeII);
         var apprenticeIII:MyAcademyApprenticeItem = new MyAcademyApprenticeItem();
         PositionUtils.setPos(apprenticeIII,"academyCommon.myAcademy.MyAcademyMasterFrame.ApprenticeIII");
         addToContent(apprenticeIII);
         this._items.push(apprenticeIII);
         this.updateItem();
      }
      
      protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._titleBtn.addEventListener(MouseEvent.CLICK,this.__titleBtnClick);
         for(var i:int = 0; i < this._items.length; i++)
         {
            this._items[i].addEventListener(MouseEvent.CLICK,this.__itemClick);
         }
         AcademyManager.Instance.myAcademyPlayers.addEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         AcademyManager.Instance.myAcademyPlayers.addEventListener(DictionaryEvent.CLEAR,this.__clearItem);
      }
      
      protected function __titleBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AcademyFrameManager.Instance.showAcademyPreviewFrame();
      }
      
      protected function __clearItem(event:DictionaryEvent) : void
      {
         this.updateItem();
      }
      
      protected function __removeItem(event:DictionaryEvent) : void
      {
         this.updateItem();
      }
      
      protected function updateItem() : void
      {
         for(var i:int = 0; i < this._myApprentice.list.length; i++)
         {
            this._items[i].info = this._myApprentice.list[i];
         }
         for(var j:int = int(this._myApprentice.list.length); j < ITEM_NUM; j++)
         {
            this._items[j].visible = false;
         }
      }
      
      protected function __onResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               AcademyManager.Instance.gotoAcademyState();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
         }
      }
      
      protected function clearItem() : void
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(Boolean(this._items[i]))
            {
               this._items[i].removeEventListener(MouseEvent.CLICK,this.__itemClick);
               this._items[i].dispose();
               this._items[i] = null;
            }
         }
      }
      
      protected function __itemClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentItem)
         {
            this._currentItem = event.currentTarget as MyAcademyMasterItem;
         }
         if(this._currentItem != event.currentTarget as MyAcademyMasterItem)
         {
            this._currentItem.isSelect = false;
         }
         this._currentItem = event.currentTarget as MyAcademyMasterItem;
         this._currentItem.isSelect = true;
      }
      
      override public function dispose() : void
      {
         this.clearItem();
         removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         AcademyManager.Instance.myAcademyPlayers.removeEventListener(DictionaryEvent.REMOVE,this.__removeItem);
         AcademyManager.Instance.myAcademyPlayers.removeEventListener(DictionaryEvent.CLEAR,this.__clearItem);
         if(Boolean(this._ItemButtomBg1))
         {
            ObjectUtils.disposeObject(this._ItemButtomBg1);
            this._ItemButtomBg1 = null;
         }
         if(Boolean(this._ItemButtomBg2))
         {
            ObjectUtils.disposeObject(this._ItemButtomBg2);
            this._ItemButtomBg2 = null;
         }
         if(Boolean(this._ItemButtomBg3))
         {
            ObjectUtils.disposeObject(this._ItemButtomBg3);
            this._ItemButtomBg3 = null;
         }
         if(Boolean(this._appreCount))
         {
            ObjectUtils.disposeObject(this._appreCount);
            this._appreCount = null;
         }
         if(Boolean(this._academyCalled))
         {
            ObjectUtils.disposeObject(this._academyCalled);
            this._academyCalled = null;
         }
         if(Boolean(this._itemBG))
         {
            ObjectUtils.disposeObject(this._itemBG);
            this._itemBG = null;
         }
         if(Boolean(this._myAcademyIcon))
         {
            ObjectUtils.disposeObject(this._myAcademyIcon);
            this._myAcademyIcon = null;
         }
         if(Boolean(this._titleline1))
         {
            this._titleline1.dispose();
            this._titleline1 = null;
         }
         if(Boolean(this._titleline2))
         {
            this._titleline2.dispose();
            this._titleline2 = null;
         }
         if(Boolean(this._titleline3))
         {
            this._titleline3.dispose();
            this._titleline3 = null;
         }
         if(Boolean(this._titleline4))
         {
            this._titleline4.dispose();
            this._titleline4 = null;
         }
         if(Boolean(this._titleline5))
         {
            this._titleline5.dispose();
            this._titleline5 = null;
         }
         if(Boolean(this._titleline6))
         {
            this._titleline6.dispose();
            this._titleline6 = null;
         }
         if(Boolean(this._myAcademyTitle))
         {
            ObjectUtils.disposeObject(this._myAcademyTitle);
            this._myAcademyTitle = null;
         }
         if(Boolean(this._nameTitle))
         {
            ObjectUtils.disposeObject(this._nameTitle);
            this._nameTitle = null;
         }
         if(Boolean(this._levelTitle))
         {
            ObjectUtils.disposeObject(this._levelTitle);
            this._levelTitle = null;
         }
         if(Boolean(this._sexTitle))
         {
            ObjectUtils.disposeObject(this._sexTitle);
            this._sexTitle = null;
         }
         if(Boolean(this._stateTitle))
         {
            ObjectUtils.disposeObject(this._stateTitle);
            this._stateTitle = null;
         }
         if(Boolean(this._offLineTitle))
         {
            ObjectUtils.disposeObject(this._offLineTitle);
            this._offLineTitle = null;
         }
         if(Boolean(this._emailTitle))
         {
            ObjectUtils.disposeObject(this._emailTitle);
            this._emailTitle = null;
         }
         if(Boolean(this._disposeTitle))
         {
            ObjectUtils.disposeObject(this._disposeTitle);
            this._disposeTitle = null;
         }
         if(Boolean(this._nameTitleClass))
         {
            ObjectUtils.disposeObject(this._nameTitleClass);
            this._nameTitleClass = null;
         }
         if(Boolean(this._levelTitleClass))
         {
            ObjectUtils.disposeObject(this._levelTitleClass);
            this._levelTitleClass = null;
         }
         if(Boolean(this._emailTitleClass))
         {
            ObjectUtils.disposeObject(this._emailTitleClass);
            this._emailTitleClass = null;
         }
         if(Boolean(this._offLineTitleClass))
         {
            ObjectUtils.disposeObject(this._offLineTitleClass);
            this._offLineTitleClass = null;
         }
         if(Boolean(this._disposeTitleClass))
         {
            ObjectUtils.disposeObject(this._disposeTitleClass);
            this._disposeTitleClass = null;
         }
         if(Boolean(this._gradueteNumText))
         {
            this._gradueteNumText.dispose();
            this._gradueteNumText = null;
         }
         if(Boolean(this._masterHonorText))
         {
            this._masterHonorText.dispose();
            this._masterHonorText = null;
         }
         if(Boolean(this._titleBtn))
         {
            this._titleBtn.removeEventListener(MouseEvent.CLICK,this.__titleBtnClick);
            ObjectUtils.disposeObject(this._titleBtn);
            this._titleBtn = null;
         }
         if(Boolean(this._currentItem))
         {
            this._currentItem.dispose();
            this._currentItem = null;
         }
         super.dispose();
      }
   }
}

