package horse.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.utils.MovieClipWrapper;
   
   public class HorseGetSkillView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _skillCell:HorseSkillCell;
      
      public function HorseGetSkillView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.horse.getSkillView.bg");
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("horse.getSkillView.getBtn");
         addChild(this._bg);
         addChild(this._getBtn);
      }
      
      public function show(skillId:int) : void
      {
         var mc1:MovieClip = null;
         mc1 = ComponentFactory.Instance.creat("asset.horse.getSkillView.mc1");
         mc1.mouseChildren = false;
         mc1.mouseEnabled = false;
         mc1.x = 53;
         mc1.y = -104;
         addChild(mc1);
         var mcw:MovieClipWrapper = new MovieClipWrapper(mc1,true,true);
         mcw.addEventListener(Event.COMPLETE,this.completeMc1);
         this._skillCell = new HorseSkillCell(skillId,false);
         if(skillId == 10601)
         {
            this._skillCell.x = 217;
            this._skillCell.y = 63;
         }
         else if(skillId == 11101 || skillId == 11301)
         {
            this._skillCell.x = 219;
            this._skillCell.y = 65;
         }
         else
         {
            this._skillCell.x = 228;
            this._skillCell.y = 72;
         }
         addChild(this._skillCell);
         this.x = 430;
         this.y = 220;
         this.scaleX = 0.3;
         this.scaleY = 0.3;
         this.alpha = 0;
         TweenLite.to(this,0.2,{
            "x":237,
            "y":141,
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         });
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function completeMc1(event:Event) : void
      {
         var mcw:MovieClipWrapper = event.currentTarget as MovieClipWrapper;
         mcw.removeEventListener(Event.COMPLETE,this.completeMc1);
         this._getBtn.addEventListener(MouseEvent.CLICK,this.getClickHandler,false,0,true);
      }
      
      private function getClickHandler(event:MouseEvent) : void
      {
         var mc2:MovieClip = null;
         var tmpPos:Point = null;
         SoundManager.instance.play("008");
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.getClickHandler);
         mc2 = ComponentFactory.Instance.creat("asset.horse.getSkillView.mc2");
         mc2.mouseChildren = false;
         mc2.mouseEnabled = false;
         mc2.x = 84;
         mc2.y = -72;
         addChild(mc2);
         var mcw:MovieClipWrapper = new MovieClipWrapper(mc2,true,true);
         mcw.addEventListener(Event.COMPLETE,this.completeMc2);
         tmpPos = this.localToGlobal(new Point(this._skillCell.x,this._skillCell.y));
         LayerManager.Instance.addToLayer(this._skillCell,LayerManager.STAGE_TOP_LAYER);
         this._skillCell.x = tmpPos.x;
         this._skillCell.y = tmpPos.y;
         TweenLite.to(this,1,{"alpha":0});
         TweenLite.to(this._skillCell,1,{
            "x":this._skillCell.x,
            "y":this._skillCell.y - 3,
            "onComplete":this.skillCellMoveComplete1
         });
      }
      
      private function skillCellMoveComplete1() : void
      {
         TweenLite.to(this._skillCell,0.2,{
            "x":733,
            "y":313,
            "scaleX":0.3,
            "scaleY":0.3,
            "onComplete":this.skillCellMoveComplete2
         });
      }
      
      private function skillCellMoveComplete2() : void
      {
         TweenLite.to(this._skillCell,0.16,{
            "x":730,
            "y":305,
            "scaleX":0.5,
            "scaleY":0.5,
            "onComplete":this.skillCellMoveComplete3
         });
      }
      
      private function skillCellMoveComplete3() : void
      {
         TweenLite.to(this._skillCell,0.16,{
            "alpha":0,
            "onComplete":this.skillCellMoveComplete4
         });
      }
      
      private function skillCellMoveComplete4() : void
      {
         ObjectUtils.disposeObject(this._skillCell);
         this._skillCell = null;
      }
      
      private function completeMc2(event:Event) : void
      {
         var mc3:MovieClip = null;
         var mcw:MovieClipWrapper = event.currentTarget as MovieClipWrapper;
         mcw.removeEventListener(Event.COMPLETE,this.completeMc2);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         mc3 = ComponentFactory.Instance.creat("asset.horse.getSkillView.mc3");
         mc3.mouseChildren = false;
         mc3.mouseEnabled = false;
         mc3.x = 548;
         mc3.y = 113;
         addChild(mc3);
         LayerManager.Instance.addToLayer(mc3,LayerManager.STAGE_DYANMIC_LAYER);
         var mcw2:MovieClipWrapper = new MovieClipWrapper(mc3,true,true);
         mcw2.addEventListener(Event.COMPLETE,this.completeMc3);
      }
      
      private function completeMc3(event:Event) : void
      {
         var mcw:MovieClipWrapper = event.currentTarget as MovieClipWrapper;
         mcw.removeEventListener(Event.COMPLETE,this.completeMc3);
         this.dispose();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._getBtn))
         {
            this._getBtn.removeEventListener(MouseEvent.CLICK,this.getClickHandler);
         }
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._skillCell);
         this._bg = null;
         this._getBtn = null;
         this._skillCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

