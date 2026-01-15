package newVersionGuide
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class NewVersionGuideManager extends EventDispatcher
   {
      
      private static var _instance:NewVersionGuideManager;
      
      private static var buildingAndIconPosArr:Array = [new Point(626,161),new Point(1100,189),new Point(2006,167),new Point(2195,158),new Point(2235,164),new Point(-312,-107),new Point(-267,-107)];
      
      private static var npcPosArr:Array = [new Point(0,452),new Point(291,133),new Point(466,175),new Point(764,288),new Point(1251,412),new Point(1470,280),new Point(1785,135)];
      
      private static var guideTxtBitmapArr:Array = ["hall.newVersionGuide.dungeon","hall.newVersionGuide.roomList","hall.newVersionGuide.labyrinth","hall.newVersionGuide.farm","hall.newVersionGuide.ringstation","hall.newVersionGuide.email","hall.newVersionGuide.famousPeople"];
      
      private static var _arrowTypeArr:Array = [ArrowType.NEWVERSION_DUNGEON,ArrowType.NEWVERSION_ROOMLIST,ArrowType.NEWVERSION_LABYRINTH,ArrowType.NEWVERSION_FARM,ArrowType.NEWVERSION_RINGSTATION,ArrowType.NEWVERSION_MAIL,ArrowType.NEWVERSION_FAMOUSPEOPLE];
      
      private var _hallView:MovieClip;
      
      private var _paopaoMc:MovieClip;
      
      private var _npcTxt:FilterFrameText;
      
      public var completeGuideFunc:Function;
      
      public var isGuiding:Boolean = false;
      
      public var isShowOldPlayerFrame:Boolean = false;
      
      private var _index:int;
      
      private var _guideSprite:Sprite;
      
      private var _timer:Timer;
      
      public function NewVersionGuideManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : NewVersionGuideManager
      {
         if(_instance == null)
         {
            _instance = new NewVersionGuideManager();
         }
         return _instance;
      }
      
      public function setUp(hallView:MovieClip) : void
      {
         InviteManager.Instance.enabled = false;
         this.isGuiding = true;
         this._hallView = hallView;
         var guideView:NewVersionGuideTipView = new NewVersionGuideTipView(1);
         LayerManager.Instance.addToLayer(guideView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function startGuide() : void
      {
         this._guideSprite = new Sprite();
         LayerManager.Instance.addToLayer(this._guideSprite,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.guide(this._index);
      }
      
      private function guide(index:int) : void
      {
         var tempIndex:int = 0;
         if(this._index >= 14)
         {
            this.dispose();
            return;
         }
         TweenLite.killTweensOf(this._hallView);
         if(index < 5)
         {
            TweenLite.to(this._hallView,2,{
               "x":-buildingAndIconPosArr[index].x,
               "onComplete":this.showGuideTxt
            });
         }
         else if(index < 7)
         {
            this.showGuideTxt();
         }
         else
         {
            tempIndex = index - 7;
            if(tempIndex == 1 || tempIndex == 2)
            {
               this.guide(++this._index);
            }
            else
            {
               TweenLite.to(this._hallView,2,{
                  "x":-npcPosArr[tempIndex].x,
                  "onComplete":this.showGuideTxt
               });
            }
         }
      }
      
      private function showGuideTxt() : void
      {
         if(this._index < 5)
         {
            if(this._index == 4)
            {
               NewHandContainer.Instance.showArrow(_arrowTypeArr[this._index],-135,new Point(160,0),guideTxtBitmapArr[this._index],"hall.ringStation.buildingTip.pos",this._guideSprite,3000,true);
            }
            else
            {
               NewHandContainer.Instance.showArrow(_arrowTypeArr[this._index],180,new Point(0,0),guideTxtBitmapArr[this._index],"hall.buildingTip.pos",this._guideSprite,3000,true);
            }
         }
         else if(this._index < 7)
         {
            NewHandContainer.Instance.showArrow(_arrowTypeArr[this._index],180,buildingAndIconPosArr[this._index],guideTxtBitmapArr[this._index],"hall.ringStation.icon.pos" + this._index,this._guideSprite,3000,true);
         }
         else
         {
            if(!this._paopaoMc)
            {
               this._paopaoMc = ComponentFactory.Instance.creat("ChatBallPaopao");
               this._guideSprite.addChild(this._paopaoMc);
            }
            else
            {
               this._paopaoMc.visible = true;
            }
            if(!this._npcTxt)
            {
               this._npcTxt = ComponentFactory.Instance.creatComponentByStylename("newVersionGuide.npcTxt");
               this._paopaoMc.addChild(this._npcTxt);
            }
            else
            {
               this._npcTxt.visible = true;
            }
            PositionUtils.setPos(this._paopaoMc,"hall.npcPaopao.pos" + this._index);
            this._npcTxt.text = LanguageMgr.GetTranslation("newVersionGuide.npcTxt" + this._index);
         }
         ++this._index;
         this._timer = new Timer(3000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__guideNextHanlder);
         this._timer.start();
      }
      
      private function dispose() : void
      {
         TweenLite.killTweensOf(this._hallView);
         this._hallView.x = 0;
         for(var i:int = 0; i < _arrowTypeArr.length; i++)
         {
            NewHandContainer.Instance.clearArrowByID(_arrowTypeArr[i]);
         }
         ObjectUtils.disposeObject(this._npcTxt);
         this._npcTxt = null;
         this._guideSprite.removeChild(this._paopaoMc);
         this._paopaoMc = null;
         this._guideSprite.parent.removeChild(this._guideSprite);
         this._guideSprite = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__guideNextHanlder);
            this._timer = null;
         }
         this.endGuide();
      }
      
      private function endGuide() : void
      {
         InviteManager.Instance.enabled = true;
         this.isGuiding = false;
         var guideView:NewVersionGuideTipView = new NewVersionGuideTipView(2,this.completeGuideFunc);
         LayerManager.Instance.addToLayer(guideView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __guideNextHanlder(event:TimerEvent) : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__guideNextHanlder);
         }
         if(Boolean(this._paopaoMc) && Boolean(this._npcTxt))
         {
            this._npcTxt.visible = false;
            this._paopaoMc.visible = false;
         }
         this.guide(this._index);
      }
   }
}

