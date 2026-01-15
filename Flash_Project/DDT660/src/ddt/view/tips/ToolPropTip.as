package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ToolPropTip extends BaseTip
   {
      
      private var _info:ItemTemplateInfo;
      
      private var _count:int = 0;
      
      private var _showTurn:Boolean;
      
      private var _showCount:Boolean;
      
      private var _showThew:Boolean;
      
      private var _bg:ScaleBitmapImage;
      
      private var context:TextField;
      
      private var thew_txt:FilterFrameText;
      
      private var turn_txt:FilterFrameText;
      
      private var description_txt:FilterFrameText;
      
      private var name_txt:FilterFrameText;
      
      private var _tempData:Object;
      
      private var f:TextFormat = new TextFormat(null,13,16777215);
      
      private var _container:Sprite;
      
      public function ToolPropTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.name_txt = ComponentFactory.Instance.creat("core.ToolNameTxt");
         this.thew_txt = ComponentFactory.Instance.creat("core.ToolThewTxt");
         this.description_txt = ComponentFactory.Instance.creat("core.ToolDescribeTxt");
         this.turn_txt = ComponentFactory.Instance.creat("core.ToolGoldTxt");
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._container = new Sprite();
         this._container.addChild(this.thew_txt);
         this._container.addChild(this.turn_txt);
         this._container.addChild(this.description_txt);
         this._container.addChild(this.name_txt);
         super.init();
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(data is ToolPropInfo)
         {
            this.visible = true;
            this.update(data.showTurn,data.showCount,data.showThew,data.valueType,data.info,data.count,data.shortcutKey);
         }
         else
         {
            this.visible = false;
         }
         this._tempData = data;
      }
      
      public function changeStyle(info:ItemTemplateInfo, $width:int, $wordWrap:Boolean = true) : void
      {
         this.thew_txt.width = this.turn_txt.width = this.description_txt.width = this.name_txt.width = 0;
         this.thew_txt.y = this.turn_txt.y = this.description_txt.y = this.name_txt.y = 0;
         this.thew_txt.text = this.turn_txt.text = this.description_txt.text = this.name_txt.text = "";
         if(!this.context)
         {
            this.context = new TextField();
            this.context.width = $width - 2;
            this.context.autoSize = TextFieldAutoSize.CENTER;
            this._container.addChild(this.context);
            this.context = new TextField();
            this.context.width = $width - 2;
            if($wordWrap)
            {
               this.context.wordWrap = true;
               this.context.autoSize = TextFieldAutoSize.LEFT;
               this.context.x = 2;
               this.context.y = 2;
            }
            else
            {
               this.context.wordWrap = false;
               this.context.autoSize = TextFieldAutoSize.CENTER;
               this.context.y = 4;
            }
            this._container.addChild(this.context);
         }
         this._info = info;
         if(Boolean(this._info))
         {
            this.context.text = this._info.Description;
         }
         this.context.setTextFormat(this.f);
         this._bg.height = 0;
         this.drawBG($width);
      }
      
      private function update(showPrice:Boolean, showCount:Boolean, showThew:Boolean, valueType:String, info:ItemTemplateInfo, count:int, key:String) : void
      {
         this._showCount = showCount;
         this._showTurn = showPrice;
         this._showThew = showThew;
         this._info = info;
         this._count = count;
         this.name_txt.autoSize = TextFieldAutoSize.LEFT;
         if(this._showCount)
         {
            if(this._count > 1)
            {
               this.name_txt.text = String(this._info.Name) + "(" + String(this._count) + ")";
            }
            else if(this._count == -1)
            {
               this.name_txt.text = String(this._info.Name) + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.infinity");
            }
            else
            {
               this.name_txt.text = String(this._info.Name);
            }
         }
         else
         {
            this.name_txt.text = String(this._info.Name);
         }
         if(Boolean(key))
         {
            this.name_txt.text += " [" + key.toLocaleUpperCase() + "]";
         }
         if(this._showThew)
         {
            if(valueType == ToolPropInfo.Psychic)
            {
               this.thew_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip." + valueType,String(this._info.Property7));
            }
            else if(valueType == ToolPropInfo.Energy)
            {
               this.thew_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip." + valueType,String(this._info.Property4));
            }
            else if(valueType == ToolPropInfo.MP)
            {
               this.thew_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip." + valueType,String(this._info.Property4));
            }
            else
            {
               this.thew_txt.text = "";
            }
            this.description_txt.y = this.thew_txt.y + this.thew_txt.height;
            this.thew_txt.visible = true;
         }
         else
         {
            this.thew_txt.visible = false;
            this.description_txt.y = this.thew_txt.y;
         }
         this.description_txt.autoSize = TextFieldAutoSize.NONE;
         this.description_txt.width = 150;
         this.description_txt.wordWrap = true;
         this.description_txt.autoSize = TextFieldAutoSize.LEFT;
         this.description_txt.htmlText = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.Description",this._info.Description);
         if(this._showTurn)
         {
            this.turn_txt.visible = true;
            this.turn_txt.y = this.description_txt.y + this.description_txt.height + 5;
            this.turn_txt.text = LanguageMgr.GetTranslation("tank.game.actions.cooldown") + ": " + this._info.Property1 + LanguageMgr.GetTranslation("tank.game.actions.turn");
         }
         else
         {
            this.turn_txt.visible = false;
            this.turn_txt.y = 0;
         }
         this.drawBG();
      }
      
      private function reset() : void
      {
         this._bg.height = 0;
         this._bg.width = 0;
      }
      
      private function drawBG($width:int = 0) : void
      {
         this.reset();
         if($width == 0)
         {
            this._bg.width = this._container.width + 10;
            this._bg.height = this._container.height + 6;
         }
         else
         {
            this._bg.width = $width + 2;
            this._bg.height = this._container.height + 5;
         }
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.context) && Boolean(this.context.parent))
         {
            this.context.parent.removeChild(this.context);
         }
         this.context = null;
         this._info = null;
         ObjectUtils.disposeObject(this.thew_txt);
         this.thew_txt = null;
         ObjectUtils.disposeObject(this.turn_txt);
         this.turn_txt = null;
         ObjectUtils.disposeObject(this.description_txt);
         this.description_txt = null;
         ObjectUtils.disposeObject(this.name_txt);
         this.name_txt = null;
         ObjectUtils.disposeObject(this);
      }
   }
}

