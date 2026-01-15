package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class ExpFightExpItem extends Sprite implements Disposeable
   {
      
      protected var _bg:Bitmap;
      
      protected var _titleBitmap:Bitmap;
      
      protected var _itemType:String;
      
      protected var _typeTxts:Vector.<ExpTypeTxt>;
      
      protected var _numTxt:ExpCountingTxt;
      
      protected var _step:int;
      
      protected var _value:Number;
      
      protected var _valueArr:Array;
      
      public function ExpFightExpItem(arr:Array)
      {
         super();
         this._valueArr = arr;
         this.init();
      }
      
      protected function init() : void
      {
         this._itemType = ExpTypeTxt.FIGHTING_EXP;
         PositionUtils.setPos(this,"experience.FightingExpItemPos");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.experience.fightExpItemBg");
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.experience.fightExpItemTitle");
      }
      
      public function createView() : void
      {
         var txtPos:Point = null;
         var k:int = 0;
         txtPos = ComponentFactory.Instance.creatCustomObject("experience.txtStartPos");
         var txtOffset:Point = ComponentFactory.Instance.creatCustomObject("experience.txtOffset");
         PositionUtils.setPos(this._bg,"experience.ItemBgPos");
         this._typeTxts = new Vector.<ExpTypeTxt>();
         addChild(this._bg);
         addChild(this._titleBitmap);
         this._step = 0;
         k = 0;
         var len:int = this._itemType == ExpTypeTxt.FIGHTING_EXP ? 4 : (this._itemType == ExpTypeTxt.ATTATCH_EXP ? 9 : 6);
         for(var i:int = 0; i < len; i++)
         {
            this._typeTxts.push(new ExpTypeTxt(this._itemType,i,this._valueArr[i]));
            if(k % 2 == 0 && k != 8)
            {
               this._typeTxts[k].y = txtPos.y = txtPos.y + txtOffset.y;
            }
            else
            {
               this._typeTxts[k].y = txtPos.y;
               this._typeTxts[k].x = txtPos.x + txtOffset.x;
            }
            this._typeTxts[k].addEventListener(Event.CHANGE,this.__updateText);
            addChild(this._typeTxts[k]);
            k++;
         }
         this.createNumTxt();
      }
      
      protected function createNumTxt() : void
      {
         this._numTxt = new ExpCountingTxt("experience.expCountTxt","experience.expTxtFilter_1,experience.expTxtFilter_2");
         this._numTxt.addEventListener(Event.CHANGE,this.__onTextChange);
         addChild(this._numTxt);
      }
      
      private function __updateText(event:Event = null) : void
      {
         this._numTxt.updateNum(event.currentTarget.value);
      }
      
      protected function __onTextChange(event:Event) : void
      {
         this._value = event.currentTarget.targetValue;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get targetValue() : Number
      {
         return this._numTxt.targetValue;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._numTxt))
         {
            this._numTxt.removeEventListener(Event.CHANGE,this.__onTextChange);
            this._numTxt.dispose();
            this._numTxt = null;
         }
         var len:int = int(this._typeTxts.length);
         for(var i:int = 0; i < len; i++)
         {
            this._typeTxts[i].removeEventListener(Event.CHANGE,this.__updateText);
            this._typeTxts[i].dispose();
            this._typeTxts[i] = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._titleBitmap))
         {
            ObjectUtils.disposeObject(this._titleBitmap);
            this._titleBitmap = null;
         }
         this._valueArr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

