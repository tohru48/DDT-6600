package newTitle.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.EffortEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import hall.event.NewHallEvent;
   import newTitle.NewTitleManager;
   import newTitle.data.NewTitleModel;
   import newTitle.event.NewTitleEvent;
   
   public class NewTitleFrame extends Frame
   {
      
      private var _titleBg:Bitmap;
      
      private var _currentTitle:Bitmap;
      
      private var _titleSprite:Sprite;
      
      private var _titleTxt:FilterFrameText;
      
      private var _hideBtn:SelectedCheckButton;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _hasTitleBtn:SelectedTextButton;
      
      private var _allTitleBtn:SelectedTextButton;
      
      private var _titleList:NewTitleListView;
      
      private var _titleBottomBg:MutipleImage;
      
      private var _titleListBg:ScaleBitmapImage;
      
      private var _titleProBg:MutipleImage;
      
      private var _useBtnBg:ScaleBitmapImage;
      
      private var _useBtn:SimpleBitmapButton;
      
      private var _propertyText:FilterFrameText;
      
      private var _oldTitleText:FilterFrameText;
      
      private var _selectTitle:NewTitleModel;
      
      public function NewTitleFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.updateTitleList();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("newTitleView.titleTxt");
         this._titleBg = ComponentFactory.Instance.creat("asset.newTitle.titleBg");
         addToContent(this._titleBg);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("newTitle.currentTitleTxt");
         this._titleTxt.text = LanguageMgr.GetTranslation("newTitleView.currentTitleTxt");
         addToContent(this._titleTxt);
         this._titleBottomBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleBottomBg");
         addToContent(this._titleBottomBg);
         this._hasTitleBtn = ComponentFactory.Instance.creatComponentByStylename("newTitle.hasTitleBtn");
         this._hasTitleBtn.text = LanguageMgr.GetTranslation("newTitleView.hasTitleTxt");
         addToContent(this._hasTitleBtn);
         this._allTitleBtn = ComponentFactory.Instance.creatComponentByStylename("newTitle.allTitleBtn");
         this._allTitleBtn.text = LanguageMgr.GetTranslation("newTitleView.allTitleTxt");
         addToContent(this._allTitleBtn);
         this._hideBtn = ComponentFactory.Instance.creatComponentByStylename("newTitle.hideBtn");
         this._hideBtn.tipData = LanguageMgr.GetTranslation("newTitleView.hideBtnTipTxt");
         this._hideBtn.selected = !NewTitleManager.instance.ShowTitle;
         addToContent(this._hideBtn);
         this._titleListBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleListBg");
         addToContent(this._titleListBg);
         this._titleProBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleProBg");
         addToContent(this._titleProBg);
         this.creatTitleSprite();
         this._titleList = new NewTitleListView();
         PositionUtils.setPos(this._titleList,"newTitle.listPos");
         addToContent(this._titleList);
         this._propertyText = ComponentFactory.Instance.creatComponentByStylename("newTitle.propertyText");
         addToContent(this._propertyText);
         this._oldTitleText = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleText");
         this.loadIcon(NewTitleManager.instance.titleInfo[PlayerManager.Instance.Self.honorId]);
         this._useBtnBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.useBtnBG");
         addToContent(this._useBtnBg);
         this._useBtn = ComponentFactory.Instance.creatComponentByStylename("newTitle.useBtn");
         addToContent(this._useBtn);
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._hasTitleBtn);
         this._selectedButtonGroup.addSelectItem(this._allTitleBtn);
         this._selectedButtonGroup.selectIndex = 0;
      }
      
      private function creatTitleSprite() : void
      {
         this._titleSprite = new Sprite();
         this._titleSprite.graphics.beginFill(0,0);
         this._titleSprite.graphics.drawRect(0,0,this._titleProBg.width,70);
         this._titleSprite.graphics.endFill();
         addToContent(this._titleSprite);
         PositionUtils.setPos(this._titleSprite,this._titleProBg);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._hideBtn.addEventListener(MouseEvent.CLICK,this.__onHideTitleClick);
         this._selectedButtonGroup.addEventListener(Event.CHANGE,this.__onSelectChange);
         this._useBtn.addEventListener(MouseEvent.CLICK,this.__onUseClick);
         EffortManager.Instance.addEventListener(EffortEvent.FINISH,this.__upadteTitle);
         NewTitleManager.instance.addEventListener(NewTitleEvent.TITLE_ITEM_CLICK,this.__onItemClick);
         NewTitleManager.instance.addEventListener(NewTitleEvent.SET_SELECT_TITLE,this.__onSetSelectTitleForCurrent);
      }
      
      private function updateTitleList() : void
      {
         this._titleList.updateOwnTitleList();
      }
      
      public function __onSetSelectTitleForCurrent(event:NewTitleEvent) : void
      {
         ObjectUtils.disposeObject(this._currentTitle);
         this._currentTitle = null;
         this.loadIcon(this._selectTitle);
      }
      
      protected function __onUseClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._selectTitle))
         {
            ObjectUtils.removeChildAllChildren(this._titleSprite);
            this.loadIcon(this._selectTitle);
            NewTitleManager.instance.dispatchEvent(new NewTitleEvent(NewTitleEvent.SELECT_TITLE,[this._selectTitle.Name]));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newTitleView.selectTitleTxt"));
         }
      }
      
      protected function __onHideTitleClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         NewTitleManager.instance.ShowTitle = !this._hideBtn.selected;
         SocketManager.Instance.out.showHideTitleState(this._hideBtn.selected);
         SocketManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.UPDATETITLE));
      }
      
      protected function __onItemClick(event:NewTitleEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedButtonGroup.selectIndex == 0)
         {
            this._selectTitle = EffortManager.Instance.getHonorArray()[event.data[0]];
            this._useBtn.enable = true;
         }
         else
         {
            this._selectTitle = NewTitleManager.instance.titleArray[event.data[0]];
            this._useBtn.enable = this.isOwnTitle(this._selectTitle.Name);
         }
         this.setPropertyText();
         ObjectUtils.removeChildAllChildren(this._titleSprite);
         this.loadIcon(this._selectTitle);
      }
      
      private function setPropertyText() : void
      {
         var replaceStr:String = "";
         this._propertyText.text = LanguageMgr.GetTranslation("newTitleView.propertyTxt",this._selectTitle.Att,this._selectTitle.Def,this._selectTitle.Agi,this._selectTitle.Luck,this._selectTitle.Valid,this._selectTitle.Desc);
         if(this._selectTitle.Valid <= 0)
         {
            replaceStr = LanguageMgr.GetTranslation("newTitleView.hasnoTitleTxt");
         }
         else if(this._selectTitle.Valid > 5 * 365)
         {
            replaceStr = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
         }
         if(replaceStr.length > 0)
         {
            this._propertyText.text = this._propertyText.text.replace(this._selectTitle.Valid + LanguageMgr.GetTranslation("day"),replaceStr);
         }
      }
      
      private function isOwnTitle(name:String) : Boolean
      {
         var flag:Boolean = false;
         var ownTitleArr:Array = EffortManager.Instance.getHonorArray();
         for(var i:int = 0; i < ownTitleArr.length; i++)
         {
            if(name == ownTitleArr[i].Name)
            {
               flag = true;
               break;
            }
         }
         return flag;
      }
      
      private function loadIcon(titleModel:NewTitleModel) : void
      {
         var loader:BaseLoader = null;
         if(titleModel && titleModel.Pic && titleModel.Pic != "0")
         {
            loader = LoadResourceManager.Instance.createLoader(PathManager.solvePath("image/title/" + titleModel.Pic + "/icon.png"),BaseLoader.BITMAP_LOADER);
            loader.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
            LoadResourceManager.Instance.startLoad(loader,true);
         }
         else if(Boolean(titleModel))
         {
            this._oldTitleText.text = titleModel.Name;
            this._oldTitleText.x = (this._titleSprite.width - this._oldTitleText.width) / 2;
            this._oldTitleText.y = (this._titleSprite.height - this._oldTitleText.height) / 2;
            this._titleSprite.addChild(this._oldTitleText);
         }
      }
      
      protected function __onComplete(event:LoaderEvent) : void
      {
         var bitmap:Bitmap = null;
         var loader:BaseLoader = event.loader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         bitmap = loader.content;
         if(Boolean(bitmap))
         {
            if(!this._currentTitle && PlayerManager.Instance.Self.honorId >= NewTitleManager.FIRST_TITLEID)
            {
               this._currentTitle = new Bitmap(bitmap.bitmapData.clone());
               this._currentTitle.x = this._titleBg.x + (this._titleBg.width - this._currentTitle.width) / 2;
               this._currentTitle.y = this._titleBg.y + (this._titleBg.height - this._currentTitle.height) / 2;
               addToContent(this._currentTitle);
            }
            else
            {
               bitmap.x = (this._titleSprite.width - bitmap.width) / 2;
               bitmap.y = (this._titleSprite.height - bitmap.height) / 2;
               this._titleSprite.addChild(bitmap);
            }
         }
      }
      
      protected function __onSelectChange(event:Event) : void
      {
         SoundManager.instance.play("008");
         switch(this._selectedButtonGroup.selectIndex)
         {
            case 0:
               this._titleList.updateOwnTitleList();
               break;
            case 1:
               this._titleList.updateAllTitleList();
         }
      }
      
      private function __upadteTitle(event:EffortEvent) : void
      {
         if(this._selectedButtonGroup.selectIndex == 0)
         {
            this._titleList.updateOwnTitleList();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               NewTitleManager.instance.hide();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._hideBtn.removeEventListener(MouseEvent.CLICK,this.__onHideTitleClick);
         this._selectedButtonGroup.removeEventListener(Event.CHANGE,this.__onSelectChange);
         this._useBtn.removeEventListener(MouseEvent.CLICK,this.__onUseClick);
         NewTitleManager.instance.removeEventListener(NewTitleEvent.TITLE_ITEM_CLICK,this.__onItemClick);
         NewTitleManager.instance.removeEventListener(NewTitleEvent.SET_SELECT_TITLE,this.__onSetSelectTitleForCurrent);
         EffortManager.Instance.removeEventListener(EffortEvent.FINISH,this.__upadteTitle);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeAllChildren(this._titleSprite);
         this._titleSprite = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         ObjectUtils.disposeObject(this._titleBottomBg);
         this._titleBottomBg = null;
         ObjectUtils.disposeObject(this._titleListBg);
         this._titleListBg = null;
         ObjectUtils.disposeObject(this._titleProBg);
         this._titleProBg = null;
         ObjectUtils.disposeObject(this._hideBtn);
         this._hideBtn = null;
         ObjectUtils.disposeObject(this._useBtnBg);
         this._useBtnBg = null;
         ObjectUtils.disposeObject(this._useBtn);
         this._useBtn = null;
         ObjectUtils.disposeObject(this._hasTitleBtn);
         this._hasTitleBtn = null;
         ObjectUtils.disposeObject(this._propertyText);
         this._propertyText = null;
         ObjectUtils.disposeObject(this._oldTitleText);
         this._oldTitleText = null;
         ObjectUtils.disposeObject(this._allTitleBtn);
         this._allTitleBtn = null;
         ObjectUtils.disposeObject(this._titleList);
         this._titleList = null;
         ObjectUtils.disposeObject(this._currentTitle);
         this._currentTitle = null;
      }
   }
}

