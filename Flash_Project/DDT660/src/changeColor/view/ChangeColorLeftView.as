package changeColor.view
{
   import bagAndInfo.cell.BagCell;
   import changeColor.ChangeColorModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.ColorEditor;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import road7th.utils.StringHelper;
   
   public class ChangeColorLeftView extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _charaterBack:MovieImage;
      
      private var _charaterBack1:MovieImage;
      
      private var _controlBack:MovieImage;
      
      private var _title:DisplayObject;
      
      private var _charater:ICharacter;
      
      private var _hideHat:SelectedCheckButton;
      
      private var _hideGlass:SelectedCheckButton;
      
      private var _hideSuit:SelectedCheckButton;
      
      private var _hideWing:SelectedCheckButton;
      
      private var _cell:ColorEditCell;
      
      private var _cellBg:Scale9CornerImage;
      
      private var _colorEditor:ColorEditor;
      
      private var _model:ChangeColorModel;
      
      private var _checkBg:MovieImage;
      
      private var _itemChanged:Boolean;
      
      public function ChangeColorLeftView()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._charaterBack = null;
         this._controlBack = null;
         this._cell = null;
         this._charater = null;
         this._colorEditor = null;
         this._model = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function set model(value:ChangeColorModel) : void
      {
         this._model = value;
         this.dataUpdate();
      }
      
      public function reset() : void
      {
         if(this._model.currentItem == null)
         {
            return;
         }
         this.restoreItem();
         this.restoreCharacter();
         this._model.changed = false;
         this._model.currentItem = null;
      }
      
      public function setCurrentItem(cell:BagCell) : void
      {
         SoundManager.instance.play("008");
         if(this._cell.bagCell != null || cell.info == null)
         {
            this._model.initColor = null;
            this._model.initSkinColor = null;
            if(Boolean(this._cell.bagCell))
            {
               this._cell.bagCell.locked = false;
            }
         }
         this._cell.bagCell = cell;
         cell.locked = true;
         this.updateColorPanel();
      }
      
      private function __cellChangedHandler(evt:Event) : void
      {
         if(Boolean((evt.target as BagCell).info) && this._model.currentItem == null)
         {
            this._model.currentItem = this._cell.bagCell.itemInfo;
            this.savaItemInfo();
            this.updateCharator();
         }
         else if((evt.target as BagCell).info == null)
         {
            this.reset();
         }
         this.updateColorPanel();
      }
      
      private function __hideGalssChange(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.self.setGlassHide(this._hideGlass.selected);
      }
      
      private function __hideHatChange(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.self.setHatHide(this._hideHat.selected);
      }
      
      private function __hideSuitChange(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.self.setSuiteHide(this._hideSuit.selected);
      }
      
      private function __hideWingChange(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.self.wingHide = this._hideWing.selected;
      }
      
      private function __setColor(evt:Event) : void
      {
         if(Boolean(this._model.currentItem))
         {
            if(this._colorEditor.selectedType == 2)
            {
               this.setItemSkin(this._model.currentItem,this._colorEditor.selectedSkin.toString());
            }
            else
            {
               this.setItemColor(this._model.currentItem,this._colorEditor.selectedColor.toString());
            }
            this._model.changed = true;
         }
      }
      
      private function dataUpdate() : void
      {
         this.initView();
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this._cell.addEventListener(Event.CHANGE,this.__cellChangedHandler);
         this._colorEditor.addEventListener(Event.CHANGE,this.__setColor);
         this._colorEditor.addEventListener(ColorEditor.REDUCTIVE_COLOR,this.__reductiveColor);
         this._hideHat.addEventListener(MouseEvent.CLICK,this.__hideHatChange);
         this._hideGlass.addEventListener(MouseEvent.CLICK,this.__hideGalssChange);
         this._hideSuit.addEventListener(MouseEvent.CLICK,this.__hideSuitChange);
         this._hideWing.addEventListener(MouseEvent.CLICK,this.__hideWingChange);
      }
      
      private function initView() : void
      {
         var rec:Rectangle = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("changeColor.rightViewBg");
         addChild(this._bg);
         this._charaterBack = ComponentFactory.Instance.creatComponentByStylename("changeColor.leftViewBg");
         addChild(this._charaterBack);
         this._charaterBack1 = ComponentFactory.Instance.creatComponentByStylename("changeColor.leftViewBg2");
         addChild(this._charaterBack1);
         this._controlBack = ComponentFactory.Instance.creatComponentByStylename("changeColor.leftViewBg1");
         addChild(this._controlBack);
         this._checkBg = ComponentFactory.Instance.creatComponentByStylename("changeColor.checkBg");
         addChild(this._checkBg);
         this._title = ComponentFactory.Instance.creatBitmap("asset.changeColor.title");
         addChild(this._title);
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.leftViewBgImgRec");
         ObjectUtils.copyPropertyByRectangle(this._bg,rec);
         this._charater = CharactoryFactory.createCharacter(this._model.self);
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.charaterRec");
         ObjectUtils.copyPropertyByRectangle(this._charater as DisplayObject,rec);
         this._charater.show(false,-1);
         this._charater.showGun = false;
         addChild(this._charater as DisplayObject);
         this._cellBg = ComponentFactory.Instance.creatComponentByStylename("ColorEditCell.Bg");
         addChild(this._cellBg);
         var colorCell:Sprite = new Sprite();
         colorCell.graphics.beginFill(0,0);
         colorCell.graphics.drawRect(0,0,90,90);
         colorCell.graphics.endFill();
         this._cell = new ColorEditCell(colorCell);
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.colorEditCellRec");
         ObjectUtils.copyPropertyByRectangle(this._cell as DisplayObject,rec);
         addChild(this._cell);
         this._colorEditor = ComponentFactory.Instance.creatCustomObject("changeColor.ColorEdit");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.colorEditorRec");
         ObjectUtils.copyPropertyByRectangle(this._colorEditor as DisplayObject,rec);
         addChild(this._colorEditor);
         this._hideHat = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.hideHatRec");
         ObjectUtils.copyPropertyByRectangle(this._hideHat as DisplayObject,rec);
         this._hideHat.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
         this._hideHat.selected = this._model.self.getHatHide();
         addChild(this._hideHat);
         this._hideGlass = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.hideGlassRec");
         ObjectUtils.copyPropertyByRectangle(this._hideGlass as DisplayObject,rec);
         this._hideGlass.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
         this._hideGlass.selected = this._model.self.getGlassHide();
         addChild(this._hideGlass);
         this._hideSuit = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.hideSuitRec");
         ObjectUtils.copyPropertyByRectangle(this._hideSuit as DisplayObject,rec);
         this._hideSuit.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
         this._hideSuit.selected = this._model.self.getSuitesHide();
         addChild(this._hideSuit);
         this._hideWing = ComponentFactory.Instance.creatComponentByStylename("personanHideWingCheckBox");
         rec = ComponentFactory.Instance.creatCustomObject("changeColor.hideWingRec");
         ObjectUtils.copyPropertyByRectangle(this._hideWing as DisplayObject,rec);
         this._hideWing.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
         this._hideWing.selected = this._model.self.wingHide;
         addChild(this._hideWing);
         this.updateColorPanel();
      }
      
      private function removeEvents() : void
      {
         this._cell.removeEventListener(Event.CHANGE,this.__cellChangedHandler);
         this._colorEditor.removeEventListener(Event.CHANGE,this.__setColor);
         this._colorEditor.removeEventListener(ColorEditor.REDUCTIVE_COLOR,this.__reductiveColor);
      }
      
      private function restoreCharacter() : void
      {
         this._model.self.setPartStyle(this._model.currentItem.CategoryID,this._model.self.Sex ? 1 : 2,PlayerManager.Instance.Self.getPartStyle(this._model.currentItem.CategoryID),PlayerManager.Instance.Self.getPartColor(this._model.currentItem.CategoryID),true);
         this._model.self.setPartColor(this._model.currentItem.CategoryID,PlayerManager.Instance.Self.getPartColor(this._model.currentItem.CategoryID));
         this._model.self.setSkinColor(PlayerManager.Instance.Self.Skin);
      }
      
      private function restoreItem() : void
      {
         this._model.restoreItem();
      }
      
      private function savaItemInfo() : void
      {
         this._model.savaItemInfo();
      }
      
      private function setItemColor(item:InventoryItemInfo, color:String) : void
      {
         if(item.Color == "||")
         {
            item.Color = "";
         }
         var _temp:Array = item.Color.split("|");
         _temp[this._cell.editLayer - 1] = String(color);
         var tempColor_1:String = _temp.join("|").replace(/\|$/,"");
         item.Color = tempColor_1;
         this._cell.setColor(tempColor_1);
         this._model.self.setPartColor(this._model.currentItem.CategoryID,tempColor_1);
         this._model.self.setSkinColor(this._model.self.getSkinColor());
      }
      
      private function setItemSkin(item:InventoryItemInfo, color:String) : void
      {
         var temp:Array = item.Color.split("|");
         temp[1] = color;
         var tempColor:String = temp.join("|");
         item.Skin = color;
         this._model.self.setSkinColor(color);
      }
      
      public function setInitColor() : void
      {
         this._model.self.setPartColor(this._model.currentItem.CategoryID,this._model.initColor);
         this._cell.itemInfo.Color = this._model.initColor;
      }
      
      public function setInitSkinColor() : void
      {
         this._model.self.setSkinColor(this._model.initSkinColor);
         this._cell.itemInfo.Skin = this._model.initSkinColor;
      }
      
      private function checkColorChanged(initColor:String, nowColor:String) : Boolean
      {
         var b1:Boolean = false;
         var b2:Boolean = false;
         var temp1:Array = initColor.split("|");
         var temp2:Array = nowColor.split("|");
         var count:int = Math.max(temp1.length,temp2.length);
         for(var i:int = 0; i < count; i++)
         {
            b1 = !StringHelper.isNullOrEmpty(temp1[i]) && temp1[i] != "undefined";
            b2 = !StringHelper.isNullOrEmpty(temp2[i]) && temp2[i] != "undefined";
            if((b1 || b2) && temp1[i] != temp2[i])
            {
               return true;
            }
         }
         return false;
      }
      
      protected function __reductiveColor(event:Event) : void
      {
         var bool1:Boolean = false;
         var bool2:Boolean = false;
         if(this._colorEditor.selectedType == 1)
         {
            this.setItemColor(this._model.currentItem,"");
         }
         else
         {
            this.setItemSkin(this._model.currentItem,"");
         }
         if(Boolean(this._cell.info))
         {
            bool1 = this.checkColorChanged(this._model.initColor,this._cell.itemInfo.Color);
            bool2 = this.checkColorChanged(this._model.initSkinColor,this._cell.itemInfo.Skin);
            if(bool1 || bool2)
            {
               this._model.changed = true;
            }
            else
            {
               this._model.changed = false;
            }
         }
         else
         {
            this._model.changed = false;
         }
      }
      
      private function updateCharator() : void
      {
         this._model.self.setPartStyle(this._model.currentItem.CategoryID,this._model.currentItem.NeedSex,this._model.currentItem.TemplateID,this._model.currentItem.Color);
         if(this._model.currentItem.CategoryID == EquipType.FACE || this._model.currentItem.Skin != "")
         {
            this._model.self.setSkinColor(this._cell.bagCell.itemInfo.Skin);
         }
         else
         {
            this._model.self.setSkinColor(this._model.self.getSkinColor());
         }
      }
      
      private function updateColorPanel() : void
      {
         var _temp:Array = null;
         if(this._cell.info == null)
         {
            this._colorEditor.skinEditable = false;
            this._colorEditor.colorEditable = false;
         }
         else
         {
            this._colorEditor.reset();
            _temp = this._cell.itemInfo.Color.split("|");
            this._colorEditor.colorRestorable = _temp.length > this._cell.editLayer - 1 && !StringHelper.isNullOrEmpty(_temp[this._cell.editLayer - 1]) && _temp[this._cell.editLayer - 1] != "undefined";
            this._colorEditor.skinRestorable = !StringHelper.isNullOrEmpty(this._cell.itemInfo.Skin) && this._cell.itemInfo.Skin != "undefined";
            this._itemChanged = this._colorEditor.colorRestorable || this._colorEditor.skinRestorable;
            if(this._cell.info.CategoryID == EquipType.FACE)
            {
               if(EquipType.isEditable(this._cell.info))
               {
                  this._colorEditor.colorEditable = true;
               }
               this._colorEditor.skinEditable = true;
            }
            else
            {
               this._colorEditor.colorEditable = true;
            }
            this._colorEditor.editColor();
            if(!this._model.initColor)
            {
               this._model.initColor = this._cell.itemInfo.Color;
            }
            if(!this._model.initSkinColor)
            {
               this._model.initSkinColor = this._cell.itemInfo.Skin;
            }
            if(this._colorEditor.selectedType == 2)
            {
               this._colorEditor.editSkin();
            }
         }
         if(this._colorEditor.skinEditable == false)
         {
            this._colorEditor.selectedType = 1;
         }
         if(!this._colorEditor.colorEditable && this._colorEditor.skinEditable)
         {
            this._colorEditor.selectedType = 2;
         }
      }
   }
}

