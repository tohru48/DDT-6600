package foodActivity.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import foodActivity.FoodActivityManager;
   
   public class FoodActivityEnterIcon extends Sprite implements Disposeable
   {
      
      private var _foodActivityIcon:MovieImage;
      
      private var _foodActivityTxt:FilterFrameText;
      
      private var _timeBg:Bitmap;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timeSp:Sprite;
      
      private var _minutesArr:Array;
      
      public function FoodActivityEnterIcon()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._foodActivityIcon = ComponentFactory.Instance.creat("hall.foodActivityBtn");
         this._foodActivityIcon.buttonMode = true;
         addChild(this._foodActivityIcon);
         this._foodActivityTxt = ComponentFactory.Instance.creatComponentByStylename("hall.foodActivity.countTxt");
         this._foodActivityTxt.x = 43;
         this._foodActivityTxt.y = 7;
         this._foodActivityTxt.text = "" + FoodActivityManager.Instance.cookingCount;
         addChild(this._foodActivityTxt);
         this._timeSp = new Sprite();
         this._timeBg = ComponentFactory.Instance.creatBitmap("foodActivity.timeBGAsset");
         this._timeTxt = ComponentFactory.Instance.creat("foodActivity.TimeBoxStyle");
         this._timeTxt.x = this._timeBg.x + (this._timeBg.width - this._timeTxt.width) / 2 + 8;
         this._timeTxt.y = this._timeBg.y + 3;
         this._timeSp.addChild(this._timeBg);
         this._timeSp.addChild(this._timeTxt);
         addChild(this._timeSp);
         this._timeSp.visible = false;
      }
      
      public function showTxt() : void
      {
         var temp:Array = FoodActivityManager.Instance.info.remain2.split("|");
         this._minutesArr = new Array();
         for(var i:int = 0; i < temp.length; i++)
         {
            this._minutesArr.push(temp[i].split(",")[0]);
         }
         if(FoodActivityManager.Instance.cookingCount == 0 && FoodActivityManager.Instance.state == 0)
         {
            FoodActivityManager.Instance.startTime();
         }
         else
         {
            FoodActivityManager.Instance.endTime();
         }
      }
      
      public function set text(value:String) : void
      {
         this._foodActivityTxt.text = value;
      }
      
      public function startTime(isUpdateCount:Boolean = false) : void
      {
         var minutes:int = 0;
         var i:int = 0;
         this._timeSp.visible = true;
         if(FoodActivityManager.Instance.sumTime > 0)
         {
            this.updateTime();
            return;
         }
         if(isUpdateCount)
         {
            minutes = FoodActivityManager.Instance.delayTime;
         }
         else
         {
            for(i = 0; i < this._minutesArr.length; i++)
            {
               if(FoodActivityManager.Instance.currentSumTime < this._minutesArr[i])
               {
                  minutes = this._minutesArr[i] - FoodActivityManager.Instance.currentSumTime;
                  break;
               }
            }
         }
         if(minutes == 0)
         {
            FoodActivityManager.Instance.endTime();
            return;
         }
         FoodActivityManager.Instance.sumTime = minutes * 60;
         this.updateTime();
      }
      
      public function updateTime() : void
      {
         var _minute:int = FoodActivityManager.Instance.sumTime / 60;
         var _second:int = FoodActivityManager.Instance.sumTime % 60;
         var str:String = "";
         if(_minute < 10)
         {
            str += "0" + _minute;
         }
         else
         {
            str += _minute;
         }
         str += ":";
         if(_second < 10)
         {
            str += "0" + _second;
         }
         else
         {
            str += _second;
         }
         this._timeTxt.text = str;
      }
      
      public function endTime() : void
      {
         this._timeSp.visible = false;
      }
      
      protected function __showFoodActivityFrame(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         FoodActivityManager.Instance.openFrame();
      }
      
      private function initEvent() : void
      {
         this._foodActivityIcon.addEventListener(MouseEvent.CLICK,this.__showFoodActivityFrame);
      }
      
      private function removeEvent() : void
      {
         this._foodActivityIcon.removeEventListener(MouseEvent.CLICK,this.__showFoodActivityFrame);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._foodActivityIcon);
         this._foodActivityIcon = null;
         ObjectUtils.disposeObject(this._foodActivityTxt);
         this._foodActivityTxt = null;
         ObjectUtils.disposeObject(this._timeBg);
         this._timeBg = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._timeSp);
         this._timeSp = null;
      }
   }
}

