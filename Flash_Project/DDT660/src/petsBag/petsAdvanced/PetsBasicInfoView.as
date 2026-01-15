package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.event.PetsAdvancedEvent;
   import petsBag.view.item.PetBigItem;
   import petsBag.view.item.StarBar;
   
   public class PetsBasicInfoView extends Sprite implements Disposeable
   {
      
      private var _petName:FilterFrameText;
      
      private var _starBar:StarBar;
      
      private var _lv:Bitmap;
      
      private var _lvTxt:FilterFrameText;
      
      private var _petBigItem:PetBigItem;
      
      private var _advancedMc:MovieClip;
      
      private var _times:int = 0;
      
      public function PetsBasicInfoView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(PetsAdvancedEvent.STARORGRADE_MOVIE_COMPLETE,this.__movieHandler);
      }
      
      protected function __movieHandler(event:PetsAdvancedEvent) : void
      {
         this._advancedMc = ComponentFactory.Instance.creat("petsBag.advanced.AdvancedMc");
         addChild(this._advancedMc);
         PositionUtils.setPos(this._advancedMc,"petsBag.advaced.advancedMcPos");
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      protected function __enterFrame(event:Event) : void
      {
         if(Boolean(this._advancedMc) && this._advancedMc.currentFrame >= 22)
         {
            ++this._times;
            if(this._times == 3)
            {
               this._times = 0;
               this._advancedMc.stop();
               removeChild(this._advancedMc);
               removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
               dispatchEvent(new PetsAdvancedEvent(PetsAdvancedEvent.ALL_MOVIE_COMPLETE));
            }
         }
      }
      
      private function initView() : void
      {
         this._petName = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.PetName");
         addChild(this._petName);
         PositionUtils.setPos(this._petName,"petsBag.advaced.petNamePos");
         this._lv = ComponentFactory.Instance.creatBitmap("assets.petsBag.Lv");
         addChild(this._lv);
         PositionUtils.setPos(this._lv,"petsBag.advaced.lvBitmapPos");
         this._lvTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.Lv");
         addChild(this._lvTxt);
         PositionUtils.setPos(this._lvTxt,"petsBag.advaced.lvTxtPos");
         this._starBar = new StarBar();
         PositionUtils.setPos(this._starBar,"petsBag.advaced.starBarPos");
         addChild(this._starBar);
         this._petBigItem = new PetBigItem();
         PositionUtils.setPos(this._petBigItem,"petsBag.advaced.petBigItemPos");
         addChild(this._petBigItem);
      }
      
      public function setInfo(info:PetInfo) : void
      {
         this._petName.text = info.Name;
         this._lvTxt.text = Boolean(info) ? info.Level.toString() : "";
         this._starBar.starNum(Boolean(info) ? info.StarLevel : 0);
         this._petBigItem.info = info;
         this._petBigItem.initTips();
         if(Boolean(this._petBigItem.fightImg))
         {
            this._petBigItem.fightImg.visible = false;
         }
      }
      
      public function updateStar(starLevel:int) : void
      {
         this._starBar.starNum(starLevel);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(PetsAdvancedEvent.STARORGRADE_MOVIE_COMPLETE,this.__movieHandler);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._petName);
         this._petName = null;
         ObjectUtils.disposeObject(this._lv);
         this._lv = null;
         ObjectUtils.disposeObject(this._lvTxt);
         this._lvTxt = null;
         ObjectUtils.disposeObject(this._starBar);
         this._starBar = null;
         ObjectUtils.disposeObject(this._petBigItem);
         this._petBigItem = null;
         ObjectUtils.disposeObject(this._advancedMc);
         this._advancedMc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

