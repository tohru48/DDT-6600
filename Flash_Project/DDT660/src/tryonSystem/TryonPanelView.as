package tryonSystem
{
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import equipretrieve.effect.AnimationControl;
   import equipretrieve.effect.GlowFilterAnimation;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class TryonPanelView extends Sprite implements Disposeable
   {
      
      private static const CELL_PLACE:Array = [0,1,2,3,4,5,11,13];
      
      private var _controller:TryonSystemController;
      
      private var _model:TryonModel;
      
      private var _bg:MovieImage;
      
      private var _bg1:ScaleBitmapImage;
      
      private var _tryTxt:FilterFrameText;
      
      private var _hideTxt:FilterFrameText;
      
      private var _hideHatBtn:SelectedCheckButton;
      
      private var _hideGlassBtn:SelectedCheckButton;
      
      private var _hideSuitBtn:SelectedCheckButton;
      
      private var _hideWingBtn:SelectedCheckButton;
      
      private var _bagItems:DictionaryData;
      
      private var _character:RoomCharacter;
      
      private var _itemList:SimpleTileList;
      
      private var _cells:Array;
      
      private var _bagCells:Array;
      
      private var _nickName:FilterFrameText;
      
      private var _effect:MovieClip;
      
      public function TryonPanelView(contro:TryonSystemController, frame:TryonPanelFrame)
      {
         super();
         this._controller = contro;
         this._model = this._controller.getModelByView(frame);
         this._cells = [];
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var item:InventoryItemInfo = null;
         var i:int = 0;
         var sp:Sprite = null;
         var cell:TryonCell = null;
         var _itemShine:MovieImage = null;
         var animation:GlowFilterAnimation = null;
         var cell1:PersonalInfoCell = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.tryOnBigBg");
         addChild(this._bg);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("core.tryOnSmallBg");
         addChild(this._bg1);
         this._tryTxt = ComponentFactory.Instance.creatComponentByStylename("asset.tryOnTxt");
         addChild(this._tryTxt);
         this._tryTxt.text = LanguageMgr.GetTranslation("ddt.quest.tryon.tryonTxt");
         this._hideTxt = ComponentFactory.Instance.creatComponentByStylename("asset.core.hideTxt");
         addChild(this._hideTxt);
         this._hideTxt.text = LanguageMgr.GetTranslation("ddt.quest.tryon.hide");
         this._hideGlassBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideHatCheckBox");
         addChild(this._hideGlassBtn);
         this._hideHatBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideGlassCheckBox");
         addChild(this._hideHatBtn);
         this._hideSuitBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideSuitCheckBox");
         addChild(this._hideSuitBtn);
         this._hideWingBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideWingCheckBox");
         addChild(this._hideWingBtn);
         this._hideHatBtn.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
         this._hideGlassBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
         this._hideSuitBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
         this._hideWingBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
         this._hideGlassBtn.selected = this._model.playerInfo.getGlassHide();
         this._hideSuitBtn.selected = this._model.playerInfo.getSuitesHide();
         this._hideWingBtn.selected = this._model.playerInfo.wingHide;
         this._character = CharactoryFactory.createCharacter(this._model.playerInfo,"room") as RoomCharacter;
         PositionUtils.setPos(this._character,"quest.tryon.character.pos");
         addChild(this._character);
         this._character.show(false,-1);
         this._effect = ComponentFactory.Instance.creat("asset.core.tryonEffect");
         PositionUtils.setPos(this._effect,"tryonSystem.TryonPanelView.effectPos");
         this._effect.stop();
         addChild(this._effect);
         this._itemList = new SimpleTileList(2);
         this._itemList.vSpace = 60;
         this._itemList.hSpace = 50;
         PositionUtils.setPos(this._itemList,"quest.tryon.simplelistPos");
         var animationControl:AnimationControl = new AnimationControl();
         animationControl.addEventListener(Event.COMPLETE,this._cellLightComplete);
         for each(item in this._model.items)
         {
            sp = new Sprite();
            sp.graphics.beginFill(16777215,0);
            sp.graphics.drawRect(0,0,43,43);
            sp.graphics.endFill();
            cell = new TryonCell(sp);
            cell.info = item;
            cell.addEventListener(MouseEvent.CLICK,this.__onClick);
            cell.buttonMode = true;
            this._itemList.addChild(cell);
            this._cells.push(cell);
            if(item.CategoryID == 3)
            {
               this._hideHatBtn.selected = true;
               this._model.playerInfo.setHatHide(this._hideHatBtn.selected);
            }
            else
            {
               this._hideHatBtn.selected = this._model.playerInfo.getHatHide();
            }
            _itemShine = ComponentFactory.Instance.creatComponentByStylename("asset.core.itemBigShinelight");
            _itemShine.movie.play();
            cell.addChildAt(_itemShine,1);
            animation = new GlowFilterAnimation();
            animation.start(_itemShine,false,16763955,0,0);
            animation.addMovie(0,0,19,0);
            animationControl.addMovies(animation);
         }
         addChild(this._itemList);
         this._bagItems = this._model.bagItems;
         this._bagCells = [];
         for(i = 0; i < 8; i++)
         {
            cell1 = new PersonalInfoCell(i,this._bagItems[CELL_PLACE[i]] as InventoryItemInfo,true);
            this._bagCells.push(cell1);
         }
         this._nickName = ComponentFactory.Instance.creatComponentByStylename("tryonNickNameText");
         addChild(this._nickName);
         this._nickName.text = PlayerManager.Instance.Self.NickName;
         animationControl.startMovie();
      }
      
      private function _cellLightComplete(e:Event) : void
      {
         var len:int = 0;
         var i:int = 0;
         var movie:MovieImage = null;
         e.currentTarget.removeEventListener(Event.COMPLETE,this._cellLightComplete);
         if(Boolean(this._cells))
         {
            len = int(this._cells.length);
            for(i = 0; i < len; i++)
            {
               movie = this._cells[i].removeChildAt(1);
               movie.dispose();
            }
         }
      }
      
      private function initEvents() : void
      {
         this._hideGlassBtn.addEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.addEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.addEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.addEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         this._model.addEventListener(Event.CHANGE,this.__onchange);
      }
      
      private function removeEvents() : void
      {
         this._hideGlassBtn.removeEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.removeEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.removeEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.removeEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         this._model.removeEventListener(Event.CHANGE,this.__onchange);
      }
      
      private function __onchange(event:Event) : void
      {
         for(var index:int = 0; index < 8; index++)
         {
            this._bagCells[index].info = this._bagItems[CELL_PLACE[index]] as InventoryItemInfo;
         }
      }
      
      private function __hideWingClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.playerInfo.wingHide = this._hideWingBtn.selected;
      }
      
      private function __hideSuitClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.playerInfo.setSuiteHide(this._hideSuitBtn.selected);
      }
      
      private function __hideHatClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.playerInfo.setHatHide(this._hideHatBtn.selected);
      }
      
      private function __hideGlassClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.playerInfo.setGlassHide(this._hideGlassBtn.selected);
      }
      
      private function __onClick(event:MouseEvent) : void
      {
         var cell:TryonCell = null;
         SoundManager.instance.play("008");
         for each(cell in this._cells)
         {
            cell.selected = false;
         }
         TryonCell(event.currentTarget).selected = true;
         this._model.selectedItem = TryonCell(event.currentTarget).info as InventoryItemInfo;
         if(Boolean(this._effect))
         {
            this._effect.play();
         }
      }
      
      public function dispose() : void
      {
         var cell:TryonCell = null;
         var cell1:PersonalInfoCell = null;
         this.removeEvents();
         for each(cell in this._cells)
         {
            cell.removeEventListener(MouseEvent.CLICK,this.__onClick);
            cell.dispose();
         }
         this._cells = null;
         for each(cell1 in this._bagCells)
         {
            cell1.dispose();
         }
         this._bagCells = null;
         if(Boolean(this._effect))
         {
            if(Boolean(this._effect.parent))
            {
               this._effect.parent.removeChild(this._effect);
            }
            this._effect = null;
         }
         this._bg1.dispose();
         this._bg1 = null;
         this._bg.dispose();
         this._bg = null;
         ObjectUtils.disposeObject(this._tryTxt);
         this._tryTxt = null;
         ObjectUtils.disposeObject(this._hideTxt);
         this._hideTxt = null;
         ObjectUtils.disposeObject(this._hideGlassBtn);
         this._hideGlassBtn = null;
         ObjectUtils.disposeObject(this._hideSuitBtn);
         this._hideSuitBtn = null;
         ObjectUtils.disposeObject(this._hideWingBtn);
         this._hideWingBtn = null;
         ObjectUtils.disposeObject(this._nickName);
         this._nickName = null;
         this._character.dispose();
         this._character = null;
         this._itemList.dispose();
         this._itemList = null;
         this._bagItems = null;
         this._model = null;
         this._controller = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

