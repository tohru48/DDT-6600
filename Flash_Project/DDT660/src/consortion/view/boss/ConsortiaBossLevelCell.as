package consortion.view.boss
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortiaBossLevelCell extends Sprite implements Disposeable
   {
      
      private var _txt:FilterFrameText;
      
      private var _light:Bitmap;
      
      private var _level:int;
      
      public function ConsortiaBossLevelCell(level:int, txtStr:String)
      {
         super();
         this._level = level;
         this.buttonMode = true;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.levelShowTxt");
         PositionUtils.setPos(this._txt,"consortiaBoss.levelView.cellTxtPos");
         this._txt.text = LanguageMgr.GetTranslation(txtStr,this._level);
         addChild(this._txt);
         this._light = ComponentFactory.Instance.creatBitmap("asset.consortionBossFrame.levelCellLight");
         this._light.visible = false;
         addChild(this._light);
         addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.outHandler,false,0,true);
      }
      
      public function judgeMaxLevel(maxLevel:int) : void
      {
         if(this._level > maxLevel)
         {
            this.mouseEnabled = false;
            this._txt.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function changeLightSizePos(width:int, height:int, x:int, y:int) : void
      {
         this._light.width = width;
         this._light.height = height;
         this._light.x = x;
         this._light.y = y;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         this._light.visible = false;
      }
      
      public function dispose() : void
      {
      }
   }
}

