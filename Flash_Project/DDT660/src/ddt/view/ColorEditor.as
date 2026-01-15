package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.ColorEnum;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="change",type="flash.events.Event")]
   public class ColorEditor extends Sprite implements Disposeable
   {
      
      public static const REDUCTIVE_COLOR:String = "reductiveColor";
      
      public static const CHANGE_COLOR:String = "change_color";
      
      private var _colors:Array;
      
      private var _skins:Array;
      
      private var _colorsArr:Array;
      
      private var _skinsArr:Array;
      
      private var _colorlist:SimpleTileList;
      
      private var _skincolorlist:SimpleTileList;
      
      private var _colorBtn:SelectedButton;
      
      private var _textureBtn:SelectedButton;
      
      private var _restoreColorBtn:BaseButton;
      
      private var _colorPanelMask:Bitmap;
      
      private var _colorPanelBg:Bitmap;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _ciGroup:SelectedButtonGroup;
      
      private var _siGroup:SelectedButtonGroup;
      
      private var _colorRestorable:Boolean;
      
      private var _skinRestorable:Boolean;
      
      private var _selectedColor:int;
      
      private var _selectedSkin:int;
      
      public function ColorEditor()
      {
         super();
         this._selectedColor = -1;
         this._selectedSkin = -1;
         this._btnGroup = new SelectedButtonGroup();
         this._colorBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ColorBtn");
         this._textureBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.TextureBtn");
         this._restoreColorBtn = ComponentFactory.Instance.creatComponentByStylename("shop.ReductiveColorBtn");
         this._colorPanelBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.ColorChoosePanel");
         this._colorPanelMask = ComponentFactory.Instance.creatBitmap("asset.ddtshop.ColorMask");
         this._colors = ColorEnum.COLORS;
         this._skins = ColorEnum.SKIN_COLORS;
         this._colorsArr = new Array();
         this._skinsArr = new Array();
         this._colorlist = new SimpleTileList(14);
         this._skincolorlist = new SimpleTileList(14);
         this._colorlist.vSpace = this._colorlist.hSpace = this._skincolorlist.vSpace = this._skincolorlist.hSpace = 1;
         this._btnGroup.addSelectItem(this._colorBtn);
         this._btnGroup.addSelectItem(this._textureBtn);
         PositionUtils.setPos(this._colorlist,"shop.ColorPanelPos");
         PositionUtils.setPos(this._skincolorlist,"shop.ColorPanelPos");
         addChild(this._colorPanelBg);
         addChild(this._colorBtn);
         addChild(this._textureBtn);
         addChild(this._restoreColorBtn);
         addChild(this._colorlist);
         addChild(this._skincolorlist);
         this._colorBtn.addEventListener(MouseEvent.CLICK,this.__colorEditClick);
         this._textureBtn.addEventListener(MouseEvent.CLICK,this.__skinEditClick);
         this._restoreColorBtn.addEventListener(MouseEvent.CLICK,this.__restoreColorBtnClick);
         this.colorEditable = true;
         this.skinEditable = false;
         this._ciGroup = new SelectedButtonGroup(true);
         this._siGroup = new SelectedButtonGroup(true);
         this.initColors();
         addChild(this._colorPanelMask);
      }
      
      private function initColors() : void
      {
         var ci:ColorItem = null;
         var si:ColorItem = null;
         for(var i:int = 0; i < this._colors.length; i++)
         {
            ci = ComponentFactory.Instance.creatComponentByStylename("shop.ColorItem");
            ci.setup(this._colors[i]);
            this._colorsArr.push(ci);
            this._colorlist.addChild(ci);
            this._ciGroup.addSelectItem(ci);
            ci.addEventListener(MouseEvent.MOUSE_DOWN,this.__colorItemClick);
         }
         for(var j:int = 0; j < this._skins.length; j++)
         {
            si = ComponentFactory.Instance.creatComponentByStylename("shop.ColorItem");
            si.setup(this._skins[j]);
            this._skinsArr.push(si);
            this._skincolorlist.addChild(si);
            this._siGroup.addSelectItem(si);
            si.addEventListener(MouseEvent.MOUSE_DOWN,this.__skinItemClick);
         }
      }
      
      public function reset() : void
      {
         this._selectedColor = -1;
         this._selectedSkin = -1;
         this._ciGroup.selectIndex = -1;
         this._siGroup.selectIndex = -1;
         this._colorRestorable = false;
         this._skinRestorable = false;
      }
      
      public function get colorRestorable() : Boolean
      {
         return this._colorRestorable;
      }
      
      public function set colorRestorable(value:Boolean) : void
      {
         this._colorRestorable = value;
         if(this.colorEditable && this.selectedType == 1)
         {
            this._restoreColorBtn.enable = this._colorRestorable;
         }
      }
      
      public function get skinRestorable() : Boolean
      {
         return this._skinRestorable;
      }
      
      public function set skinRestorable(value:Boolean) : void
      {
         this._skinRestorable = value;
         if(this.skinEditable && this.selectedType == 2)
         {
            this._restoreColorBtn.enable = this._skinRestorable;
         }
      }
      
      public function set restorable(value:Boolean) : void
      {
         this._restoreColorBtn.visible = value;
      }
      
      public function get colorEditable() : Boolean
      {
         return this._colorBtn.enable;
      }
      
      public function set colorEditable(value:Boolean) : void
      {
         if(this._colorBtn.enable != value)
         {
            this._colorBtn.enable = value;
            if(!value && this._colorlist.visible)
            {
               this._colorlist.visible = false;
               this._colorPanelMask.visible = true;
            }
         }
         this.updateReductiveColorBtn();
      }
      
      public function get skinEditable() : Boolean
      {
         return this._textureBtn.enable;
      }
      
      public function set skinEditable(value:Boolean) : void
      {
         if(this._textureBtn.enable != value)
         {
            this._textureBtn.enable = value;
            if(!value && this._skincolorlist.visible)
            {
               this._skincolorlist.visible = false;
               this._colorPanelMask.visible = true;
            }
         }
         this.updateReductiveColorBtn();
      }
      
      private function updateReductiveColorBtn() : void
      {
         if(!this.colorEditable && !this.skinEditable)
         {
            this._restoreColorBtn.enable = false;
         }
         else
         {
            this._restoreColorBtn.enable = true;
         }
      }
      
      public function editColor(color:int = -1) : void
      {
         if(this.colorEditable)
         {
            this.selectedColor = color;
            this._colorlist.visible = true;
            this._restoreColorBtn.enable = this._selectedColor != -1 || this._colorRestorable;
            this._skincolorlist.visible = false;
            this._colorPanelMask.visible = false;
            if(color == -1)
            {
               this._ciGroup.selectIndex = -1;
            }
         }
      }
      
      public function editSkin(skin:int = -1) : void
      {
         if(this.skinEditable)
         {
            this.selectedSkin = skin;
            this._colorlist.visible = false;
            this._restoreColorBtn.enable = this._selectedSkin != -1 || this._skinRestorable;
            this._skincolorlist.visible = true;
            this._colorPanelMask.visible = false;
            if(skin == -1)
            {
               this._siGroup.selectIndex = -1;
            }
         }
      }
      
      public function get selectedType() : int
      {
         return this._btnGroup.selectIndex + 1;
      }
      
      public function set selectedType(value:int) : void
      {
         this._btnGroup.selectIndex = value - 1;
         if(Boolean(this._btnGroup.selectIndex))
         {
            this.editColor(this.selectedColor);
         }
         else
         {
            this.editSkin(this.selectedSkin);
         }
      }
      
      public function get selectedColor() : int
      {
         return this._selectedColor;
      }
      
      public function set selectedColor(value:int) : void
      {
         if(value != this._selectedColor && this.colorEditable)
         {
            this._selectedColor = value;
            this._colorlist.selectedIndex = this._colors.indexOf(value);
            this.updateReductiveColorBtn();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get selectedSkin() : int
      {
         return this._selectedSkin;
      }
      
      public function set selectedSkin(value:int) : void
      {
         if(value != this._selectedSkin && this.skinEditable)
         {
            this._selectedSkin = value;
            this._skincolorlist.selectedIndex = this._skins.indexOf(value);
            this.updateReductiveColorBtn();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function resetColor() : void
      {
         this._selectedColor = -1;
         this._colorRestorable = false;
      }
      
      public function resetSkin() : void
      {
         this._selectedSkin = -1;
         this._skinRestorable = false;
         this._skincolorlist.selectedIndex = this._skins.indexOf(this._selectedSkin);
      }
      
      private function __colorItemClick(event:Event) : void
      {
         SoundManager.instance.play("047");
         var item:ColorItem = event.currentTarget as ColorItem;
         this.selectedColor = item.getColor();
         dispatchEvent(new Event(CHANGE_COLOR));
      }
      
      private function __skinItemClick(event:Event) : void
      {
         SoundManager.instance.play("047");
         var item:ColorItem = event.currentTarget as ColorItem;
         this.selectedSkin = item.getColor();
      }
      
      private function __colorEditClick(event:Event) : void
      {
         SoundManager.instance.play("047");
         this.editColor(this.selectedColor);
      }
      
      private function __skinEditClick(event:Event) : void
      {
         SoundManager.instance.play("047");
         this.editSkin(this.selectedSkin);
      }
      
      protected function __restoreColorBtnClick(event:MouseEvent) : void
      {
         if(this.selectedType == 1)
         {
            this.resetColor();
         }
         else
         {
            this.resetSkin();
         }
         this._restoreColorBtn.enable = false;
         SoundManager.instance.play("008");
         dispatchEvent(new Event(REDUCTIVE_COLOR));
      }
      
      public function dispose() : void
      {
         this._colorBtn.removeEventListener(MouseEvent.CLICK,this.__colorEditClick);
         this._textureBtn.removeEventListener(MouseEvent.CLICK,this.__skinEditClick);
         this._restoreColorBtn.removeEventListener(MouseEvent.CLICK,this.__restoreColorBtnClick);
         this._colorBtn = null;
         this._textureBtn = null;
         this._restoreColorBtn = null;
         for(var i:int = 0; i < this._colors.length; i++)
         {
            this._colorsArr[i].removeEventListener(MouseEvent.MOUSE_DOWN,this.__colorItemClick);
            this._colorsArr[i].dispose();
            this._colorsArr[i] = null;
         }
         for(var j:int = 0; j < this._skinsArr.length; j++)
         {
            this._skinsArr[j].removeEventListener(MouseEvent.MOUSE_DOWN,this.__skinItemClick);
            this._skinsArr[j].dispose();
            this._skinsArr[j] = null;
         }
         if(Boolean(this._colorlist))
         {
            if(Boolean(this._colorlist.parent))
            {
               this._colorlist.parent.removeChild(this._colorlist);
            }
            this._colorlist.disposeAllChildren();
         }
         this._colorlist = null;
         if(Boolean(this._skincolorlist))
         {
            if(Boolean(this._skincolorlist.parent))
            {
               this._skincolorlist.parent.removeChild(this._skincolorlist);
            }
            this._skincolorlist.disposeAllChildren();
         }
         this._skincolorlist = null;
         this._colors = null;
         this._skins = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

