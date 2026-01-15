package fightLib.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class FightLibAwardView extends Component implements Disposeable
   {
      
      private static const P_backColor:String = "P_backColor";
      
      private static const ColumnCount:int = 5;
      
      private var _gift:int;
      
      private var _exp:int;
      
      private var _medal:int;
      
      private var _items:Array;
      
      private var _awardTextField:FilterFrameText;
      
      private var _backColor:int = 0;
      
      private var _hasGeted:Boolean = false;
      
      private var _list:SimpleTileList;
      
      private var _scrollPane:ScrollPanel;
      
      private var _title:Bitmap;
      
      private var _geted:Bitmap;
      
      private var _maskShape:Sprite;
      
      private var _TipsText:Bitmap;
      
      private var _cells:Array = [];
      
      public function FightLibAwardView()
      {
         super();
      }
      
      public function set backColor(val:int) : void
      {
         this._backColor = val;
         onPropertiesChanged(P_backColor);
      }
      
      public function get backColor() : int
      {
         return this._backColor;
      }
      
      override public function draw() : void
      {
         super.draw();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._awardTextField))
         {
            ObjectUtils.disposeObject(this._awardTextField);
            this._awardTextField = null;
         }
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
            this._list = null;
         }
         if(Boolean(this._scrollPane))
         {
            ObjectUtils.disposeObject(this._scrollPane);
            this._list = null;
         }
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         if(Boolean(this._geted))
         {
            ObjectUtils.disposeObject(this._geted);
            this._geted = null;
         }
         if(Boolean(this._TipsText))
         {
            ObjectUtils.disposeObject(this._TipsText);
            this._TipsText = null;
         }
         super.dispose();
      }
      
      override protected function init() : void
      {
         super.init();
         this._awardTextField = ComponentFactory.Instance.creatComponentByStylename("fightLib.Award.AwardTextField");
         addChild(this._awardTextField);
         this._scrollPane = ComponentFactory.Instance.creatComponentByStylename("fightLib.Award.AwardScrollPanel");
         addChild(this._scrollPane);
         this._list = new SimpleTileList(2);
         this._list.hSpace = 105;
         this._list.vSpace = 23;
         this._scrollPane.setView(this._list);
         this._geted = ComponentFactory.Instance.creatBitmap("fightLib.Award.Geted");
         addChild(this._geted);
         this._title = ComponentFactory.Instance.creatBitmap("fightLib.Award.Title");
         addChild(this._title);
         this._TipsText = ComponentFactory.Instance.creatBitmap("fightLib.Award.TipsText");
         addChild(this._TipsText);
         this._maskShape = new Sprite();
         this._maskShape.graphics.beginFill(0,0.6);
         this._maskShape.graphics.drawRoundRect(5,5,309,323,15,15);
         this._maskShape.graphics.endFill();
         addChild(this._maskShape);
         this._maskShape.visible = false;
      }
      
      private function drawBackground() : void
      {
         var pen:Graphics = graphics;
         pen.clear();
         pen.beginFill(this._backColor,0.4);
         pen.drawRoundRect(0,0,_width <= 0 ? 1 : _width,_height <= 0 ? 1 : _height,4,4);
         pen.endFill();
      }
      
      public function setGiftAndExpNum(giftValue:int, expValue:int, medal:int) : void
      {
         this._gift = giftValue;
         this._exp = expValue;
         this._medal = medal;
         this.updateTxt();
      }
      
      public function setAwardItems(value:Array) : void
      {
         this._items = value;
         this.updateList();
      }
      
      private function updateTxt() : void
      {
         this._awardTextField.text = "";
         if(this._exp > 0)
         {
            this._awardTextField.appendText(LanguageMgr.GetTranslation("exp") + this._exp.toString());
         }
         if(this._gift > 0)
         {
            if(this._exp > 0)
            {
               this._awardTextField.appendText(" ,");
            }
            this._awardTextField.appendText(LanguageMgr.GetTranslation("gift") + this._gift.toString());
         }
      }
      
      private function updateList() : void
      {
         var i:Object = null;
         var item:ItemTemplateInfo = null;
         var cell:AwardCell = this._cells.shift();
         while(cell != null)
         {
            ObjectUtils.disposeObject(cell);
            cell = this._cells.shift();
         }
         var pos:Point = ComponentFactory.Instance.creatCustomObject("fightLib.Award.AwardList.cell.PicPos");
         var size:Point = ComponentFactory.Instance.creatCustomObject("fightLib.Award.AwardList.cell.ContentSize");
         for each(i in this._items)
         {
            item = ItemManager.Instance.getTemplateById(i.id);
            cell = ComponentFactory.Instance.creatCustomObject("fightLib.Award.AwardList.cell");
            cell.info = item;
            cell.count = i.count;
            this._list.addChild(cell);
            this._cells.push(cell);
         }
      }
      
      public function set geted(val:Boolean) : void
      {
         if(this._hasGeted != val)
         {
            this._hasGeted = val;
            this._maskShape.visible = this._geted.visible = this._hasGeted;
         }
      }
      
      public function get geted() : Boolean
      {
         return this._hasGeted;
      }
   }
}

