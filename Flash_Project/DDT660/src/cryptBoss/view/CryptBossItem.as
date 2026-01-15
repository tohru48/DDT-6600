package cryptBoss.view
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import cryptBoss.data.CryptBossItemInfo;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CryptBossItem extends Sprite implements Disposeable
   {
      
      private var _info:CryptBossItemInfo;
      
      private var _iconMovie:MovieClip;
      
      private var _clickSp:Sprite;
      
      private var _lightStarVec:Vector.<Bitmap>;
      
      private var _isOpen:Boolean;
      
      private var _setFrame:CryptBossSetFrame;
      
      public function CryptBossItem(data:CryptBossItemInfo)
      {
         super();
         this._info = data;
         this._lightStarVec = new Vector.<Bitmap>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var posStr:String = null;
         var dis:int = 0;
         var spWidth:int = 0;
         var spHeight:int = 0;
         var star:Bitmap = null;
         var daysArr:Array = this._info.openWeekDaysArr;
         var currentDay:int = TimeManager.Instance.currentDay;
         for(var i:int = 0; i < daysArr.length; i++)
         {
            if(daysArr[i] == currentDay)
            {
               this._isOpen = true;
               break;
            }
         }
         this._iconMovie = ComponentFactory.Instance.creat("asset.cryptBoss.light.icon" + this._info.id);
         this._clickSp = new Sprite();
         if(this._isOpen)
         {
            posStr = "cryptBoss.open.starPos";
            dis = 25;
            spWidth = 166;
            spHeight = 170;
            this._iconMovie.gotoAndStop(2);
            PositionUtils.setPos(this,"cryptBoss.open.itemPos" + this._info.id);
         }
         else
         {
            posStr = "cryptBoss.notOpen.starPos";
            dis = 24;
            spHeight = 100;
            spWidth = 100;
            this._iconMovie.gotoAndStop(1);
            PositionUtils.setPos(this,"cryptBoss.notOpen.itemPos" + this._info.id);
         }
         this._clickSp.graphics.beginFill(16777215,0);
         this._clickSp.graphics.drawRect(0,0,spWidth,spHeight);
         this._clickSp.graphics.endFill();
         this._clickSp.buttonMode = true;
         addChild(this._iconMovie);
         addChild(this._clickSp);
         for(var k:int = 0; k < this._info.star; k++)
         {
            star = ComponentFactory.Instance.creat("asset.cryptBoss.star");
            if(k == 0)
            {
               PositionUtils.setPos(star,posStr);
            }
            else
            {
               star.x += this._lightStarVec[0].x + k * dis;
               star.y = this._lightStarVec[0].y;
            }
            addChild(star);
            this._lightStarVec.push(star);
         }
      }
      
      private function initEvent() : void
      {
         this._clickSp.addEventListener(MouseEvent.CLICK,this.__fightSetHandler);
      }
      
      public function get info() : CryptBossItemInfo
      {
         return this._info;
      }
      
      protected function __fightSetHandler(event:MouseEvent) : void
      {
         if(!this._isOpen)
         {
            return;
         }
         SoundManager.instance.playButtonSound();
         this._setFrame = ComponentFactory.Instance.creatCustomObject("CryptBossSetFrame",[this._info]);
         this._setFrame.addEventListener(ComponentEvent.DISPOSE,this.frameDisposeHandler,false,0,true);
         LayerManager.Instance.addToLayer(this._setFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function frameDisposeHandler(event:ComponentEvent) : void
      {
         if(Boolean(this._setFrame))
         {
            this._setFrame.removeEventListener(ComponentEvent.DISPOSE,this.frameDisposeHandler);
         }
         this._setFrame = null;
      }
      
      private function removeEvent() : void
      {
         this._clickSp.removeEventListener(MouseEvent.CLICK,this.__fightSetHandler);
      }
      
      public function dispose() : void
      {
         var star:Bitmap = null;
         this.removeEvent();
         this._iconMovie.stop();
         removeChild(this._iconMovie);
         this._iconMovie = null;
         for each(star in this._lightStarVec)
         {
            ObjectUtils.disposeObject(star);
            star = null;
         }
         this._clickSp.graphics.clear();
         removeChild(this._clickSp);
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

