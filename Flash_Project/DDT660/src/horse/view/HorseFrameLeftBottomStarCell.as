package horse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import horse.HorseManager;
   import horse.data.HorseTemplateVo;
   import road7th.utils.MovieClipWrapper;
   
   public class HorseFrameLeftBottomStarCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _bg2:Bitmap;
      
      private var _normalMc:MovieClip;
      
      private var _level:int;
      
      private var _isOpen:Boolean = false;
      
      private var _skillCell:HorseSkillCell;
      
      public function HorseFrameLeftBottomStarCell()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.horse.frame.starBg");
         this._bg2 = ComponentFactory.Instance.creatBitmap("asset.horse.frame.starBg2");
         this._normalMc = ComponentFactory.Instance.creat("asset.horse.frame.starMc");
         this._normalMc.mouseChildren = false;
         this._normalMc.mouseEnabled = false;
         this._normalMc.gotoAndStop(2);
         addChild(this._bg);
         addChild(this._bg2);
         addChild(this._normalMc);
      }
      
      public function refreshView(index:int, curLevel:int) : void
      {
         this._level = index;
         ObjectUtils.disposeObject(this._skillCell);
         this._skillCell = null;
         var tmp:HorseTemplateVo = HorseManager.instance.getHorseTemplateInfoByLevel(this._level);
         if(Boolean(tmp))
         {
            if(tmp.SkillID > 0)
            {
               this._bg.visible = false;
               this._bg2.visible = true;
               this._skillCell = new HorseSkillCell(tmp.SkillID);
               this._skillCell.scaleX = this._bg2.width / this._skillCell.width;
               this._skillCell.scaleY = this._bg2.height / this._skillCell.height;
               this._skillCell.alpha = 0;
               addChild(this._skillCell);
            }
            else
            {
               this._bg.visible = true;
               this._bg2.visible = false;
            }
            if(this._level <= curLevel)
            {
               if(!this._isOpen)
               {
                  this.openHandler();
               }
            }
            else
            {
               this._normalMc.gotoAndStop(2);
               this._isOpen = false;
            }
         }
         else
         {
            this._bg.visible = true;
            this._bg2.visible = false;
            this._normalMc.gotoAndStop(2);
            this._isOpen = false;
         }
      }
      
      private function openHandler() : void
      {
         var openMc:MovieClip = null;
         openMc = ComponentFactory.Instance.creat("asset.horse.frame.starOpenMc");
         openMc.mouseEnabled = false;
         openMc.mouseChildren = false;
         addChild(openMc);
         var tmp:MovieClipWrapper = new MovieClipWrapper(openMc,true,true);
         tmp.addEventListener(Event.COMPLETE,this.playEndHandler);
      }
      
      private function playEndHandler(event:Event) : void
      {
         var tmp:MovieClipWrapper = event.currentTarget as MovieClipWrapper;
         tmp.removeEventListener(Event.COMPLETE,this.playEndHandler);
         if(Boolean(this._normalMc))
         {
            this._normalMc.gotoAndStop(1);
         }
         this._isOpen = true;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._normalMc))
         {
            this._normalMc.gotoAndStop(2);
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._bg2 = null;
         this._normalMc = null;
         this._skillCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

